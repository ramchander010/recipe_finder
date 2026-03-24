// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/theme/app_image_provider.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:recipe_app/data/models/shoping_list_model.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_state.bloc.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping.bloc.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping_event.bloc.dart';
import 'package:recipe_app/views/shoping/shoping_screen.dart';
import 'package:shimmer/shimmer.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(LoadRecipeById(widget.recipeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          final recipe = state.selectedRecipe;

          if (recipe == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final isFavorite = state.favoriteIds.contains(recipe.id);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.textMain,
                elevation: 0,

                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                actions: [
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          context.read<RecipeBloc>().add(
                            ToggleFavorite(recipe.id),
                          );
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? AppColors.primary
                              : AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],

                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,

                  titlePadding: const EdgeInsets.only(
                    left: 58,
                    bottom: 14,
                    right: 16,
                  ),

                  title: Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h2.copyWith(color: AppColors.white),
                  ),

                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      recipeImage(recipe.imageUrl),
                      Container(color: AppColors.black.withOpacity(0.2)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0, -20, 0),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ⭐ META (clean row)
                      Row(
                        children: [
                          Text(
                            '⭐ ${recipe.rating}',
                            style: AppTextStyles.bodyMedium,
                          ),

                          const SizedBox(width: 16),

                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.durationMinutes} min',
                            style: AppTextStyles.bodyMedium,
                          ),

                          const Spacer(),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              color: _getDifficultyColor(
                                recipe.difficulty,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),

                              border: Border.all(
                                color: _getDifficultyColor(
                                  recipe.difficulty,
                                ).withOpacity(0.5),
                                width: 1,
                              ),
                            ),

                            child: Text(
                              recipe.difficulty.name.toUpperCase(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _getDifficultyColor(
                                  recipe.difficulty,
                                ).withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 👥 SERVINGS
                      Text(
                        '${recipe.servings} servings',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🏷 TAGS (minimal chips)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (recipe.isVeg) _minimalTag("Veg"),
                          if (recipe.isVegan) _minimalTag("Vegan"),
                          if (recipe.isGlutenFree) _minimalTag("Gluten Free"),
                          ...recipe.tags.map((e) => _minimalTag(e)),
                        ],
                      ),

                      const SizedBox(height: 28),

                      /// 🍽 NUTRITION
                      _sectionTitle("🍽 Nutrition"),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _nutri("Calories", recipe.calories),
                          _nutri("Protein", recipe.protein),
                          _nutri("Carbs", recipe.carbs),
                          _nutri("Fats", recipe.fats),
                        ],
                      ),

                      const SizedBox(height: 28),

                      /// 🧂 INGREDIENTS
                      _sectionTitle("🧂 Ingredients"),
                      const SizedBox(height: 12),

                      // ...recipe.ingredients.map(
                      //   (ing) => Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 6),
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           height: 6,
                      //           width: 6,
                      //           decoration: const BoxDecoration(
                      //             color: Colors.grey,
                      //             shape: BoxShape.circle,
                      //           ),
                      //         ),
                      //         const SizedBox(width: 10),
                      //         Expanded(
                      //           child: Text(
                      //             ing.name,
                      //             style: AppTextStyles.bodyMedium,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      ...recipe.ingredients.map((ing) {
                        final isAdded = _isIngredientAdded(
                          context,
                          recipe.id,
                          ing.name,
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                height: 6,
                                width: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),

                              /// Ingredient name
                              Expanded(
                                child: Text(
                                  ing.name,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),

                              /// ➕ / ✅ Button
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  context.read<ShoppingBloc>().add(
                                    AddItemSmart(
                                      name: ing.name,
                                      recipeId: recipe.id,
                                      title: recipe.title,
                                    ),
                                  );

                                  _showSnack(
                                    context,
                                    "${ing.name} added to ${recipe.title}",
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isAdded
                                        ? Colors.green.withOpacity(0.15)
                                        : Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    isAdded ? Icons.check : Icons.add,
                                    size: 18,
                                    color: isAdded ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 28),

                      /// 👨‍🍳 STEPS
                      _sectionTitle("👨‍🍳 Steps"),
                      const SizedBox(height: 12),

                      ...recipe.steps.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                alignment: Alignment.center,

                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),

                                child: Text(
                                  '${e.key + 1}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _minimalTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget recipeImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,

      placeholder: (context, _) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(color: AppColors.white),
      ),

      errorWidget: (context, _, _) =>
          Image.asset(AppImageProvider.appLogo, fit: BoxFit.cover),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(color: AppColors.black),
    );
  }

  Widget _nutri(String label, int value) {
    return Container(
      width: 70, // keeps all boxes aligned
      padding: const EdgeInsets.symmetric(vertical: 12),

      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.primary, width: 1.2),
      ),

      child: Column(
        children: [
          Text(
            '$value',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  DateTime? _lastSnackTime;

  Future<void> _showSnack(BuildContext context, String message) async {
    final now = DateTime.now();

    // ✅ debounce
    if (_lastSnackTime != null &&
        now.difference(_lastSnackTime!) < const Duration(milliseconds: 500)) {
      return;
    }

    _lastSnackTime = now;

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    await Future.delayed(const Duration(milliseconds: 50));

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,

        content: Row(
          children: [
            /// Message
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),

            /// ✅ YOUR BUTTON (replaces SnackBarAction)
            GestureDetector(
              onTap: () {
                messenger.hideCurrentSnackBar();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ShopingScreen(showAppBar: true),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "VIEW",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isIngredientAdded(
    BuildContext context,
    String recipeId,
    String ingredientName,
  ) {
    final lists = context.watch<ShoppingBloc>().state.lists;

    final list = lists.firstWhere(
      (l) => l.recipeId == recipeId,
      orElse: () =>
          ShoppingListModel(id: '', title: '', recipeId: '', items: []),
    );

    if (list.id.isEmpty) return false;

    return list.items.any(
      (i) => i.name.toLowerCase() == ingredientName.toLowerCase(),
    );
  }
}
