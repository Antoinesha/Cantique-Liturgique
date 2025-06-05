import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cantique_liturgique/auth_gate.dart';
import 'package:cantique_liturgique/screens/presentation_screen.dart';
import 'package:cantique_liturgique/screens/onboarding_screen.dart';
import 'package:cantique_liturgique/screens/welcome_screen.dart';
import 'package:cantique_liturgique/screens/login_screen.dart';
import 'package:cantique_liturgique/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔁 Activer la persistance hors-ligne Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cantique Liturgique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/presentation',
      routes: {
        '/presentation': (_) => const PresentationScreen(),
        // '/onboarding': (_) => const OnboardingScreen(),
        // '/welcome': (_) => const WelcomeScreen(),
        // '/login': (_) => const LoginScreen(),
        // Tu peux ajouter ici d’autres routes au besoin
      },
    );
  }
}
