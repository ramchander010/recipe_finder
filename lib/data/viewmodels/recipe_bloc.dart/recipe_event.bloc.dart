abstract class RecipeEvent {}

class LoadRecipes extends RecipeEvent {}

class FilterRecipes extends RecipeEvent {
  final String? cuisine;
  final String? ingredient;

  FilterRecipes({this.cuisine, this.ingredient});
}

class LoadRecipeById extends RecipeEvent {
  final String id;
  LoadRecipeById(this.id);
}

class ToggleFavorite extends RecipeEvent {
  final String recipeId;
  ToggleFavorite(this.recipeId);
}

/// 🔒 internal event (do not use outside)
class InitFavorites extends RecipeEvent {
  final List<String> ids;
  InitFavorites(this.ids);
}
class FilterByCategory extends RecipeEvent {
  final String type;
  final String value;

  FilterByCategory(this.type, this.value);
}
class SearchRecipes extends RecipeEvent {
  final String query;

   SearchRecipes(this.query);
}