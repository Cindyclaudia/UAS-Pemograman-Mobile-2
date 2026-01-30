import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  final String recipeId;
  const DetailScreen({super.key, required this.recipeId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // GANTI ALAMAT IP BERIKUT SESUAI HASIL IPCONFIG KAMU
  final String apiUrl =
      "http://192.168.1.10/dapur_kita/api/detail_resep.php?id=";

  Future getDetailData() async {
    var response = await http.get(Uri.parse(apiUrl + widget.recipeId));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getDetailData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.orange));
          }

          if (snapshot.hasData) {
            var data = snapshot.data;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  backgroundColor: Colors.orange,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      data['gambar_url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['judul'],
                          style: GoogleFonts.poppins(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data['kategori'],
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        ),
                        const Divider(height: 30),
                        const Text("Bahan-Bahan:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(data['bahan']),
                        const SizedBox(height: 25),
                        const Text("Langkah Memasak:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(data['langkah']),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          return const Center(child: Text("Data tidak ditemukan"));
        },
      ),
    );
  }
}
