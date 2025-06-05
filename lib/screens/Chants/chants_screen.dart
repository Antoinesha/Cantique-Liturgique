import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chant_detail_screen.dart';
import 'ajout_chant_screen.dart';

class ChantsScreen extends StatelessWidget {
  const ChantsScreen({super.key});

  Future<List<DocumentSnapshot>> _fetchChants() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chants')
        .orderBy('titre')
        .get(const GetOptions(source: Source.cache));

    if (snapshot.docs.isEmpty) {
      final fresh =
          await FirebaseFirestore.instance
              .collection('chants')
              .orderBy('titre')
              .get();
      return fresh.docs;
    }

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chants liturgiques (hors-ligne activé)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchChants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun chant disponible."));
          }

          final chants = snapshot.data!;

          return ListView.builder(
            itemCount: chants.length,
            itemBuilder: (context, index) {
              final chant = chants[index];

              final titre = chant['titre'] ?? 'Sans titre';
              final categorie = chant['categorie'] ?? 'Inconnue';
              final paroles = chant['paroles'] ?? '';

              // 🔒 Sécurise l’accès à temps_liturgique
              final data = chant.data() as Map<String, dynamic>;
              final tempsLiturgique =
                  data.containsKey('temps_liturgique')
                      ? data['temps_liturgique']
                      : '';

              return ListTile(
                title: Text(titre),
                subtitle: Text("Catégorie : $categorie"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChantDetailScreen(
                            titre: titre,
                            paroles: paroles,
                            categorie: categorie,
                            tempsLiturgique: tempsLiturgique,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AjoutChantScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
