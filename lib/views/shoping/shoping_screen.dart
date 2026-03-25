// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app/core/theme/app_image_provider.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/data/models/shoping_list_model.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping.bloc.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping_state.bloc.dart';
import 'package:recipe_app/views/recipe_detail/recipe_detail_screen.dart';
import 'package:recipe_app/widgets/my_buttom.dart';
import 'package:shimmer/shimmer.dart';

class ShopingScreen extends StatelessWidget {
  const ShopingScreen({super.key, required this.showAppBar});
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded),
              ),
              title: Text("Shopping List", style: AppTextStyles.h2),
              centerTitle: false,
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddListDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ShoppingBloc, ShoppingState>(
        builder: (context, state) {
          if (state.status == ShoppingStatus.loading && state.lists.isEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (state.lists.isEmpty) {
            return _empty();
          }

          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.lists.length,
                itemBuilder: (_, i) => _card(context, state.lists[i]),
              ),

              if (state.status == ShoppingStatus.loading)
                const Positioned(
                  top: 10,
                  right: 10,
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

Widget _empty() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(AppImageProvider.emptyCart),
        Text(
          "No shopping lists",
          style: AppTextStyles.w600.copyWith(fontSize: 18),
        ),
        Text(
          "Tap + to create one",
          style: AppTextStyles.w400.copyWith(fontSize: 15),
        ),
      ],
    ),
  );
}

Widget _card(BuildContext context, ShoppingListModel list) {
  final bloc = context.read<ShoppingBloc>();
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                list.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 140),
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) {
                if (value == "delete") {
                  bloc.add(DeleteShoppingList(list.id));
                } else if (value == "view") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RecipeDetailScreen(recipeId: list.recipeId!),
                    ),
                  );
                }
              },
              itemBuilder: (_) => [
                if (list.recipeId != null)
                  PopupMenuItem(
                    value: "view",
                    height: 36,
                    child: Row(
                      children: const [
                        Icon(Icons.visibility, size: 18),
                        SizedBox(width: 8),
                        Text("View Recipe"),
                      ],
                    ),
                  ),

                PopupMenuItem(
                  value: "delete",
                  height: 36,
                  child: Row(
                    children: const [
                      Icon(Icons.delete_outline, size: 18),
                      SizedBox(width: 8),
                      Text("Delete"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (list.items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "No items yet",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),

        ...list.items.map((item) {
          return InkWell(
            onTap: () async {
              if (!item.isDone) {
                bloc.add(ToggleItem(list.id, item.id));
              } else {
                final shouldUndo = await _showUndoDialog(context);

                if (shouldUndo == true) {
                  bloc.add(ToggleItem(list.id, item.id));
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isDone ? Colors.green : Colors.transparent,
                      border: Border.all(
                        color: item.isDone
                            ? Colors.green
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: item.isDone
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontFamily: appFontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        decoration: item.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: item.isDone ? Colors.grey : Colors.black,
                      ),
                      child: Text(item.name),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 10),

        TextButton.icon(
          onPressed: () => _showAddItemDialog(context, list.id),
          icon: const Icon(Icons.add),
          label: Text("Add Item", style: AppTextStyles.w500),
        ),
      ],
    ),
  );
}

void _showAddListDialog(BuildContext context) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      final colorScheme = Theme.of(context).colorScheme;

      return Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "New Shopping List",
                      style: AppTextStyles.w600.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              TextField(
                controller: controller,
                autofocus: true,
                cursorColor: colorScheme.primary,
                maxLength: 25,
                maxLines: 3,
                minLines: 2,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      required maxLength,
                    }) => null,
                decoration: InputDecoration(
                  hintText: "e.g. Weekly groceries",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  filled: true,
                  fillColor: colorScheme.primary.withOpacity(.09),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: MyCustomButton(
                      myText: 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      myColor: Colors.transparent,
                      mytextColor: colorScheme.primary,
                      myBorderColor: colorScheme.primary,
                      mybuttomradius: 14,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: MyCustomButton(
                      myText: 'Create',
                      onTap: () {
                        final text = controller.text.trim();

                        context.read<ShoppingBloc>().add(
                          AddShoppingList(
                            text.isEmpty ? "Personal Shopping List" : text,
                          ),
                        );

                        Navigator.pop(context);
                      },
                      myColor: colorScheme.primary,
                      mytextColor: Colors.white,
                      myBorderColor: colorScheme.primary,
                      mybuttomradius: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showAddItemDialog(BuildContext context, String listId) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      final colorScheme = Theme.of(context).colorScheme;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.add_shopping_cart, color: colorScheme.primary),
                  const SizedBox(width: 10),
                  Text("Add Item", style: AppTextStyles.w500),
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,
                autofocus: true,
                maxLength: 25,
                maxLines: 2,
                minLines: 1,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      required maxLength,
                    }) => null,
                decoration: InputDecoration(
                  hintText: "e.g. Milk, Tomato, Bread",
                  prefixIcon: const Icon(Icons.edit),
                  filled: true,
                  fillColor: colorScheme.primary.withOpacity(.09),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: MyCustomButton(
                      myText: 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                      },

                      myBorderColor: colorScheme.primary,
                      myColor: AppColors.white,
                      mytextColor: colorScheme.primary,
                      mybuttomradius: 14,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: MyCustomButton(
                      myText: 'Add',
                      onTap: () {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;

                        context.read<ShoppingBloc>().add(AddItem(listId, text));

                        Navigator.pop(context);
                      },
                      myColor: colorScheme.primary,
                      mytextColor: AppColors.white,
                      myBorderColor: colorScheme.primary,
                      mybuttomradius: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<bool?> _showUndoDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return showDialog<bool>(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.undo_rounded, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Mark as not purchased?",
                      style: AppTextStyles.w600.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                "This item will be moved back to your shopping list.",
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: MyCustomButton(
                      myText: 'Cancel',
                      onTap: () => Navigator.pop(context, false),
                      myColor: Colors.transparent,
                      mytextColor: colorScheme.primary,
                      myBorderColor: colorScheme.primary,
                      mybuttomradius: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyCustomButton(
                      myText: 'Undo',
                      onTap: () => Navigator.pop(context, true),
                      myColor: colorScheme.primary,
                      mytextColor: Colors.white,
                      myBorderColor: colorScheme.primary,
                      mybuttomradius: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
