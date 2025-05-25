import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MekanDetaySayfasi extends StatefulWidget {
  final Map<String, dynamic> mekan;

  const MekanDetaySayfasi({super.key, required this.mekan});

  @override
  State<MekanDetaySayfasi> createState() => _MekanDetaySayfasiState();
}

class _MekanDetaySayfasiState extends State<MekanDetaySayfasi> {
  final TextEditingController _yorumController = TextEditingController();
  double _puan = 5;

  Future<void> _yorumEkle() async {
    if (_yorumController.text.trim().isEmpty) return;

    final yorum = {
      "kullaniciAdi": "Ziyaretçi",
      "puan": _puan,
      "yorumMetni": _yorumController.text.trim(),
      "tarih": DateTime.now().toString().substring(0, 16)
    };

    await FirebaseFirestore.instance
        .collection("mekanlar")
        .doc(widget.mekan["ad"])
        .update({
      "yorumlar": FieldValue.arrayUnion([yorum])
    });

    setState(() {
      _yorumController.clear();
      _puan = 5;
      widget.mekan["yorumlar"] = [...(widget.mekan["yorumlar"] ?? []), yorum];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Yorum eklendi")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mekan = widget.mekan;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1F2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06182A),
        title: Text(
          mekan['ad'],
          style: const TextStyle(
            fontFamily: 'Rowdies',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                mekan['gorselUrl'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mekan['ad'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Rowdies',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Kategori: ${mekan['kategori']}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.favorite_border, color: Colors.white),
                    SizedBox(width: 12),
                    Icon(Icons.add_circle_outline, color: Colors.white),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      mekan['puan'].toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Colors.white70, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "${mekan['acilisSaati']} - ${mekan['kapanisSaati']}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                Text(
                  "Fiyat: ${mekan['ortalamaFiyat']}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Açıklama",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Rowdies',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mekan['aciklama'] ?? "Açıklama bulunamadı.",
              style: const TextStyle(fontSize: 15, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            if (mekan["yorumlar"] != null && mekan["yorumlar"].isNotEmpty) ...[
              const Divider(color: Colors.white38),
              const Text("🗨️ Yorumlar",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Rowdies',
                      color: Colors.white)),
              const SizedBox(height: 8),
              ...mekan["yorumlar"].map<Widget>((y) {
                return Card(
                  color: const Color(0xFF2A2F3B),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(
                      y["kullaniciAdi"] ?? "",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${y["yorumMetni"]}\n${y["puan"]} ⭐  - ${y["tarih"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              }).toList()
            ],
            const SizedBox(height: 16),
            const Divider(color: Colors.white38),
            const Text("💬 Yorum Yaz",
                style: TextStyle(
                    fontSize: 18, fontFamily: 'Rowdies', color: Colors.white)),
            const SizedBox(height: 8),
            Text("Puan: $_puan", style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            RatingBar.builder(
              initialRating: _puan,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 30,
              unratedColor: Colors.grey[600],
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _puan = rating;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _yorumController,
              decoration: const InputDecoration(
                hintText: "Yorumunuzu yazın...",
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _yorumEkle,
              icon: const Icon(Icons.send),
              label: const Text("Gönder"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
