import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/storage/app_keys.dart';
import 'package:recipe_app/core/storage/app_prefs.dart';
import 'package:recipe_app/data/models/shoping_list_model.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping_state.bloc.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  ShoppingBloc() : super(const ShoppingState()) {
    on<LoadShoppingLists>(_onLoadLists);
    on<AddShoppingList>(_onAddList);
    on<DeleteShoppingList>(_onDeleteList);
    on<AddItem>(_onAddItem);
    on<ToggleItem>(_onToggleItem);
    on<DeleteItem>(_onDeleteItem);
on<AddItemSmart>(_onAddItemSmart);
    /// 🔥 Load data on start
    add(LoadShoppingLists());
  }

  /// =========================
  /// 🔹 LOAD FROM LOCAL
  /// =========================
  Future<void> _onLoadLists(
    LoadShoppingLists event,
    Emitter<ShoppingState> emit,
  ) async {
    /// 🔥 DO NOT clear existing data
    emit(state.copyWith(status: ShoppingStatus.loading));

    final data = await AppPrefs.getStringList(AppKeys.shoppingLists);

    if (data == null) {
      emit(state.copyWith(status: ShoppingStatus.success));
      return;
    }

    final lists = data
        .map((e) => ShoppingListModel.fromJson(jsonDecode(e)))
        .toList();

    emit(state.copyWith(lists: lists, status: ShoppingStatus.success));
  }

  /// =========================
  /// 🔹 SAVE TO LOCAL
  /// =========================
  Future<void> _saveLists(List<ShoppingListModel> lists) async {
    final data = lists.map((e) => jsonEncode(e.toJson())).toList();
    await AppPrefs.setStringList(AppKeys.shoppingLists, data);
  }

  /// =========================
  /// ➕ ADD LIST
  /// =========================
  Future<void> _onAddList(
    AddShoppingList event,
    Emitter<ShoppingState> emit,
  ) async {
    final newList = ShoppingListModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.title,
      recipeId: event.recipeId,
      items: [],
    );

    final updated = [...state.lists, newList];

    emit(state.copyWith(lists: updated));

    await _saveLists(updated);
  }

  /// =========================
  /// 🗑 DELETE LIST
  /// =========================
  Future<void> _onDeleteList(
    DeleteShoppingList event,
    Emitter<ShoppingState> emit,
  ) async {
    final updated = state.lists.where((e) => e.id != event.listId).toList();

    emit(state.copyWith(lists: updated));

    await _saveLists(updated);
  }

  /// =========================
  /// ➕ ADD ITEM
  /// =========================
  Future<void> _onAddItem(AddItem event, Emitter<ShoppingState> emit) async {
    final updated = state.lists.map((list) {
      if (list.id == event.listId) {
        return ShoppingListModel(
          id: list.id,
          title: list.title,
          recipeId: list.recipeId,
          items: [
            ...list.items,
            ShoppingItem(id: DateTime.now().toString(), name: event.name),
          ],
        );
      }
      return list;
    }).toList();

    emit(state.copyWith(lists: updated));

    await _saveLists(updated);
  }

  /// =========================
  /// ✔ TOGGLE ITEM
  /// =========================
  Future<void> _onToggleItem(
    ToggleItem event,
    Emitter<ShoppingState> emit,
  ) async {
    final updated = state.lists.map((list) {
      if (list.id == event.listId) {
        return ShoppingListModel(
          id: list.id,
          title: list.title,
          recipeId: list.recipeId,
          items: list.items.map((item) {
            if (item.id == event.itemId) {
              return item.copyWith(isDone: !item.isDone);
            }
            return item;
          }).toList(),
        );
      }
      return list;
    }).toList();

    emit(state.copyWith(lists: updated));

    await _saveLists(updated);
  }

  /// =========================
  /// ❌ DELETE ITEM
  /// =========================
  Future<void> _onDeleteItem(
    DeleteItem event,
    Emitter<ShoppingState> emit,
  ) async {
    final updated = state.lists.map((list) {
      if (list.id == event.listId) {
        return ShoppingListModel(
          id: list.id,
          title: list.title,
          recipeId: list.recipeId,
          items: list.items.where((i) => i.id != event.itemId).toList(),
        );
      }
      return list;
    }).toList();

    emit(state.copyWith(lists: updated));

    await _saveLists(updated);
  }
  Future<void> _onAddItemSmart(
  AddItemSmart event,
  Emitter<ShoppingState> emit,
) async {
  final lists = List<ShoppingListModel>.from(state.lists);

  ShoppingListModel? targetList;

  /// =========================
  /// 🔍 CASE 1: Recipe list
  /// =========================
  if (event.recipeId != null) {
    final index = lists.indexWhere(
      (l) => l.recipeId == event.recipeId,
    );

    if (index != -1) {
      targetList = lists[index];
    } else {
      targetList = ShoppingListModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title ?? "Recipe List",
        recipeId: event.recipeId,
        items: [],
      );
      lists.add(targetList);
    }
  }

  /// =========================
  /// 🔍 CASE 2: Personal list
  /// =========================
  else {
    final index = lists.indexWhere((l) => l.recipeId == null);

    if (index != -1) {
      targetList = lists[index];
    } else {
      targetList = ShoppingListModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "My List",
        recipeId: null,
        items: [],
      );
      lists.add(targetList);
    }
  }

  /// =========================
  /// 🚫 Prevent duplicates
  /// =========================
  final alreadyExists = targetList.items.any(
    (i) => i.name.toLowerCase() == event.name.toLowerCase(),
  );

  if (alreadyExists) {
    return; // optionally emit same state
  }

  /// =========================
  /// ➕ Add item
  /// =========================
  final updatedLists = lists.map((list) {
    if (list.id == targetList!.id) {
      return ShoppingListModel(
        id: list.id,
        title: list.title,
        recipeId: list.recipeId,
        items: [
          ...list.items,
          ShoppingItem(
            id: DateTime.now().toString(),
            name: event.name,
          ),
        ],
      );
    }
    return list;
  }).toList();

  emit(state.copyWith(lists: updatedLists));

  await _saveLists(updatedLists);
}
}
