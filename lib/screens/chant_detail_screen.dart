import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChantDetailScreen extends StatefulWidget {
  final String titre;
  final String paroles;
  final String categorie;
  final String tempsLiturgique;

  const ChantDetailScreen({
    required this.titre,
    required this.paroles,
    required this.categorie,
    required this.tempsLiturgique,
    super.key,
  });

  @override
  State<ChantDetailScreen> createState() => _ChantDetailScreenState();
}

class _ChantDetailScreenState extends State<ChantDetailScreen> {
  bool _isFavorite = false;
  String? _chantId;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final query =
        await FirebaseFirestore.instance
            .collection('chants')
            .where('titre', isEqualTo: widget.titre)
            .limit(1)
            .get();

    if (query.docs.isEmpty) return;
    _chantId = query.docs.first.id;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final List<dynamic> favoris = userDoc['favoris'] ?? [];
    setState(() {
      _isFavorite = favoris.contains(_chantId);
    });
  }

  Future<void> _toggleFavori() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || _chantId == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDoc = await userRef.get();
    final List<dynamic> favoris = userDoc['favoris'] ?? [];

    if (_isFavorite) {
      favoris.remove(_chantId);
    } else {
      favoris.add(_chantId);
    }

    await userRef.update({'favoris': favoris});
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titre),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavori,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Catégorie : ${widget.categorie}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            if (widget.tempsLiturgique.trim().isNotEmpty) ...[
              Text(
                "Temps liturgique : ${widget.tempsLiturgique}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              "Paroles :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.paroles,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
