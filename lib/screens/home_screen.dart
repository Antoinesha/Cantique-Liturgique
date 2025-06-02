import 'package:cantique_liturgique/screens/Chants/chants_screen.dart';
import 'package:cantique_liturgique/screens/Chants/favoris_screen.dart';
import 'package:cantique_liturgique/screens/Profiles/profil_screen.dart';
import 'package:cantique_liturgique/screens/programme_liturgique_screen.dart';
import 'package:cantique_liturgique/screens/Search/recherche_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    //Center(child: Text("🏠 Accueil")),
    const ChantsScreen(),
    const RechercheScreen(),

    //Center(child: Text("🔍 Recherche de chants")),
    //Center(child: Text("⭐ Favoris")),
    const FavorisScreen(),
    const ProgrammeLiturgiqueScreen(),
    //Center(child: Text("👤 Profil utilisateur")),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receuil liturgique')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          //BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_sharp),
            label: 'Chants',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favoris'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Programme',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
