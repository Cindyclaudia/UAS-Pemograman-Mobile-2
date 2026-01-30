import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resep Favorit Saya", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: user == null
          ? const Center(child: Text("Silakan login untuk melihat favorit"))
          : StreamBuilder<QuerySnapshot>(
              // Mengambil daftar ID resep dari sub-koleksi favorites milik user
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                var favoriteDocs = snapshot.data!.docs;

                if (favoriteDocs.isEmpty) {
                  return const Center(child: Text("Belum ada resep favorit"));
                }

                return ListView.builder(
                  itemCount: favoriteDocs.length,
                  itemBuilder: (context, index) {
                    String recipeId = favoriteDocs[index].id;

                    // Mengambil data detail resep asli dari koleksi 'recipes'
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('recipes').doc(recipeId).get(),
                      builder: (context, recipeSnapshot) {
                        if (!recipeSnapshot.hasData) return const SizedBox();
                        
                        var recipeData = recipeSnapshot.data!.data() as Map<String, dynamic>;

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: ListTile(
                            leading: Image.network(
                              recipeData['imageUrl'] ?? '',
                              width: 50, height: 50, fit: BoxFit.cover,
                            ),
                            title: Text(recipeData['name'] ?? ""),
                            subtitle: Text(recipeData['category'] ?? ""),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Fungsi untuk menghapus dari favorit
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('favorites')
                                    .doc(recipeId)
                                    .delete();
                              },
                            ),
                            onTap: () => Navigator.pushNamed(context, '/recipe-detail', arguments: recipeId),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}