import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AjoutChantScreen extends StatefulWidget {
  const AjoutChantScreen({super.key});

  @override
  State<AjoutChantScreen> createState() => _AjoutChantScreenState();
}

class _AjoutChantScreenState extends State<AjoutChantScreen> {
  final _formKey = GlobalKey<FormState>();

  String _titre = '';
  String _paroles = '';
  String _categorie = '';
  String _tempsLiturgique = '';
  bool _isSubmitting = false;

  Future<void> _enregistrerChant() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('chants').add({
        'titre': _titre,
        'paroles': _paroles,
        'categorie': _categorie,
        'temps_liturgique':
            _tempsLiturgique.isNotEmpty
                ? _tempsLiturgique
                : '', // 🔐 Toujours présent, même vide
        'created_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chant ajouté avec succès")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un chant")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Titre"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Champ requis" : null,
                onSaved: (value) => _titre = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Catégorie"),
                onSaved: (value) => _categorie = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Temps liturgique",
                ),
                onSaved: (value) => _tempsLiturgique = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Paroles"),
                maxLines: 8,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Champ requis" : null,
                onSaved: (value) => _paroles = value ?? '',
              ),
              const SizedBox(height: 20),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _enregistrerChant,
                    child: const Text("Valider le chant"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
