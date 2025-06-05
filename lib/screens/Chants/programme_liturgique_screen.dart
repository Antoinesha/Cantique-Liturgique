import 'package:flutter/material.dart';
import 'liste_chants_par_categorie_screen.dart';

class ProgrammeLiturgiqueScreen extends StatelessWidget {
  const ProgrammeLiturgiqueScreen({super.key});

  final List<Map<String, String>> _categories = const [
    {
      'title': 'Entrée',
      'description':
          'Ici ce sont les chants d\'entrée qui montrent la préparation à la célébration.',
      'icon': 'login',
    },
    {
      'title': 'Salutation',
      'description': 'Chants pour la salutation et l\'accueil de l\'assemblée.',
      'icon': 'waving_hand',
    },
    {
      'title': 'Adoration',
      'description': 'Chants d\'adoration pour glorifier Dieu.',
      'icon': 'star',
    },
    {
      'title': 'Confession',
      'description': 'Chants pour la confession et la demande de pardon.',
      'icon': 'favorite',
    },
    {
      'title': 'Déclaration',
      'description': 'Chants pour proclamer la foi et la grâce.',
      'icon': 'campaign',
    },
    {
      'title': 'Loi',
      'description': 'Chants relatifs à la loi et aux commandements.',
      'icon': 'gavel',
    },
    {
      'title': 'Sortie',
      'description': 'Chants de sortie pour conclure la célébration.',
      'icon': 'logout',
    },
  ];

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'login':
        return Icons.login_rounded;
      case 'waving_hand':
        return Icons.waving_hand_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'campaign':
        return Icons.campaign_rounded;
      case 'gavel':
        return Icons.gavel_rounded;
      case 'logout':
        return Icons.logout_rounded;
      default:
        return Icons.music_note_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programme liturgique"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.deepPurple.shade50,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ListeChantsParCategorieScreen(
                          categorie: category['title']!,
                        ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.deepPurple.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        _getIcon(category['icon']!),
                        color: Colors.deepPurple,
                        size: 28,
                      ),
                      radius: 28,
                    ),
                    title: Text(
                      category['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        category['description']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
