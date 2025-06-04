import 'dart:io';

import 'package:cantique_liturgique/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Controllers
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final lieuNaissanceController = TextEditingController();
  final paroisseController = TextEditingController();
  final fonctionController = TextEditingController();
  final emailController = TextEditingController();
  final instrumentsController = TextEditingController();

  String? _sexe;
  DateTime? _birthDate;
  String? _statutGalcam;
  String? _niveauMusical;
  File? _image;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? userId;

        if (emailController.text.isNotEmpty) {
          final cred = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: emailController.text,
                password: "PasswordTemp123!", // temporaire
              );
          userId = cred.user!.uid;
        } else {
          userId = FirebaseFirestore.instance.collection('users').doc().id;
        }

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'nom': nomController.text,
          'prenom': prenomController.text,
          'sexe': _sexe,
          'date_naissance': _birthDate?.toIso8601String(),
          'lieu_naissance': lieuNaissanceController.text,
          'paroisse': paroisseController.text,
          'statut_galcam': _statutGalcam,
          'fonction': fonctionController.text,
          'email': emailController.text,
          'niveau_musical': _niveauMusical,
          'instruments': instrumentsController.text,
          'photo_url': '', // à faire plus tard avec Firebase Storage
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compte enregistré avec succès")),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enregistrement utilisateur")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child:
                      _image == null
                          ? const Icon(Icons.camera_alt, size: 40)
                          : null,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sexe'),
                items: const [
                  DropdownMenuItem(value: 'Homme', child: Text('Homme')),
                  DropdownMenuItem(value: 'Femme', child: Text('Femme')),
                ],
                onChanged: (value) => _sexe = value,
                validator: (value) => value == null ? 'Champ requis' : null,
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Date de naissance: "),
                  const SizedBox(width: 10),
                  Text(
                    _birthDate != null
                        ? "${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}"
                        : "Aucune",
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _birthDate = date);
                    },
                    child: const Text("Choisir"),
                  ),
                ],
              ),

              TextFormField(
                controller: lieuNaissanceController,
                decoration: const InputDecoration(
                  labelText: 'Lieu de naissance',
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),

              TextFormField(
                controller: paroisseController,
                decoration: const InputDecoration(
                  labelText: 'Paroisse d\'appartenance',
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Statut au GALCAM',
                ),
                items: const [
                  DropdownMenuItem(value: 'Membre', child: Text('Membre')),
                  DropdownMenuItem(
                    value: 'Chef de groupe',
                    child: Text('Chef de groupe'),
                  ),
                  DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                ],
                onChanged: (value) => _statutGalcam = value,
                validator: (value) => value == null ? 'Champ requis' : null,
              ),

              TextFormField(
                controller: fonctionController,
                decoration: const InputDecoration(
                  labelText: 'Fonction (si applicable)',
                ),
              ),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Niveau musical'),
                items: const [
                  DropdownMenuItem(value: 'Débutant', child: Text('Débutant')),
                  DropdownMenuItem(
                    value: 'Intermédiaire',
                    child: Text('Intermédiaire'),
                  ),
                  DropdownMenuItem(value: 'Avancé', child: Text('Avancé')),
                ],
                onChanged: (value) => _niveauMusical = value,
                validator: (value) => value == null ? 'Champ requis' : null,
              ),

              TextFormField(
                controller: instrumentsController,
                decoration: const InputDecoration(
                  labelText: 'Instruments pratiqués',
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
