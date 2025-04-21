import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MekanListesiSayfasi extends StatelessWidget {
  const MekanListesiSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mekanlar"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mekanlar').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu."));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final mekanlar = snapshot.data!.docs;

          if (mekanlar.isEmpty) {
            return const Center(child: Text("Henüz mekan eklenmemiş."));
          }

          return ListView.builder(
            itemCount: mekanlar.length,
            itemBuilder: (context, index) {
              var mekan = mekanlar[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(mekan['ad'] ?? 'Adsız Mekan'),
                  subtitle: Text(mekan['aciklama'] ?? 'Açıklama yok'),
                  trailing: Text("⭐ ${mekan['puan'] ?? 0}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
