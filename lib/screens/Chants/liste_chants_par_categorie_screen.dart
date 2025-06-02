import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chant_detail_screen.dart';

class ListeChantsParCategorieScreen extends StatelessWidget {
  final String categorie;

  const ListeChantsParCategorieScreen({required this.categorie, super.key});

  Future<List<DocumentSnapshot>> _fetchChantsParCategorie() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chants')
        .where('categorie', isEqualTo: categorie)
        .orderBy('titre')
        .get(const GetOptions(source: Source.cache));

    if (snapshot.docs.isEmpty) {
      final fresh =
          await FirebaseFirestore.instance
              .collection('chants')
              .where('categorie', isEqualTo: categorie)
              .orderBy('titre')
              .get();
      return fresh.docs;
    }

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chants - $categorie")),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchChantsParCategorie(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun chant pour '$categorie'"));
          }

          final chants = snapshot.data!;

          return ListView.builder(
            itemCount: chants.length,
            itemBuilder: (context, index) {
              final doc = chants[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['titre'] ?? 'Sans titre'),
                subtitle: Text(data['temps_liturgique'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChantDetailScreen(
                            titre: data['titre'] ?? '',
                            paroles: data['paroles'] ?? '',
                            categorie: data['categorie'] ?? '',
                            tempsLiturgique: data['temps_liturgique'] ?? '',
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
