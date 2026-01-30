// lib/resep_data.dart
class Resep {
  final String nama;
  final List<String> bahan;
  final String langkah;

  Resep({required this.nama, required this.bahan, required this.langkah});
}

final List<Resep> daftarResep = [
  Resep(
    nama: "Nasi Goreng",
    bahan: ["Nasi", "Bawang Putih", "Kecap"],
    langkah: "Tumis bumbu, masukkan nasi dan kecap, aduk rata.",
  ),
  Resep(
    nama: "Soto",
    bahan: ["Ayam", "Kunyit", "Soun"],
    langkah: "Rebus ayam dengan bumbu kuning, sajikan dengan soun.",
  ),
  Resep(
    nama: "Rendang",
    bahan: ["Daging Sapi", "Santan", "Cabai"],
    langkah: "Masak daging dengan bumbu dan santan sampai kering.",
  ),
  Resep(
    nama: "Putu Ayu",
    bahan: ["Tepung", "Kelapa Parut", "Pandan"],
    langkah: "Kukus kelapa, tuang adonan pandan, kukus sampai matang.",
  ),
  Resep(
    nama: "Bola Ubi",
    bahan: ["Ubi", "Tepung Tapioka", "Gula"],
    langkah: "Campur ubi dan tepung, bentuk bola, goreng hingga kopong.",
  ),
];