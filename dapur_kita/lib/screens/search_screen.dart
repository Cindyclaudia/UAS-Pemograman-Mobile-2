import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe_model.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          decoration: const InputDecoration(hintText: "Cari resep...", border: InputBorder.none),
          onChanged: (value) {
            setState(() { query = value; });
          },
        ),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: ApiService().getAllRecipes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          // Filter data berdasarkan input user
          var filtered = snapshot.data!.where((r) => r.judul.toLowerCase().contains(query.toLowerCase())).toList();

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filtered[index].judul),
                leading: Image.network(filtered[index].gambarUrl, width: 50),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DetailScreen(recipeId: filtered[index].id)
                )),
              );
            },
          );
        },
      ),
    );
  }
}