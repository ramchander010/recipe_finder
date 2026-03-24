import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_state.bloc.dart';
import 'package:recipe_app/views/home/widgets/shrimmer.dart';
import 'package:recipe_app/widgets/my_buttom.dart';
import 'package:recipe_app/widgets/my_recipe_card_widget.dart';

Widget homeRecipeListingView() {
  return BlocBuilder<RecipeBloc, RecipeState>(
    builder: (context, state) {
      final textTheme = Theme.of(context).textTheme;
      final bloc = context.read<RecipeBloc>();

      if (state.status == RecipeStatus.loading) {
        return buildShimmerLists();
      }

      final lists = bloc.allLists;

      if (lists.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              const Icon(Icons.fastfood_outlined, size: 60),
              const SizedBox(height: 12),
              Text(
                "No recipes found",
                style: AppTextStyles.w600.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              MyCustomButton(
                myText: 'Reload',
                mybuttomHorizontalPadding: 80,
                isLoading: state.status == RecipeStatus.loading,
                onTap: () {
                  bloc.add(LoadRecipes());
                },
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lists.entries.map((entry) {
          final title = entry.key;
          final recipes = entry.value;

          if (recipes.isEmpty) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
                child: Text(
                  bloc.formatTitle(title),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: RecipeCard(recipe: recipes[index]),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      );
    },
  );
}
