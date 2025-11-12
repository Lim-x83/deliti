// models/menu_item_model.dart
import 'cart_item.dart';

class MenuItemModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;
  final int calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final bool isAvailable;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    required this.isAvailable,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      imagePath: json['image_path'],
      category: json['category'],
      calories: json['calories'] ?? 0,
      protein: json['protein'] != null ? double.parse(json['protein'].toString()) : null,
      carbs: json['carbs'] != null ? double.parse(json['carbs'].toString()) : null,
      fat: json['fat'] != null ? double.parse(json['fat'].toString()) : null,
      isAvailable: json['is_available'] == 1,
    );
  }

  CartItem toCartItem() {
    return CartItem(
      id: id.toString(),
      name: name,
      imagePath: imagePath,
      price: price,
      menuItemId: id,
    );
  }
}