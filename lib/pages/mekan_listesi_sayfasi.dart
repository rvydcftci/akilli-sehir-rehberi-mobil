import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mekan_detay_sayfasi.dart'; // Detay sayfası import edildi

class MekanListesiSayfasi extends StatelessWidget {
  const MekanListesiSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "🌆 Mekanlar",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mekanlar').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Bir hata oluştu.",
                style: GoogleFonts.poppins(color: Colors.black54),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final mekanlar = snapshot.data!.docs;

          if (mekanlar.isEmpty) {
            return Center(
              child: Text(
                "Henüz mekan eklenmemiş.",
                style: GoogleFonts.poppins(color: Colors.black45),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: mekanlar.length,
            itemBuilder: (context, index) {
              final mekan = mekanlar[index];
              final data = mekan.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MekanDetaySayfasi(mekanVerisi: data),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: data.containsKey('gorselUrl') &&
                                data['gorselUrl'] != null
                            ? Image.network(
                                data['gorselUrl'],
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 120,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported,
                                    size: 48),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['ad'] ?? 'Mekan Adı',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['aciklama'] ?? 'Açıklama bulunamadı',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  "${data['puan'] ?? 0}",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
