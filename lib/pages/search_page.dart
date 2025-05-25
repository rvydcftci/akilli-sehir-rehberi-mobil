import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mekan_detay_sayfasi.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _aramaController = TextEditingController();
  List<QueryDocumentSnapshot> aramaSonuclari = [];

  @override
  void initState() {
    super.initState();
    _aramaController.addListener(_canliArama);
  }

  void _canliArama() async {
    final kelime = _aramaController.text.trim().toLowerCase();
    if (kelime.isEmpty) {
      setState(() => aramaSonuclari = []);
      return;
    }

    final snapshot =
        await FirebaseFirestore.instance.collection('mekanlar').get();

    final sonuc = snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final ad = data['ad'].toString().toLowerCase();
      final kategori = data['kategori'].toString().toLowerCase();
      return ad.contains(kelime) || kategori.contains(kelime);
    }).toList();

    setState(() => aramaSonuclari = sonuc);
  }

  @override
  void dispose() {
    _aramaController.removeListener(_canliArama);
    _aramaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1F2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06182A),
        title: const Text(
          "🔍 Mekan Arama",
          style: TextStyle(
            fontFamily: 'Rowdies',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2F3B),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _aramaController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Mekan adı veya kategori gir...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: aramaSonuclari.isEmpty
                  ? const Center(
                      child: Text(
                        "Arama sonucuna göre mekan bulunamadı.",
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: aramaSonuclari.length,
                      itemBuilder: (context, index) {
                        final mekan = aramaSonuclari[index].data()
                            as Map<String, dynamic>;
                        return _buildMekanKart(mekan);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMekanKart(Map<String, dynamic> mekan) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MekanDetaySayfasi(mekan: mekan),
          ),
        );
      },
      child: Card(
        color: const Color(0xFF2A2F3B),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            mekan['kategori'],
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white),
        ),
      ),
    );
  }
}
