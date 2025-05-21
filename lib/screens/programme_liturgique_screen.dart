import 'package:flutter/material.dart';
import 'liste_chants_par_categorie_screen.dart';

class ProgrammeLiturgiqueScreen extends StatelessWidget {
  const ProgrammeLiturgiqueScreen({super.key});

  final List<String> _categories = const [
    'Entrée',
    'Salutation',
    'Adoration',
    'Confession',
    'Déclaration',
    'Loi',
    'Sortie',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programme liturgique")),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(category),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            ListeChantsParCategorieScreen(categorie: category),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
