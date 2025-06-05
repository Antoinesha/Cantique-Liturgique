import 'package:cantique_liturgique/screens/Auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cantique_liturgique/screens/Profiles/profil_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  /// Déconnecte l'utilisateur actuel de l'application.
  ///
  /// Cette méthode utilise FirebaseAuth pour effectuer la déconnexion.
  /// Après la déconnexion, l'utilisateur est redirigé vers l'écran d'accueil
  /// ou de connexion en supprimant toutes les routes précédentes de la pile de navigation.
  ///
  /// [context] : Le contexte de construction utilisé pour la navigation.
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Retour à l'écran de connexion ou accueil après déconnexion
    // Navigator.push(context, MaterialPageRoute(builder: (_) => WelcomeScreen()));
    // Supprimer toutes les routes précédentes de la pile de navigation
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 6,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: const Text(
                  'Gérer mon compte',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Consulter et modifier mon profil'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 6,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.logout, color: Colors.white),
                ),
                title: const Text(
                  'Se déconnecter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Déconnexion de votre compte'),
                onTap: () => _signOut(context),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Version 1.0.0 ',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Text(
                'Développé par Kant\'s Développeur Full-Stack mobile',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
