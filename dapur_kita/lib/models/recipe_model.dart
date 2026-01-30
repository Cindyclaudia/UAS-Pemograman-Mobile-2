class Recipe {
  final String id;
  final String judul;
  final String kategori;
  final String deskripsi;
  final String bahan;
  final String langkah;
  final String gambarUrl;

  Recipe({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.deskripsi,
    required this.bahan,
    required this.langkah,
    required this.gambarUrl,
  });

  // Fungsi untuk mengubah JSON dari PHP menjadi Objek Dart
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      bahan: json['bahan'] ?? '',
      langkah: json['langkah'] ?? '',
      gambarUrl: json['gambar_url'] ?? '',
    );
  }
}