import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key});

  void _updateRating(String recipeId, int newRating) async {
    await FirebaseFirestore.instance.collection('recipes').doc(recipeId).update({'rating': newRating});
  }

  void _toggleFavorite(BuildContext context, String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('favorites').doc(recipeId).set({
      'recipeId': recipeId, 'addedAt': Timestamp.now(),
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ditambahkan ke favorit!")));
  }

  @override
  Widget build(BuildContext context) {
    final String? recipeId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Resep", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(icon: const Icon(Icons.edit, color: Colors.white), 
            onPressed: () => Navigator.pushNamed(context, '/recipe-form', arguments: recipeId)),
        ],
      ),
      body: recipeId == null ? const Center(child: Text("ID Kosong")) : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').doc(recipeId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(data['imageUrl'] ?? '', width: double.infinity, height: 250, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'] ?? "", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Row(children: List.generate(5, (index) => GestureDetector(
                            onTap: () => _updateRating(recipeId, index + 1),
                            child: Icon(index < (data['rating'] ?? 0) ? Icons.star : Icons.star_border, color: Colors.orange, size: 28),
                          ))),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () => _toggleFavorite(context, recipeId),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: StadiumBorder()),
                            child: const Text("Favorit", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Text("Bahan-bahan:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(data['ingredients'] ?? ""),
                      const SizedBox(height: 20),
                      const Text("Cara Membuat:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(data['steps'] ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}