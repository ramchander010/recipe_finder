import 'package:recipe_app/data/models/shoping_list_model.dart';

enum ShoppingStatus { initial, loading, success }

class ShoppingState {
  final List<ShoppingListModel> lists;
  final ShoppingStatus status;

  const ShoppingState({
    this.lists = const [],
    this.status = ShoppingStatus.initial,
  });

  ShoppingState copyWith({
    List<ShoppingListModel>? lists,
    ShoppingStatus? status,
  }) {
    return ShoppingState(
      lists: lists ?? this.lists,
      status: status ?? this.status,
    );
  }
}
