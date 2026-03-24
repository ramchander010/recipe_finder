
abstract class ShoppingEvent {}

class LoadShoppingLists extends ShoppingEvent {}

class AddShoppingList extends ShoppingEvent {
  final String title;
  final String? recipeId;

  AddShoppingList(this.title, {this.recipeId});
}

class DeleteShoppingList extends ShoppingEvent {
  final String listId;

  DeleteShoppingList(this.listId);
}

class AddItem extends ShoppingEvent {
  final String listId;
  final String name;

  AddItem(this.listId, this.name);
}

class ToggleItem extends ShoppingEvent {
  final String listId;
  final String itemId;

  ToggleItem(this.listId, this.itemId);
}

class DeleteItem extends ShoppingEvent {
  final String listId;
  final String itemId;

  DeleteItem(this.listId, this.itemId);
}
class AddItemSmart extends ShoppingEvent {
  final String name;
  final String? recipeId;
  final String? title;

    AddItemSmart({
    required this.name,
    this.recipeId,
    this.title,
  });
}