import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/recipe.dart';

class RecipeService {
  List<Recipe>? _cache;

  Future<List<Recipe>> getRecipes() async {
    if (_cache != null) return _cache!;

    final jsonString =
        await rootBundle.loadString('assets/data/recipes.json');

    final List data = json.decode(jsonString);

    _cache = data.map((e) => Recipe.fromJson(e)).toList();

    return _cache!;
  }
}