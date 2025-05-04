import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MekanDetaySayfasi extends StatelessWidget {
  final Map<String, dynamic> mekanVerisi;

  const MekanDetaySayfasi({super.key, required this.mekanVerisi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mekanVerisi['ad'] ?? "Mekan Detayı",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: mekanVerisi['gorselUrl'] != null
                  ? Image.network(
                      mekanVerisi['gorselUrl'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50),
                      ),
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),

            const SizedBox(height: 16),

            // Mekan Adı
            Text(
              mekanVerisi['ad'] ?? 'Başlık yok',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Puan
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 5),
                Text(
                  "${mekanVerisi['puan'] ?? 0}",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Açıklama
            Text(
              "Açıklama",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mekanVerisi['aciklama'] ?? 'Açıklama bulunamadı.',
              style: GoogleFonts.quicksand(fontSize: 14),
            ),

            const SizedBox(height: 16),

            // Adres
            if (mekanVerisi['adres'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adres",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          mekanVerisi['adres'],
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 30),

            // Yorum UI (sadece görsel)
            Text(
              "Yorum Yap",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Yorumunuzu yazın...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // 4. haftada Firestore'a yorum eklenecek
              },
              child: const Text("Gönder"),
            )
          ],
        ),
      ),
    );
  }
}
