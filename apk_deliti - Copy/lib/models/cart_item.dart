class CartItem {
  final String id; // menu item ID
  final String name;
  final String imagePath;
  final double price;
  int quantity;
  final int menuItemId; // database menu item ID
  final int? cartItemId; // database cart item ID (null if not saved yet)

  CartItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
    required this.menuItemId,
    this.cartItemId,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    int? quantity,
    int? cartItemId,
  }) {
    return CartItem(
      id: id,
      name: name,
      imagePath: imagePath,
      price: price,
      quantity: quantity ?? this.quantity,
      menuItemId: menuItemId,
      cartItemId: cartItemId ?? this.cartItemId,
    );
  }
}