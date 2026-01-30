import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchKey = '';
  String selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: const Text("Maknyus - Resep", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite, color: Colors.white), 
            onPressed: () => Navigator.pushNamed(context, '/favorites')),
          IconButton(icon: const Icon(Icons.person, color: Colors.white), 
            onPressed: () => Navigator.pushNamed(context, '/profile')),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari resep...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                  onChanged: (val) => setState(() => searchKey = val.toLowerCase()),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: ['Semua', 'Makanan Nusantara', 'Snack & Dessert'].map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: selectedCategory == cat,
                        selectedColor: Colors.white,
                        backgroundColor: Colors.orange[300],
                        labelStyle: TextStyle(color: selectedCategory == cat ? Colors.orange : Colors.white),
                        onSelected: (bool selected) => setState(() => selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs.where((doc) {
            bool matchSearch = doc['name'].toString().toLowerCase().contains(searchKey);
            bool matchCat = selectedCategory == 'Semua' || doc['category'] == selectedCategory;
            return matchSearch && matchCat;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              String docId = docs[index].id;

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10)],
                ),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/recipe-detail', arguments: docId),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(data['imageUrl'] ?? '', width: 90, height: 90, fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(width: 90, height: 90, color: Colors.grey[200], child: const Icon(Icons.broken_image))),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['name'] ?? "", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(data['category'] ?? "", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(5, (i) => Icon(
                                  i < (data['rating'] ?? 0) ? Icons.star : Icons.star_border,
                                  color: Colors.orange, size: 16)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/recipe-form'),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}