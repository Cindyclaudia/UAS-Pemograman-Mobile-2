import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dapur_kita/models/recipe_model.dart';

class ApiService {
  // GANTI IP INI dengan IP Laptop kamu (cek di cmd: ipconfig)
  static const String baseUrl = "http://192.168.1.6/dapur_kita/api";

  // Fungsi ambil semua resep
  Future<List<Recipe>> getAllRecipes() async {
    final response = await http.get(Uri.parse("$baseUrl/list_resep.php"));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Recipe.fromJson(data)).toList();
    } else {
      throw Exception('Gagal mengambil data dari server');
    }
  }
}