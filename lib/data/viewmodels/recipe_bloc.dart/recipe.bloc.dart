import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/storage/app_keys.dart';
import 'package:recipe_app/core/storage/app_prefs.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:recipe_app/data/services/recipe_service.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_state.bloc.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeService service;

  RecipeBloc(this.service) : super(const RecipeState()) {
    on<LoadRecipes>(_onLoad);
    on<FilterRecipes>(_onFilter);
    on<LoadRecipeById>(_onLoadById);
    on<ToggleFavorite>(_onToggleFavorite);
    on<InitFavorites>(_onInitFavorites);
    on<FilterByCategory>(_onCategoryFilter);
    on<SearchRecipes>(_onSearch);
    _loadFavorites();
  }

  Future<void> _onLoad(LoadRecipes event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(status: RecipeStatus.loading));
    final data = await service.getRecipes();

    emit(
      state.copyWith(
        status: RecipeStatus.success,
        allRecipes: data,
        filteredRecipes: data,
      ),
    );
  }

  void _onFilter(FilterRecipes event, Emitter<RecipeState> emit) {
    final filtered = state.allRecipes.where((r) {
      if (event.cuisine != null && !r.cuisines.contains(event.cuisine)) {
        return false;
      }

      if (event.ingredient != null &&
          !r.searchableIngredients.contains(event.ingredient)) {
        return false;
      }

      return true;
    }).toList();

    emit(state.copyWith(filteredRecipes: filtered));
  }

  void _onLoadById(LoadRecipeById event, Emitter<RecipeState> emit) {
    final recipe = state.allRecipes.where((r) => r.id == event.id).firstOrNull;

    if (recipe != null) {
      emit(state.copyWith(selectedRecipe: recipe));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<RecipeState> emit,
  ) async {
    final updated = Set<String>.from(state.favoriteIds);

    if (updated.contains(event.recipeId)) {
      updated.remove(event.recipeId);
    } else {
      updated.add(event.recipeId);
    }

    Recipe? updatedSelected = state.selectedRecipe;

    if (state.selectedRecipe?.id == event.recipeId) {
      updatedSelected = state.selectedRecipe;
    }

    emit(state.copyWith(favoriteIds: updated, selectedRecipe: updatedSelected));

    await AppPrefs.setStringList(AppKeys.favorites, updated.toList());
  }

  void _onInitFavorites(InitFavorites event, Emitter<RecipeState> emit) {
    emit(state.copyWith(favoriteIds: event.ids.toSet()));
  }

  Future<void> _loadFavorites() async {
    final favs = await AppPrefs.getStringList(AppKeys.favorites) ?? [];
    add(InitFavorites(favs));
  }

  Map<String, List<Recipe>> get allLists {
    final list = List<Recipe>.from(state.allRecipes);

    final trending = List<Recipe>.from(list)
      ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));

    return {
      "favorites": list.where((r) => state.favoriteIds.contains(r.id)).toList(),
      "trending": trending.take(5).toList(),
      "topRated": list.where((r) => r.rating >= 4.5).toList(),
      "quickMeals": list.where((r) => r.durationMinutes <= 20).toList(),
      "easy": list.where((r) => r.difficulty == Difficulty.easy).toList(),
      "veg": list.where((r) => r.isVeg).toList(),
      "vegan": list.where((r) => r.isVegan).toList(),
      "glutenFree": list.where((r) => r.isGlutenFree).toList(),
      "highProtein": list.where((r) => r.protein >= 15).toList(),
      "lowCalories": list.where((r) => r.calories <= 300).toList(),
      "latest": list.reversed.take(10).toList(),
    };
  }

  bool isFavorite(String id) => state.favoriteIds.contains(id);

  Map<String, List<String>> get categories {
    final cuisines = <String>{};
    final mealTypes = <String>{};
    final tags = <String>{};
    final difficulties = <String>{};

    for (final r in state.allRecipes) {
      cuisines.addAll(r.cuisines);
      mealTypes.addAll(r.mealTypes);
      tags.addAll(r.tags);
      difficulties.add(r.difficulty.name);
    }

    return {
      "Cuisines": cuisines.toList()..sort(),
      "Meal Types": mealTypes.toList()..sort(),
      "Tags": tags.toList()..sort(),
      "Difficulty": difficulties.toList(),
      "Diet": ["Veg", "Vegan", "Gluten Free"],
    };
  }

  void _onCategoryFilter(FilterByCategory event, Emitter<RecipeState> emit) {
    final filtered = state.allRecipes.where((r) {
      switch (event.type) {
        case "Cuisines":
          return r.cuisines.contains(event.value);

        case "Meal Types":
          return r.mealTypes.contains(event.value);

        case "Tags":
          return r.tags.contains(event.value);

        case "Difficulty":
          return r.difficulty.name == event.value;

        case "Diet":
          switch (event.value) {
            case "Veg":
              return r.isVeg;
            case "Vegan":
              return r.isVegan;
            case "Gluten Free":
              return r.isGlutenFree;
            default:
              return false;
          }

        default:
          return true;
      }
    }).toList();

    emit(state.copyWith(filteredRecipes: filtered));
  }

  String formatTitle(String key) {
    switch (key) {
      case "trending":
        return "Trending Recipes";
      case "topRated":
        return "Top Rated";
      case "quickMeals":
        return "Quick Meals";
      case "easy":
        return "Easy Recipes";
      case "veg":
        return "Vegetarian";
      case "vegan":
        return "Vegan";
      case "glutenFree":
        return "Gluten Free";
      case "highProtein":
        return "High Protein";
      case "lowCalories":
        return "Low Calories";
      case "favorites":
        return "Favorites";
      case "latest":
        return "Latest";
      default:
        return key;
    }
  }

  //search
  void _onSearch(SearchRecipes event, Emitter<RecipeState> emit) {
    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      emit(state.copyWith(filteredRecipes: state.allRecipes));
      return;
    }

    /// 🔥 Clean & split
    final words = query
        .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    /// 🔥 Detect diet filters
    final isVegQuery = words.contains('veg') || words.contains('vegetarian');
    final isVeganQuery = words.contains('vegan');
    final isGlutenFreeQuery =
        words.contains('gluten') || words.contains('glutenfree');

    /// 🔥 Remove these from scoring words (important)
    final filteredWords = List<String>.from(words)
      ..removeWhere(
        (w) =>
            ['veg', 'vegan', 'vegetarian', 'gluten', 'glutenfree'].contains(w),
      );

    final scored = state.allRecipes.map((r) {
      int score = 0;

      /// 🚫 STRICT diet filtering
      if (isVegQuery && !r.isVeg) return MapEntry(r, 0);
      if (isVeganQuery && !r.isVegan) return MapEntry(r, 0);
      if (isGlutenFreeQuery && !r.isGlutenFree) {
        return MapEntry(r, 0);
      }

      for (final word in filteredWords) {
        /// 🔹 Title
        if (r.title.toLowerCase().contains(word)) score += 5;

        /// 🔹 Ingredients (STRICT match 🔥 FIX)
        if (r.searchableIngredients.any((i) => i.toLowerCase() == word)) {
          score += 4;
        }

        /// 🔹 Tags
        if (r.tags.any((t) => t.toLowerCase().contains(word))) {
          score += 3;
        }

        /// 🔹 Meal Types
        if (r.mealTypes.any((m) => m.toLowerCase().contains(word))) {
          score += 3;
        }

        /// 🔹 Cuisines
        if (r.cuisines.any((c) => c.toLowerCase().contains(word))) {
          score += 2;
        }

        /// 🔹 Difficulty
        if (r.difficulty.name.contains(word)) score += 1;
      }

      /// ✅ If ONLY diet query (like "veg"), still include recipe
      if (filteredWords.isEmpty &&
          (isVegQuery || isVeganQuery || isGlutenFreeQuery)) {
        score = 1;
      }

      return MapEntry(r, score);
    }).toList();

    final filtered = scored.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    emit(state.copyWith(filteredRecipes: filtered.map((e) => e.key).toList()));
  }
}
