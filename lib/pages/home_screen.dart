import 'package:flutter/material.dart';
import 'package:akilli_sehir_rehberi_mobil/pages/mekan_listesi_sayfasi.dart';
import 'package:akilli_sehir_rehberi_mobil/pages/search_page.dart';
import 'package:akilli_sehir_rehberi_mobil/pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MekanListesiSayfasi(),
    const SearchPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Mekanlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Arama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
