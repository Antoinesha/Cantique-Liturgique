import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return snapshot.data();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data;

        if (data == null) {
          return const Center(
            child: Text("Aucune donnée utilisateur trouvée."),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 16),
            Text("Nom : ${data['nom'] ?? ''}"),
            Text("Prénom : ${data['prenom'] ?? ''}"),
            Text("Email : ${data['email'] ?? ''}"),
            Text("Paroisse : ${data['paroisse'] ?? ''}"),
            Text("Statut GALCAM : ${data['statut_galcam'] ?? ''}"),
            Text("Fonction : ${data['fonction'] ?? ''}"),
            Text("Niveau musical : ${data['niveau_musical'] ?? ''}"),
            Text("Instruments : ${data['instruments'] ?? ''}"),
          ],
        );
      },
    );
  }
}
