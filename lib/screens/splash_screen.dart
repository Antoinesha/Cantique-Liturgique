import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/onboarding'); // prochain écran
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/colombe1.jpg',
              height: 100,
              width: 100,
            ).animate().fade(duration: 5.seconds).scale(delay: 300.ms),
            const SizedBox(height: 20),
            const Text(
                  'Liturgie : louons le Seigneur,\nliturgie : tous pour le Seigneur',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
                .animate()
                .fade(duration: 1.seconds)
                .move(delay: 600.ms, begin: const Offset(0, 30)),
          ],
        ),
      ),
    );
  }
}
