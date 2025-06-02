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
    'sexe': '',
    'dateNaissance': null,
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

  Widget _buildSexeDateStep() {
    String? selectedSexe;
    DateTime? selectedDate;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Étape 2 sur X",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              "Parle-nous un peu plus de toi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Sexe"),
              items: const [
                DropdownMenuItem(value: 'Homme', child: Text('Homme')),
                DropdownMenuItem(value: 'Femme', child: Text('Femme')),
              ],
              onChanged: (value) {
                setLocalState(() => selectedSexe = value);
                _formData['sexe'] = value;
              },
              validator: (value) => value == null ? 'Champ requis' : null,
            ),
            const SizedBox(height: 16),
            Text(
              selectedDate == null
                  ? "Date de naissance : non sélectionnée"
                  : "Date de naissance : ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setLocalState(() => selectedDate = pickedDate);
                  _formData['date_naissance'] = pickedDate;
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text("Choisir une date"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedSexe != null && selectedDate != null) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    setState(() => _currentPage++);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Veuillez remplir les deux champs."),
                      ),
                    );
                  }
                },
                child: const Text("Suivant"),
              ),
            ),
          ],
        );
      },
    );
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
            _buildSexeDateStep(),
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
