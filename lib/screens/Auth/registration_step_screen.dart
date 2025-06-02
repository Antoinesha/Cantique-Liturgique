import 'package:flutter/material.dart';

class RegistrationStepsScreen extends StatefulWidget {
  const RegistrationStepsScreen({super.key});

  @override
  State<RegistrationStepsScreen> createState() =>
      _RegistrationStepsScreenState();
}

class _RegistrationStepsScreenState extends State<RegistrationStepsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Données temporaires stockées ici (à soumettre à la fin)
  final Map<String, dynamic> _formData = {
    'nom': '',
    'prenom': '',
    // Les autres viendront ensuite
  };

  final _formKey = GlobalKey<FormState>();

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildNomPrenomStep(),
            // Les autres étapes viendront ensuite
          ],
        ),
      ),
    );
  }

  Widget _buildNomPrenomStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Étape 1 sur X",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          const Text(
            "Quel est ton nom et prénom ?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: "Nom"),
            validator: (value) => value!.isEmpty ? 'Champ requis' : null,
            onSaved: (value) => _formData['nom'] = value,
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(labelText: "Prénom"),
            validator: (value) => value!.isEmpty ? 'Champ requis' : null,
            onSaved: (value) => _formData['prenom'] = value,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text("Suivant"),
            ),
          ),
        ],
      ),
    );
  }
}
