import 'package:recipe_app/data/models/recipe.dart';

enum RecipeStatus { initial, loading, success, error }

class RecipeState {
  final RecipeStatus status;
  final List<Recipe> allRecipes;
  final List<Recipe> filteredRecipes;

  final Recipe? selectedRecipe;
  final Set<String> favoriteIds;

  const RecipeState({
    this.status = RecipeStatus.initial,
    this.allRecipes = const [],
    this.filteredRecipes = const [],
    this.selectedRecipe,
    this.favoriteIds = const {},
  });

  RecipeState copyWith({
    RecipeStatus? status,
    List<Recipe>? allRecipes,
    List<Recipe>? filteredRecipes,
    Recipe? selectedRecipe,
    Set<String>? favoriteIds,
  }) {
    return RecipeState(
      status: status ?? this.status,
      allRecipes: allRecipes ?? this.allRecipes,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      selectedRecipe: selectedRecipe ?? this.selectedRecipe,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}
