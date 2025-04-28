import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MekanListesiSayfasi extends StatelessWidget {
  const MekanListesiSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Siyah arka plan
      appBar: AppBar(
        title: Text(
          "🌃 Mekanlar",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mekanlar').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Bir hata oluştu.",
                style: GoogleFonts.poppins(color: Colors.white),
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
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // iki sütunlu grid
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: mekanlar.length,
            itemBuilder: (context, index) {
              var mekan = mekanlar[index];
              var mekanData = mekan.data() as Map<String, dynamic>;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: mekanData.containsKey('gorselUrl') &&
                              mekanData['gorselUrl'] != null
                          ? Image.network(
                              mekanData['gorselUrl'],
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 100,
                              color: Colors.grey,
                              child: const Icon(Icons.image,
                                  color: Colors.white54, size: 50),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mekanData['ad'] ?? 'Adsız Mekan',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mekanData['aciklama'] ?? 'Açıklama yok',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.star,
                                  size: 16, color: Colors.amber),
                              const SizedBox(width: 3),
                              Text(
                                "${mekanData['puan'] ?? 0}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
