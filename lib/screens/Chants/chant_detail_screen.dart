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
  bool _isLoadingFavori = false; // Ajouté pour gérer le chargement du bouton

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
    setState(() {
      _chantId = query.docs.first.id;
    });

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final List<dynamic> favoris = userDoc['favoris'] ?? [];
    setState(() {
      _isFavorite = favoris.contains(_chantId);
    });
  }

  Future<void> _toggleFavori() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (_chantId == null || _isLoadingFavori) return;
    if (uid == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vous devez être connecté pour ajouter un favori.")),
        );
      }
      return;
    }
    setState(() {
      _isLoadingFavori = true;
      _isFavorite = !_isFavorite; // Met à jour l'état local immédiatement
    });

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDoc = await userRef.get();
    final List<dynamic> favoris = List.from(userDoc['favoris'] ?? []);

    String message;
    if (_isFavorite) {
      if (!favoris.contains(_chantId)) {
        favoris.add(_chantId);
        message = "Ajouté aux favoris";
      } else {
        message = "Déjà dans les favoris";
      }
    } else {
      favoris.remove(_chantId);
      message = "Retiré des favoris";
    }

    await userRef.update({'favoris': favoris});
    setState(() {
      _isLoadingFavori = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.titre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                _chantId == null || _isLoadingFavori
                    ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.amber,
                      ),
                    )
                    : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        _isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        key: ValueKey(_isFavorite),
                        color: Colors.amber,
                        size: 30,
                      ),
                    ),
            onPressed:
                (_chantId == null || _isLoadingFavori) ? null : _toggleFavori,
            tooltip:
                _isFavorite ? "Retirer des favoris" : "Ajouter aux favoris",
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFede7f6), Color(0xFFb39ddb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                widget.categorie,
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: Colors.deepPurple.shade50,
                              avatar: const Icon(
                                Icons.category,
                                color: Colors.deepPurple,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (widget.tempsLiturgique.trim().isNotEmpty)
                              Chip(
                                label: Text(
                                  widget.tempsLiturgique,
                                  style: const TextStyle(
                                    color: Colors.purple,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                backgroundColor: Colors.purple.shade50,
                                avatar: const Icon(
                                  Icons.event_note,
                                  color: Colors.purple,
                                  size: 18,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1.2),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.music_note,
                              color: Colors.deepPurple,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Paroles",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Material(
                      elevation: 2,
                      color: Colors.white.withOpacity(0.93),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: SelectableText(
                            widget.paroles,
                            style: const TextStyle(
                              fontSize: 17,
                              height: 1.7,
                              fontFamily: 'Georgia',
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 5,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
