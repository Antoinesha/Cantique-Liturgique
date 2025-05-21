import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ModifierProfilScreen extends StatefulWidget {
  const ModifierProfilScreen({super.key});

  @override
  State<ModifierProfilScreen> createState() => _ModifierProfilScreenState();
}

class _ModifierProfilScreenState extends State<ModifierProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _paroisseController = TextEditingController();
  final TextEditingController _fonctionController = TextEditingController();
  final TextEditingController _niveauController = TextEditingController();
  final TextEditingController _instrumentsController = TextEditingController();

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    _userData = doc.data() ?? {};

    _nomController.text = _userData['nom'] ?? '';
    _prenomController.text = _userData['prenom'] ?? '';
    _paroisseController.text = _userData['paroisse'] ?? '';
    _fonctionController.text = _userData['fonction'] ?? '';
    _niveauController.text = _userData['niveau_musical'] ?? '';
    _instrumentsController.text = _userData['instruments'] ?? '';

    setState(() => _isLoading = false);
  }

  Future<void> _enregistrerModifications() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'nom': _nomController.text,
      'prenom': _prenomController.text,
      'paroisse': _paroisseController.text,
      'fonction': _fonctionController.text,
      'niveau_musical': _niveauController.text,
      'instruments': _instrumentsController.text,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil mis à jour avec succès.")),
      );
      Navigator.pop(context); // Retour à l'écran profil
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier mon profil")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _nomController,
                        decoration: const InputDecoration(labelText: "Nom"),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Champ requis"
                                    : null,
                      ),
                      TextFormField(
                        controller: _prenomController,
                        decoration: const InputDecoration(labelText: "Prénom"),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Champ requis"
                                    : null,
                      ),
                      TextFormField(
                        controller: _paroisseController,
                        decoration: const InputDecoration(
                          labelText: "Paroisse",
                        ),
                      ),
                      TextFormField(
                        controller: _fonctionController,
                        decoration: const InputDecoration(
                          labelText: "Fonction",
                        ),
                      ),
                      TextFormField(
                        controller: _niveauController,
                        decoration: const InputDecoration(
                          labelText:
                              "Niveau musical (Débutant / Intermédiaire / Avancé)",
                        ),
                      ),
                      TextFormField(
                        controller: _instrumentsController,
                        decoration: const InputDecoration(
                          labelText: "Instruments pratiqués",
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _enregistrerModifications,
                        icon: const Icon(Icons.save),
                        label: const Text("Enregistrer"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
