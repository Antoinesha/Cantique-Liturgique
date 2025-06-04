import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminEditScreen extends StatelessWidget {
  const AdminEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modération des chants"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('pending_approvals')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun chant à valider."));
          }

          final chants = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chants.length,
            itemBuilder: (context, index) {
              final chant = chants[index];
              final titre = chant['titre'] ?? 'Sans titre';
              final categorie = chant['categorie'] ?? 'Inconnue';

              return ListTile(
                title: Text(titre),
                subtitle: Text("Catégorie : $categorie"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(chant['titre'] ?? 'Sans titre'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Catégorie : ${chant['categorie'] ?? 'N/A'}",
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Temps liturgique : ${chant['temps_liturgique'] ?? 'N/A'}",
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Paroles :",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(chant['paroles'] ?? ''),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Annuler"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('chants')
                                  .add({
                                    'titre': chant['titre'],
                                    'paroles': chant['paroles'],
                                    'categorie': chant['categorie'],
                                    'temps_liturgique':
                                        chant['temps_liturgique'],
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });

                              await chant.reference.delete();

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Chant validé.")),
                              );
                            },
                            child: const Text("Valider"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await chant.reference.delete();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Chant refusé.")),
                              );
                            },
                            child: const Text(
                              "Refuser",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
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
