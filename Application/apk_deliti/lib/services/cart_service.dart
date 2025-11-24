import '../models/cart_item.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class CartService {
  List<CartItem> _items = [];
  User? _currentUser;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> setUser(User user) async {
    _currentUser = user;
    await loadCart();
  }

  void clearUser() {
    _currentUser = null;
    _items.clear();
  }

  Future<void> addToCart(CartItem item) async {
    if (_currentUser == null) return;
    
    // Add to database
    await ApiService.addToCart(_currentUser!.id, item.menuItemId);
    
    // Reload cart from database
    await loadCart();
  }

  Future<void> updateQuantity(String id, int newQuantity) async {
    if (_currentUser == null) return;
    
    // Find the item to get cart_item_id
    final item = _items.firstWhere((item) => item.id == id);
    if (item.cartItemId != null) {
      // Update in database
      await ApiService.updateCartItem(item.cartItemId!, newQuantity);
      
      // Reload cart from database
      await loadCart();
    }
  }

  Future<void> removeFromCart(String id) async {
    print('🛒 CartService.removeFromCart called for: $id');
    
    if (_currentUser == null) {
      print('❌ No user logged in');
      return;
    }
    
    // Find the item to get cart_item_id
    final item = _items.firstWhere((item) => item.id == id);
    print('🔍 Found item to remove: ${item.name}, cartItemId: ${item.cartItemId}');
    
    if (item.cartItemId != null) {
      print('📞 Calling ApiService.updateCartItem with quantity 0...');
      // Set quantity to 0 to remove from cart
      await ApiService.updateCartItem(item.cartItemId!, 0);
      
      print('🔄 Reloading cart after removal...');
      // Reload cart from database
      await loadCart();
      print('✅ Cart reloaded after removal');
    } else {
      print('❌ No cartItemId found for item $id');
    }
  }

  Future<void> clearCart() async {
    if (_currentUser == null) return;
    
    // Clear in database
    await ApiService.clearCart(_currentUser!.id);
    
    // Reload cart from database
    await loadCart();
  }

  Future<void> loadCart() async {
    if (_currentUser == null) return;
    
    final result = await ApiService.getCart(_currentUser!.id);
    
    if (result['success'] == true) {
      _items = (result['items'] as List).map((item) {
        return CartItem(
          id: item['menu_item_id'].toString(),
          name: item['name'],
          imagePath: item['image_path'],
          price: double.parse(item['price'].toString()),
          quantity: item['quantity'],
          menuItemId: item['menu_item_id'],
          cartItemId: item['id'],
        );
      }).toList();
    } else {
      _items = [];
    }

  }

  bool isInCart(String id) => _items.any((item) => item.id == id);
  int getQuantity(String id) {
    final item = _items.firstWhere((item) => item.id == id, orElse: () => CartItem(id: '', name: '', imagePath: '', price: 0, menuItemId: 0));
    return item.quantity;
  }
}