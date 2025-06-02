import 'package:cantique_liturgique/screens/Profiles/modifier_profil_screen.dart';
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "Non renseigné",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data;

        if (data == null) {
          return const Scaffold(
            body: Center(child: Text("Aucune donnée utilisateur trouvée.")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Mon Profil")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow("Nom", data['nom'] ?? ''),
                    _buildInfoRow("Prénom", data['prenom'] ?? ''),
                    _buildInfoRow("Email", data['email'] ?? ''),
                    _buildInfoRow("Sexe", data['sexe'] ?? ''),
                    _buildInfoRow(
                      "Date de naissance",
                      (data['date_naissance'] ?? '').toString(),
                    ),
                    _buildInfoRow(
                      "Lieu de naissance",
                      data['lieu_naissance'] ?? '',
                    ),
                    _buildInfoRow("Paroisse", data['paroisse'] ?? ''),
                    _buildInfoRow("Statut GALCAM", data['statut_galcam'] ?? ''),
                    _buildInfoRow("Fonction", data['fonction'] ?? ''),
                    _buildInfoRow(
                      "Niveau musical",
                      data['niveau_musical'] ?? '',
                    ),
                    _buildInfoRow("Instruments", data['instruments'] ?? ''),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        // 🔜 dirige vers la page de modification
                        // Ajoute le code de direction vers la page de modification

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ModifierProfilScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Modifier mon profil"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
