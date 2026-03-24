// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/data/speech/bloc/speech.bloc.dart';
import 'package:recipe_app/data/speech/bloc/speech_event.bloc.dart';
import 'package:recipe_app/data/speech/bloc/speech_state.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_state.bloc.dart';
import 'package:recipe_app/widgets/my_recipe_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<RecipeBloc>().add(SearchRecipes(value));
    });
  }

  @override
  void initState() {
    super.initState();

    final speechBloc = context.read<SpeechBloc>();

    _speechSubscription = speechBloc.stream.listen((state) {
      if (!mounted) return;

      /// Live update (while speaking)
      if (state.isListening && state.text.isNotEmpty) {
        controller.text = state.text;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: state.text.length),
        );
      }

      /// ✅ Speech completed → trigger search
      if (!state.isListening && state.text.isNotEmpty) {
        final finalText = state.text;

        /// 🔥 trigger search FIRST
        _onSearchChanged(finalText);

        // /// 🔥 clear ONLY controller (not immediately wiping UX)
        // controller.clear();

        /// 🔥 clear bloc state (VERY IMPORTANT)
        context.read<SpeechBloc>().add(ClearSpeech());
      }

      /// Error
      if (state.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error!)));
      }
    });
  }

  StreamSubscription? _speechSubscription;
  @override
  void dispose() {
    _speechSubscription?.cancel(); // ✅ FIX CRASH
    controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RecipeBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Recipes", style: AppTextStyles.h2),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  ],
                ),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: TextField(
                  controller: controller,
                  onChanged: _onSearchChanged,
                  onSubmitted: (v) {
                    bloc.add(SearchRecipes(v));
                  },
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Clear button (existing)
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller,
                          builder: (context, value, _) {
                            if (value.text.isEmpty) return const SizedBox();

                            return IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {
                                controller.clear();
                                context.read<RecipeBloc>().add(
                                  SearchRecipes(''),
                                );
                              },
                            );
                          },
                        ),

                        /// 🎙️ Mic Button
                        BlocBuilder<SpeechBloc, SpeechState>(
                          builder: (context, speechState) {
                            return GestureDetector(
                              onTap: () {
                                if (speechState.isListening) {
                                  context.read<SpeechBloc>().add(
                                    StopListening(),
                                  );
                                } else {
                                  controller.clear();
                                  context.read<SpeechBloc>().add(
                                    StartListening(),
                                  );
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: speechState.isListening
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.15)
                                      : Colors.transparent,
                                ),
                                child: Icon(
                                  speechState.isListening
                                      ? Icons.mic_rounded
                                      : Icons.mic_none_rounded,
                                  size: 22,
                                  color: speechState.isListening
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.6),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 6),
                      ],
                    ),

                    hintText: "Search recipes, ingredients...",
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),

                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                final results = state.filteredRecipes;

                if (controller.text.isEmpty) {
                  return _buildInitialState(false);
                } else if (results.isEmpty) {
                  return _buildInitialState(true);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (_, i) {
                    final recipe = results[i];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: RecipeCard(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(bool dataNotFound) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/images/search_animation.json", height: 200),
          Text(
            dataNotFound ? "No recipes found" : "Search recipes or ingredients",
            style: AppTextStyles.w600.copyWith(fontSize: 18),
          ),
          if (dataNotFound)
            Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Try different keywords",
                style: AppTextStyles.w400.copyWith(fontSize: 15),
              ),
            ),
        ],
      ),
    );
  }
}
