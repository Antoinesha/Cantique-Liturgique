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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant,
      appBar: AppBar(
        title: const Text("Créer un compte"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.1),
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child:
                              _image == null
                                  ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: theme.colorScheme.primary,
                                  )
                                  : null,
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Material(
                            color: theme.colorScheme.primary,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: _pickImage,
                              customBorder: const CircleBorder(),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: nomController,
                            decoration: InputDecoration(
                              labelText: 'Nom',
                              prefixIcon: const Icon(Icons.badge_outlined),
                              border: const OutlineInputBorder(),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Champ requis' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: prenomController,
                            decoration: InputDecoration(
                              labelText: 'Prénom',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: const OutlineInputBorder(),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Champ requis' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Sexe',
                        prefixIcon: const Icon(Icons.wc),
                        border: const OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Homme', child: Text('Homme')),
                        DropdownMenuItem(value: 'Femme', child: Text('Femme')),
                      ],
                      onChanged: (value) => setState(() => _sexe = value),
                      validator:
                          (value) => value == null ? 'Champ requis' : null,
                      value: _sexe,
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _birthDate ?? DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => _birthDate = date);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Date de naissance',
                            prefixIcon: const Icon(Icons.cake_outlined),
                            border: const OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                            text:
                                _birthDate != null
                                    ? "${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}"
                                    : "",
                          ),
                          validator:
                              (value) =>
                                  _birthDate == null ? 'Champ requis' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: lieuNaissanceController,
                      decoration: InputDecoration(
                        labelText: 'Lieu de naissance',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      validator:
                          (value) => value!.isEmpty ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: paroisseController,
                      decoration: InputDecoration(
                        labelText: 'Paroisse d\'appartenance',
                        prefixIcon: const Icon(Icons.church_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      validator:
                          (value) => value!.isEmpty ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Statut au GALCAM',
                        prefixIcon: const Icon(Icons.verified_user_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Membre',
                          child: Text('Membre'),
                        ),
                        DropdownMenuItem(
                          value: 'Chef de groupe',
                          child: Text('Chef de groupe'),
                        ),
                        DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                      ],
                      onChanged:
                          (value) => setState(() => _statutGalcam = value),
                      validator:
                          (value) => value == null ? 'Champ requis' : null,
                      value: _statutGalcam,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: fonctionController,
                      decoration: InputDecoration(
                        labelText: 'Fonction (si applicable)',
                        prefixIcon: const Icon(Icons.work_outline),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: const OutlineInputBorder(),
                      ),
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
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Niveau musical',
                        prefixIcon: const Icon(Icons.music_note_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Débutant',
                          child: Text('Débutant'),
                        ),
                        DropdownMenuItem(
                          value: 'Intermédiaire',
                          child: Text('Intermédiaire'),
                        ),
                        DropdownMenuItem(
                          value: 'Avancé',
                          child: Text('Avancé'),
                        ),
                      ],
                      onChanged:
                          (value) => setState(() => _niveauMusical = value),
                      validator:
                          (value) => value == null ? 'Champ requis' : null,
                      value: _niveauMusical,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: instrumentsController,
                      decoration: InputDecoration(
                        labelText: 'Instruments pratiqués',
                        prefixIcon: const Icon(Icons.piano_outlined),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'Valider',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                        ),
                        onPressed: _submitForm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
