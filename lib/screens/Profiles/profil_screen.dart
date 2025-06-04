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

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.purple.withOpacity(0.1),
        child: Icon(icon, color: Colors.purple),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        value.isNotEmpty ? value : "Non renseigné",
        style: const TextStyle(fontSize: 15),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.purple.withOpacity(0.03),
      minLeadingWidth: 30,
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
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text("Mon Profil"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.purple,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              // Gradient background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 90, 16, 16),
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 28,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 48,
                                  backgroundColor: Colors.purple.shade100,
                                  child: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.purple,
                                  ),
                                ),
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.purple,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    const ModifierProfilScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "${data['prenom'] ?? ''} ${data['nom'] ?? ''}"
                                  .trim(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['email'] ?? '',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Divider(
                              color: Colors.purple.shade100,
                              thickness: 1,
                            ),
                            _buildInfoTile(
                              "Sexe",
                              data['sexe'] ?? '',
                              Icons.wc,
                            ),
                            _buildInfoTile(
                              "Date de naissance",
                              (data['date_naissance'] ?? '').toString(),
                              Icons.cake,
                            ),
                            _buildInfoTile(
                              "Lieu de naissance",
                              data['lieu_naissance'] ?? '',
                              Icons.location_on,
                            ),
                            _buildInfoTile(
                              "Paroisse",
                              data['paroisse'] ?? '',
                              Icons.church,
                            ),
                            _buildInfoTile(
                              "Statut GALCAM",
                              data['statut_galcam'] ?? '',
                              Icons.verified_user,
                            ),
                            _buildInfoTile(
                              "Fonction",
                              data['fonction'] ?? '',
                              Icons.work,
                            ),
                            _buildInfoTile(
                              "Niveau musical",
                              data['niveau_musical'] ?? '',
                              Icons.music_note,
                            ),
                            _buildInfoTile(
                              "Instruments",
                              data['instruments'] ?? '',
                              Icons.piano,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const ModifierProfilScreen(),
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
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
