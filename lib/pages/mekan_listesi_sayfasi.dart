import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:akilli_sehir_rehberi_mobil/pages/mekan_detay_sayfasi.dart';

class MekanlarPage extends StatefulWidget {
  final String? kategoriFiltre;

  const MekanlarPage({super.key, this.kategoriFiltre});

  @override
  State<MekanlarPage> createState() => _MekanlarPageState();
}

class _MekanlarPageState extends State<MekanlarPage> {
  late String seciliKategori;
  double maxFiyat = 1000;

  List<String> favoriMekanlar = [];
  List<String> gidilecekMekanlar = [];

  final List<String> kategoriler = [
    'Tümü',
    'Kafe',
    'Restoran',
    'Müze',
    'Tarihi Yer'
  ];

  @override
  void initState() {
    super.initState();
    seciliKategori = widget.kategoriFiltre ?? 'Tümü';
    _kullanicininListeleriniYukle();
  }

  void _gosterBildirim(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future<void> _kullanicininListeleriniYukle() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        favoriMekanlar = List<String>.from(data['favoriler'] ?? []);
        gidilecekMekanlar = List<String>.from(data['gidilecekler'] ?? []);
      });
    }
  }

  void favoriDegistir(String ad) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

    if (favoriMekanlar.contains(ad)) {
      favoriMekanlar.remove(ad);
      await docRef.update({
        "favoriler": FieldValue.arrayRemove([ad])
      });
      _gosterBildirim("Favorilerden çıkarıldı: $ad");
    } else {
      favoriMekanlar.add(ad);
      await docRef.set({
        "favoriler": FieldValue.arrayUnion([ad])
      }, SetOptions(merge: true));
      _gosterBildirim("Favorilere eklendi: $ad");
    }
    setState(() {});
  }

  void gidilecekDegistir(String ad) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

    if (gidilecekMekanlar.contains(ad)) {
      gidilecekMekanlar.remove(ad);
      await docRef.update({
        "gidilecekler": FieldValue.arrayRemove([ad])
      });
      _gosterBildirim("Gidilecek yerlerden çıkarıldı: $ad");
    } else {
      gidilecekMekanlar.add(ad);
      await docRef.set({
        "gidilecekler": FieldValue.arrayUnion([ad])
      }, SetOptions(merge: true));
      _gosterBildirim("Gidilecekler listesine eklendi: $ad");
    }
    setState(() {});
  }

  bool favorideMi(String ad) => favoriMekanlar.contains(ad);
  bool gidilecekMi(String ad) => gidilecekMekanlar.contains(ad);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 190, 191, 194),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 24, 42),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
        title: const Text(
          "MEKANLAR",
          style: TextStyle(
            fontFamily: 'Rowdies',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFiltreler(),
          Expanded(child: _buildMekanListesi()),
        ],
      ),
    );
  }

  Widget _buildFiltreler() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          DropdownButton<String>(
            value: seciliKategori,
            dropdownColor: const Color(0xFF2A2F3B),
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: Colors.white, fontFamily: 'Rowdies'),
            items: kategoriler.map((kategori) {
              return DropdownMenuItem(
                value: kategori,
                child: Text(kategori),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                seciliKategori = value!;
              });
            },
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color.fromARGB(255, 192, 200, 200),
              inactiveTrackColor: Colors.grey[700],
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
              valueIndicatorTextStyle: const TextStyle(color: Colors.black),
            ),
            child: Slider(
              value: maxFiyat,
              min: 0,
              max: 1000,
              divisions: 10,
              label: "$maxFiyat TL altı",
              onChanged: (value) {
                setState(() {
                  maxFiyat = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMekanListesi() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('mekanlar').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final mekanlar = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final kategoriUygun =
              seciliKategori == 'Tümü' || data['kategori'] == seciliKategori;
          final fiyatStr = data['ortalamaFiyat'].toString();
          final fiyat = double.tryParse(
                  fiyatStr.replaceAll('₺', '').replaceAll(' ', '')) ??
              0;
          final fiyatUygun =
              fiyat <= maxFiyat || fiyatStr.toLowerCase().contains("ücretsiz");
          return kategoriUygun && fiyatUygun;
        }).toList();

        if (mekanlar.isEmpty) {
          return const Center(
            child: Text(
              "Mekan bulunamadı",
              style: TextStyle(color: Colors.white, fontFamily: 'Rowdies'),
            ),
          );
        }

        return ListView.builder(
          itemCount: mekanlar.length,
          itemBuilder: (context, index) {
            final mekan = mekanlar[index].data() as Map<String, dynamic>;
            return _buildMekanKart(mekan);
          },
        );
      },
    );
  }

  Widget _buildMekanKart(Map<String, dynamic> mekan) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MekanDetaySayfasi(mekan: mekan),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color.fromARGB(255, 78, 97, 116),
        elevation: 4,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              mekan['gorselUrl'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            mekan['ad'],
            style: const TextStyle(
              fontFamily: 'Rowdies',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            "Puan: ${mekan['puan']}",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[300],
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  favorideMi(mekan['ad'])
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => favoriDegistir(mekan['ad']),
              ),
              IconButton(
                icon: Icon(
                  gidilecekMi(mekan['ad'])
                      ? Icons.check_circle
                      : Icons.add_circle_outline,
                  color: Colors.white,
                ),
                onPressed: () => gidilecekDegistir(mekan['ad']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
