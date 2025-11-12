import '../models/cart_item.dart';

class SimpleCartService {
  List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(CartItem newItem) {
    final existingIndex = _items.indexWhere((item) => item.id == newItem.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(newItem);
    }
  }

  void updateQuantity(String id, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(id);
      return;
    }
    
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
    }
  }

  void removeFromCart(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void clearCart() {
    _items.clear();
  }

  bool isInCart(String id) {
    return _items.any((item) => item.id == id);
  }

  int getQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    return index >= 0 ? _items[index].quantity : 0;
  }
}