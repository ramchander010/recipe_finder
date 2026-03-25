// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_state.bloc.dart';
import 'package:recipe_app/widgets/my_recipe_card_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,

      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state.status == RecipeStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          if (state.status == RecipeStatus.error) {
            return Center(
              child: Text("Something went wrong", style: textTheme.bodyMedium),
            );
          }

          final favorites = state.allRecipes
              .where((r) => state.favoriteIds.contains(r.id))
              .toList();

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    child: Container(
                      color: AppColors.background, 
                      child: Lottie.asset(
                        "assets/images/no_favorites.json",
                        width: MediaQuery.of(context).size.width * .8,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        renderCache: RenderCache.raster,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No favorites yet",
                    style: AppTextStyles.w600.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Start adding recipes you love ❤️",
                    style: AppTextStyles.w400.copyWith(fontSize: 15),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: GridView.builder(
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final recipe = favorites[index];
                return RecipeCard(recipe: recipe);
              },
            ),
          );
        },
      ),
    );
  }
}
