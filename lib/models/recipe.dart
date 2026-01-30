class Recipe {
  final String id;
  final String title;
  final String category;
  final String ingredients;
  final String instructions;
  final String imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      ingredients: json['ingredients'] ?? '',
      instructions: json['instructions'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "category": category,
      "ingredients": ingredients,
      "instructions": instructions,
      "imageUrl": imageUrl,
    };
  }
}