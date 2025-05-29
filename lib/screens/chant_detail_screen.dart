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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEDE7F6)], // blanc → violet pâle
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catégorie : ${widget.categorie}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 4),
              if (widget.tempsLiturgique.trim().isNotEmpty)
                Text(
                  "Temps liturgique : ${widget.tempsLiturgique}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                "Paroles",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      widget.paroles,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Georgia', // liturgique et lisible
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
