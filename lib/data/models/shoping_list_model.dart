class ShoppingItem {
  final String id;
  final String name;
  final bool isDone;

  ShoppingItem({
    required this.id,
    required this.name,
    this.isDone = false,
  });

  ShoppingItem copyWith({bool? isDone}) {
    return ShoppingItem(
      id: id,
      name: name,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isDone": isDone,
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json["id"],
      name: json["name"],
      isDone: json["isDone"] ?? false,
    );
  }
}

class ShoppingListModel {
  final String id;
  final String title;
  final String? recipeId;
  final List<ShoppingItem> items;

  ShoppingListModel({
    required this.id,
    required this.title,
    this.recipeId,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "recipeId": recipeId,
        "items": items.map((e) => e.toJson()).toList(),
      };

  factory ShoppingListModel.fromJson(Map<String, dynamic> json) {
    return ShoppingListModel(
      id: json["id"],
      title: json["title"],
      recipeId: json["recipeId"],
      items: (json["items"] as List)
          .map((e) => ShoppingItem.fromJson(e))
          .toList(),
    );
  }
}