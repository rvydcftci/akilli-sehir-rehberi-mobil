import 'package:akilli_sehir_rehberi_mobil/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF252B38),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06182A),
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Profil",
              style: TextStyle(
                fontFamily: 'Rowdies',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: uid == null
          ? const Center(
              child: Text("Giriş yapılmamış.",
                  style: TextStyle(color: Colors.white)))
          : FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance.collection('users').doc(uid).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final kullaniciAdi = data?['isim'] ?? 'Ziyaretçi';
                final favoriMekanlar =
                    List<String>.from(data?['favoriler'] ?? []);
                final gidilecekMekanlar =
                    List<String>.from(data?['gidilecekler'] ?? []);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage("assets/avatars/avatar1.jpeg"),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        kullaniciAdi,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Rowdies',
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildMekanList(
                        baslik: "❤️ Favori Mekanlar",
                        mekanlar: favoriMekanlar,
                      ),
                      const SizedBox(height: 16),
                      _buildMekanList(
                        baslik: "➕ Gidilecek Mekanlar",
                        mekanlar: gidilecekMekanlar,
                      ),
                      const SizedBox(height: 32),
                      // 🔻 ÇIKIŞ BUTONU
                      ElevatedButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Çıkış Yap"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          textStyle: const TextStyle(
                            fontFamily: 'Rowdies',
                            fontSize: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMekanList({
    required String baslik,
    required List<String> mekanlar,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          baslik,
          style: const TextStyle(
            fontFamily: 'Rowdies',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2F3B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: mekanlar.isEmpty
              ? const Text(
                  "Hiç mekan eklenmemiş.",
                  style: TextStyle(color: Colors.white70),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: mekanlar
                      .map(
                        (ad) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            ad,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}
