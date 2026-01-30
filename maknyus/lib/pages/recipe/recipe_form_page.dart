import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({super.key});
  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stepsController = TextEditingController();
  final imageController = TextEditingController();
  String selectedCategory = 'Makanan Nusantara';
  String? editId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    editId = ModalRoute.of(context)?.settings.arguments as String?;
    if (editId != null) {
      FirebaseFirestore.instance
          .collection('recipes')
          .doc(editId)
          .get()
          .then((doc) {
        var d = doc.data()!;
        nameController.text = d['name'];
        ingredientsController.text = d['ingredients'];
        stepsController.text = d['steps'];
        imageController.text = d['imageUrl'];
        setState(() => selectedCategory = d['category']);
      });
    }
  }

  void _saveRecipe() async {
    var recipeData = {
      'name': nameController.text,
      'category': selectedCategory,
      'ingredients': ingredientsController.text,
      'steps': stepsController.text,
      'imageUrl': imageController.text,
    };
    if (editId == null) {
      await FirebaseFirestore.instance
          .collection('recipes')
          .add({...recipeData, 'rating': 0});
    } else {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(editId)
          .update(recipeData);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(editId == null ? "Tambah Resep" : "Edit Resep"),
          backgroundColor: Colors.orange),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Resep")),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: ['Makanan Nusantara', 'Snack & Dessert']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCategory = v!),
              decoration: const InputDecoration(labelText: "Kategori"),
            ),
            TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                    labelText: "URL Gambar", hintText: "https://...")),
            TextFormField(
                controller: ingredientsController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Bahan")),
            TextFormField(
                controller: stepsController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Langkah")),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Simpan",
                    style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
