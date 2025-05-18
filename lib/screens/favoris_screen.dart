import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chant_detail_screen.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  List<DocumentSnapshot> _favorisChants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoris();
  }

  Future<void> _loadFavoris() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final List<dynamic> favorisIds = userDoc['favoris'] ?? [];

    if (favorisIds.isEmpty) {
      setState(() {
        _favorisChants = [];
        _isLoading = false;
      });
      return;
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('chants')
            .where(FieldPath.documentId, whereIn: favorisIds)
            .get();

    setState(() {
      _favorisChants = snapshot.docs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favorisChants.isEmpty) {
      return const Center(child: Text("Aucun chant favori"));
    }

    return ListView.builder(
      itemCount: _favorisChants.length,
      itemBuilder: (context, index) {
        final doc = _favorisChants[index];
        return ListTile(
          title: Text(doc['titre']),
          subtitle: Text("Catégorie : ${doc['categorie']}"),
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
    );
  }
}
