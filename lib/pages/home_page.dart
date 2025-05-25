import 'package:flutter/material.dart';
import 'package:akilli_sehir_rehberi_mobil/pages/mekan_listesi_sayfasi.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AKILLI ŞEHİR REHBERİ",
          style: TextStyle(
            fontFamily: 'Rowdies',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 4, 19, 33),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(context),
            const SizedBox(height: 24),
            _buildKategoriKutulari(context),
            const SizedBox(height: 24),
            _buildOneCikanMekanlar(),
            const SizedBox(height: 24),
            _buildYorumlarBolumu(),
            const SizedBox(height: 24),
            _buildTavsiyeAsistaniTanitim(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🏙️ AKILLI ŞEHİR REHBERİ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color.fromARGB(255, 2, 22, 41),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Şehrindeki en iyi restoran, kafe ve kültürel noktaları kolayca keşfet. Favorilerine ekle, yorumları oku, yerini seç!",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Color(0xFF333333),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MekanlarPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.explore),
                  label: const Text("Keşfet"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 3, 18, 34),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("assets/restoran.jpeg"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriKutulari(BuildContext context) {
    final kategoriler = [
      {"emoji": "☕", "ad": "Kafe"},
      {"emoji": "🍽️", "ad": "Restoran"},
      {"emoji": "🏛️", "ad": "Müze"},
      {"emoji": "🕌", "ad": "Tarihi Yer"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          " 🌁 KATEGORİLER",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color.fromARGB(255, 34, 46, 58),
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: kategoriler.map((kategori) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MekanlarPage(kategoriFiltre: kategori["ad"]!),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kategori["emoji"]!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      kategori["ad"]!,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontFamily: 'Poppins',
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOneCikanMekanlar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "📍 ÖNE ÇIKAN YERLER",
          style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildMekanCard("Ulu Cami", "assets/ulu.jpeg", 4.7),
              _buildMekanCard("Harput Kalesi", "assets/kale.jpeg", 4.6),
              _buildMekanCard("Arabica", "assets/kafe.jpeg", 4.3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMekanCard(String ad, String resimYolu, double puan) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              resimYolu,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 15),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(puan.toString()),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildYorumlarBolumu() {
    final yorumlar = [
      {
        "kullanici": "Elif",
        "mekan": "Ulu Cami",
        "puan": 5.0,
        "yorum": "Harika bir atmosfer ve tarihi doku."
      },
      {
        "kullanici": "Efe",
        "mekan": "Chef's Garden",
        "puan": 4.5,
        "yorum": "Yemekler çok lezzetliydi, servis hızlıydı."
      },
      {
        "kullanici": "Selin",
        "mekan": "Gloria Jean's",
        "puan": 4.0,
        "yorum": "Kahvesi güzel ama biraz kalabalık."
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "💬 ZİYARETÇİ YORUMLARI",
          style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 8),
        Column(
          children: yorumlar.map((y) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: const Color(0xFF2A2F3B),
              child: ListTile(
                title: Text("👤 ${y["kullanici"]} - ${y["mekan"]}",
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text("${y["yorum"]}\n⭐ ${y["puan"]}",
                    style: const TextStyle(color: Colors.white70)),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildTavsiyeAsistaniTanitim() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🤖TAVSİYE ASİSTANI",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ruh haline ve bütçene göre sana uygun yerleri öneriyoruz.",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // Asistan sayfasına yönlendir
            },
            child: const Text("ASİSTANI AÇ"),
          )
        ],
      ),
    );
  }
}
