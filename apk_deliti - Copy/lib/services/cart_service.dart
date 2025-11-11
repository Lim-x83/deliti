import '../models/cart_item.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class CartService {
  List<CartItem> _items = [];
  User? _currentUser;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  // Set current user and load their cart
  void setUser(User user) {
    _currentUser = user;
    _loadUserCart();
  }

  // Clear user and cart
  void clearUser() {
    _currentUser = null;
    _items.clear();
  }

  // Load user's cart from database
  Future<void> _loadUserCart() async {
    if (_currentUser == null) return;

    final result = await ApiService.getCart(_currentUser!.id);
    if (result['success'] == true) {
      _items = (result['items'] as List).map((item) {
        return CartItem(
          id: item['id'].toString(),
          name: item['name'],
          imagePath: item['image_path'],
          price: double.parse(item['price']),
          quantity: item['quantity'],
          menuItemId: item['menu_item_id'],
          cartItemId: item['id'],
        );
      }).toList();
    }
  }

  // Add to cart - save to database
  Future<void> addToCart(CartItem newItem) async {
    if (_currentUser == null) {
      // Fallback to local cart if not logged in
      _addToLocalCart(newItem);
      return;
    }

    // Save to database
    final result = await ApiService.addToCart(_currentUser!.id, newItem.menuItemId);
    if (result['success'] == true) {
      await _loadUserCart(); // Reload from database
    }
  }

  // Local cart fallback (when not logged in)
  void _addToLocalCart(CartItem newItem) {
    final existingIndex = _items.indexWhere((item) => item.id == newItem.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(newItem);
    }
  }

  // Update quantity - save to database
  Future<void> updateQuantity(String id, int newQuantity) async {
    if (_currentUser == null) {
      _updateLocalQuantity(id, newQuantity);
      return;
    }

    // Find the cart item ID for database update
    final item = _items.firstWhere((item) => item.id == id);
    if (item.cartItemId != null) {
      final result = await ApiService.updateCartItem(item.cartItemId!, newQuantity);
      if (result['success'] == true) {
        await _loadUserCart(); // Reload from database
      }
    }
  }

  // Local quantity update fallback
  void _updateLocalQuantity(String id, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(id);
      return;
    }
    
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
    }
  }

  void removeFromCart(String id) {
    if (_currentUser == null) {
      _items.removeWhere((item) => item.id == id);
      return;
    }
    
    // For logged-in users, set quantity to 0 to remove from database
    final item = _items.firstWhere((item) => item.id == id);
    if (item.cartItemId != null) {
      updateQuantity(id, 0);
    }
  }

  void clearCart() {
    if (_currentUser == null) {
      _items.clear();
      return;
    }
    
    // For logged-in users, remove all items via API
    for (final item in _items) {
      if (item.cartItemId != null) {
        updateQuantity(item.id, 0);
      }
    }
  }

  bool isInCart(String id) {
    return _items.any((item) => item.id == id);
  }

  int getQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    return index >= 0 ? _items[index].quantity : 0;
  }
}