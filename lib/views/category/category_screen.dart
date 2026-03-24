// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_state.bloc.dart';
import 'package:recipe_app/widgets/my_recipe_card_widget.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RecipeBloc>();
    final categories = bloc.categories;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: categories.entries.map((entry) {
          final title = entry.key;
          final items = entry.value;

          if (items.isEmpty) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 28,
                      width: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      context.read<RecipeBloc>().add(
                        FilterByCategory(title, item),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryRecipesScreen(title: item),
                        ),
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),

                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.12),
                            colorScheme.primary.withOpacity(0.04),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),

                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.08),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.restaurant_menu,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                item,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class CategoryRecipesScreen extends StatelessWidget {
  final String title;

  const CategoryRecipesScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,style: AppTextStyles.h2),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
       
        surfaceTintColor: Colors.transparent,
      
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          final recipes = state.filteredRecipes;

          if (recipes.isEmpty) {
            return const Center(child: Text("No recipes found"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (_, i) {
              return RecipeCard(recipe: recipes[i], width: double.infinity);
            },
          );
        },
      ),
    );
  }
}
