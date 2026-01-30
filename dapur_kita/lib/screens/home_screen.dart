import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dapur_kita/services/api_service.dart';
import 'package:dapur_kita/models/recipe_model.dart';
import 'package:dapur_kita/screens/detail_screen.dart';
import 'package:dapur_kita/screens/search_screen.dart';
import 'package:dapur_kita/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // --- APPBAR DENGAN TOMBOL PROFIL ---
      appBar: AppBar(
        title: Text(
          "DapurKita",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
        ],
      ),
      
      // --- BODY DENGAN LIST DATA DARI PHP ---
      body: FutureBuilder<List<Recipe>>(
        future: apiService.getAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Gagal mengambil data resep"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada resep tersedia"));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Recipe recipe = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DetailScreen(recipeId: recipe.id)
                      ));
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Animasi Hero pada Gambar (Syarat Animasi)
                          Hero(
                            tag: recipe.id,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.network(
                                recipe.gambarUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                // Placeholder jika gambar loading
                                errorBuilder: (context, error, stackTrace) => 
                                  Container(height: 180, color: Colors.grey, child: const Icon(Icons.broken_image)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.judul,
                                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.category, size: 16, color: Colors.orange),
                                    const SizedBox(width: 5),
                                    Text(
                                      recipe.kategori,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),

      // --- FLOATING ACTION BUTTON UNTUK PENCARIAN ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.search, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
      ),
    );
  }
}