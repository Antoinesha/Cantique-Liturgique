import 'package:cantique_liturgique/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // En attente de la connexion
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si connecté, affiche l’écran principal
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Sinon, vers écran de connexion (ou onboarding si tu préfères)
        return const SplashScreen();
      },
    );
  }
}
