import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  // Ganti URL ini dengan URL MockAPI kamu sendiri jika berbeda
  final String baseUrl = "https://65a6390174cf427547206490.mockapi.io/recipes";

  // 1. Ambil Semua Data Resep
  Future<List<Recipe>> getRecipes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error Ambil Data: $e");
      return [];
    }
  }

  // 2. Tambah Resep Baru
  Future<bool> addRecipe(Recipe recipe) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": recipe.title,
          "category": recipe.category,
          "ingredients": recipe.ingredients,
          "instructions": recipe.instructions,
          "imageUrl": recipe.imageUrl,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 3. Update / Edit Resep
  Future<bool> updateRecipe(Recipe recipe) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/${recipe.id}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": recipe.title,
          "category": recipe.category,
          "ingredients": recipe.ingredients,
          "instructions": recipe.instructions,
          "imageUrl": recipe.imageUrl,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 4. Hapus Resep
  Future<bool> deleteRecipe(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}