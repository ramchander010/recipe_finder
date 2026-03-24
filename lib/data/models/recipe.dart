enum Difficulty { easy, medium, hard }

class Recipe {
  final String id;
  final String title;
  final String imageUrl;

  final double rating;
  final int reviewCount;

  final int durationMinutes;
  final int servings;

  final List<String> cuisines;
  final List<String> mealTypes;
  final List<String> tags;

  final List<String> searchableIngredients;

  final Difficulty difficulty;

  final bool isVeg;
  final bool isVegan;
  final bool isGlutenFree;

  final int calories;
  final int protein;
  final int carbs;
  final int fats;

  final List<Ingredient> ingredients;
  final List<String> steps;

  const Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.durationMinutes,
    required this.servings,
    required this.cuisines,
    required this.mealTypes,
    required this.tags,
    required this.searchableIngredients,
    required this.difficulty,
    required this.isVeg,
    required this.isVegan,
    required this.isGlutenFree,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.ingredients = const [],
    this.steps = const [],
  });

  /// ✅ fromJson
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',

      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,

      durationMinutes: json['durationMinutes'] ?? 0,
      servings: json['servings'] ?? 1,

      cuisines: List<String>.from(json['cuisines'] ?? []),
      mealTypes: List<String>.from(json['mealTypes'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),

      searchableIngredients:
          List<String>.from(json['searchableIngredients'] ?? []),

      difficulty: parseDifficulty(json['difficulty']),

      isVeg: json['isVeg'] ?? false,
      isVegan: json['isVegan'] ?? false,
      isGlutenFree: json['isGlutenFree'] ?? false,

      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? 0,
      carbs: json['carbs'] ?? 0,
      fats: json['fats'] ?? 0,

      ingredients: (json['ingredients'] as List? ?? [])
          .map((e) => Ingredient.fromJson(e))
          .toList(),

      steps: List<String>.from(json['steps'] ?? []),
    );
  }

  /// ✅ toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'durationMinutes': durationMinutes,
      'servings': servings,
      'cuisines': cuisines,
      'mealTypes': mealTypes,
      'tags': tags,
      'searchableIngredients': searchableIngredients,
      'difficulty': difficulty.name,
      'isVeg': isVeg,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps,
    };
  }

  /// ✅ copyWith (VERY IMPORTANT for Bloc)
  Recipe copyWith({
    String? id,
    String? title,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? durationMinutes,
    int? servings,
    List<String>? cuisines,
    List<String>? mealTypes,
    List<String>? tags,
    List<String>? searchableIngredients,
    Difficulty? difficulty,
    bool? isVeg,
    bool? isVegan,
    bool? isGlutenFree,
    int? calories,
    int? protein,
    int? carbs,
    int? fats,
    List<Ingredient>? ingredients,
    List<String>? steps,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      servings: servings ?? this.servings,
      cuisines: cuisines ?? this.cuisines,
      mealTypes: mealTypes ?? this.mealTypes,
      tags: tags ?? this.tags,
      searchableIngredients:
          searchableIngredients ?? this.searchableIngredients,
      difficulty: difficulty ?? this.difficulty,
      isVeg: isVeg ?? this.isVeg,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  @override
  String toString() => 'Recipe(id: $id, title: $title)';
}
class Ingredient {
  final String name;
  final double quantity;
  final String unit;

  final bool isPrimary;
  final List<String> tags;

  const Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.isPrimary = false,
    this.tags = const [],
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'isPrimary': isPrimary,
      'tags': tags,
    };
  }
}
Difficulty parseDifficulty(String? value) {
  switch (value) {
    case 'easy':
      return Difficulty.easy;
    case 'medium':
      return Difficulty.medium;
    case 'hard':
      return Difficulty.hard;
    default:
      return Difficulty.easy;
  }
}