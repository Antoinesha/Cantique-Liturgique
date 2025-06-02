import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Chants/chant_detail_screen.dart';

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  State<RechercheScreen> createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _results = [];
  bool _isSearching = false;

  void _onSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    final snapshot =
        await FirebaseFirestore.instance.collection('chants').get();

    final allChants = snapshot.docs;

    final matches =
        allChants.where((doc) {
          final titre = (doc['titre'] ?? '').toString().toLowerCase();
          final paroles = (doc['paroles'] ?? '').toString().toLowerCase();
          return titre.contains(query.toLowerCase()) ||
              paroles.contains(query.toLowerCase());
        }).toList();

    setState(() {
      _results = matches;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearch,
            decoration: InputDecoration(
              labelText: 'Rechercher un chant',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: CircularProgressIndicator(),
          ),
        Expanded(
          child:
              _results.isEmpty
                  ? const Center(child: Text('Aucun résultat'))
                  : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final doc = _results[index];
                      return ListTile(
                        title: Text(doc['titre']),
                        subtitle: Text(doc['categorie'] ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChantDetailScreen(
                                    titre: doc['titre'],
                                    paroles: doc['paroles'],
                                    categorie: doc['categorie'],
                                    tempsLiturgique: doc['temps_liturgique'],
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
