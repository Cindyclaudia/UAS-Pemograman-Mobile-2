import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeListPage extends StatelessWidget {
  final String category;

  // Constructor untuk menerima kategori yang diklik (Nusantara atau Snack)
  const RecipeListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // MENGHUBUNGKAN KE FIREBASE SECARA REAL-TIME
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .where('category', isEqualTo: category)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Tampilan jika sedang loading atau mencari data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.orange));
          }

          // Tampilan jika data di Firebase masih kosong
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text("Belum ada resep di kategori ini.",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // MENAMPILKAN DAFTAR RESEP DALAM BENTUK LIST
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.restaurant, color: Colors.white),
                  ),
                  title: Text(data['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "Bahan: ${data['ingredients']}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      // FITUR HAPUS RESEP DARI DATABASE
                      FirebaseFirestore.instance
                          .collection('recipes')
                          .doc(data.id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Resep berhasil dihapus")));
                    },
                  ),
                  onTap: () {
                    // Di sini kamu bisa tambahkan navigasi ke halaman detail jika perlu
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
