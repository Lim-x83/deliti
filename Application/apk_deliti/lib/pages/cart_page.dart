import 'dart:async';
import 'package:apk_deliti/services/api_service.dart';
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../models/cart_item.dart';
import '../models/user_model.dart';
import '../services/cart_service.dart';

class CartPage extends StatefulWidget {
  final CartService cartService;
  final User? currentUser;

  const CartPage({super.key, required this.cartService, this.currentUser});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  Timer? _debounceTimer;
  final Map<String, int> _pendingUpdates = {}; // Track pending quantity changes

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cartService.items;
    final totalPrice = widget.cartService.totalPrice;
    final itemCount = widget.cartService.itemCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.black,
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showClearCartDialog,
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      body: _buildBody(items, totalPrice),
      bottomNavigationBar: items.isEmpty ? null : _buildCheckoutBar(totalPrice),
    );
  }

  Widget _buildBody(List<CartItem> items, double totalPrice) {
    // Show login prompt if no user BUT still show cart items
    if (widget.currentUser == null) {
      return Column(
        children: [
          // Login banner - WITHOUT BUTTON
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.orange[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login to save your cart',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                      Text(
                        'Please login from the profile menu to save your cart',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Cart items (empty or with items)
          Expanded(
            child: items.isEmpty
                ? _buildEmptyCart()
                : _buildCartList(items, totalPrice),
          ),
        ],
      );
    }

    // User is logged in
    return items.isEmpty
        ? _buildEmptyCart()
        : _buildCartList(items, totalPrice);
  }

  Widget _buildCartList(List<CartItem> items, double totalPrice) {
    return Column(
      children: [
        // User welcome banner if logged in
        if (widget.currentUser != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.green[50],
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 16),
                const SizedBox(width: 8),
                Text(
                  'Logged in as ${widget.currentUser!.email}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildCartItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Food Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(item.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Food Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${item.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      _buildQuantityButton(
                        Icons.remove,
                        () => _updateQuantity(item, item.quantity - 1),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildQuantityButton(
                        Icons.add,
                        () => _updateQuantity(item, item.quantity + 1),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: Colors.red,
                        onPressed: () => _removeItem(item.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Total Price
            Text(
              'Rp ${item.totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCheckoutBar(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Rp ${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  '${widget.cartService.itemCount} items',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.currentUser == null) {
                _showLoginRequiredMessage();
              } else {
                _showCheckoutDialog(totalPrice);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(CartItem item, int newQuantity) async {
    // Prevent negative quantities
    if (newQuantity < 0) return;
    
    print('➕➖ CART PAGE: Button clicked: ${item.name} from ${item.quantity} to $newQuantity');
    print('➕➖ CART PAGE: Item details - id: ${item.id}, cartItemId: ${item.cartItemId}');
    
    // Store the pending update
    _pendingUpdates[item.id] = newQuantity;
    
    print('📝 CART PAGE: Pending updates stored: $_pendingUpdates');
    
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Start new timer (1 second - shorter for better UX)
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      print('⏰ CART PAGE: Timer finished, processing updates...');
      _processPendingUpdates();
    });
    
    print('⏱️ CART PAGE: New timer started (1 second)');
  }

  void _processPendingUpdates() async {
    if (_pendingUpdates.isEmpty) {
      print('❌ No pending updates to process');
      return;
    }
    
    print('🔄 Processing ${_pendingUpdates.length} pending updates');
    print('📦 Pending updates: $_pendingUpdates');
    
    try {
      // Process all pending updates
      for (final entry in _pendingUpdates.entries) {
        final itemId = entry.key;
        final newQuantity = entry.value;
        
        print('📦 Updating item $itemId to quantity $newQuantity');
        
        // Find the item to get cartItemId
        final item = widget.cartService.items.firstWhere(
          (item) => item.id == itemId,
          orElse: () => CartItem(id: '', name: '', imagePath: '', price: 0, menuItemId: 0),
        );
        
        if (item.cartItemId != null) {
          print('🛒 Updating in database with cartItemId: ${item.cartItemId}');
          // Update in database
          await widget.cartService.updateQuantity(item.id, newQuantity);
        } else {
          print('❌ No cartItemId found for item $itemId');
        }
      }
      
      // Clear pending updates after successful processing
      _pendingUpdates.clear();
      
      print('🔄 Reloading cart from database...');
      
      // Reload cart from database to ensure sync
      await widget.cartService.loadCart();
      
      print('✅ Cart reloaded successfully');
      
      setState(() {
        print('🔄 UI updated with new cart data');
      });
      
    } catch (e) {
      print('❌ Error processing quantity updates: $e');
    }
  }

  void _removeItem(String id) async {
    print('🗑️ Delete button clicked for item: $id');
    
    // Cancel any pending updates for this item
    _pendingUpdates.remove(id);
    _debounceTimer?.cancel();
    
    // Find the item to get cartItemId
    final item = widget.cartService.items.firstWhere(
      (item) => item.id == id,
      orElse: () => CartItem(id: '', name: '', imagePath: '', price: 0, menuItemId: 0),
    );
    
    print('🔍 Item to delete: ${item.name}, cartItemId: ${item.cartItemId}');
    
    if (item.cartItemId != null && item.cartItemId! > 0) {
      print('🗑️ Calling removeFromCart in CartService...');
      // Remove immediately (no debounce for delete)
      await widget.cartService.removeFromCart(id);
      print('✅ removeFromCart completed');
      
      setState(() {
        print('🔄 UI updated after delete');
      });
    } else {
      print('❌ Cannot delete - invalid cartItemId: ${item.cartItemId}');
    }
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await widget.cartService.clearCart();
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginRequiredMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login from the profile menu to checkout'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showCheckoutDialog(double totalPrice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thank you for your order! 🎉'),
            const SizedBox(height: 16),
            Text(
              'Total: Rp ${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Your delicious food will be ready in 20-30 minutes!'),
            const SizedBox(height: 8),
            Text(
              'Order for: ${widget.currentUser!.name}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('🛒 CHECKOUT: Confirm order button clicked');
              print('🛒 CHECKOUT: User ID: ${widget.currentUser!.id}');
              print('🛒 CHECKOUT: Total Price: $totalPrice');
              print('🛒 CHECKOUT: Items count: ${widget.cartService.items.length}');
              
              // NEW: Create order in database
              final orderResult = await ApiService.createOrder(
                widget.currentUser!.id,
                totalPrice,
                widget.cartService.items,
              );
              
              print('🛒 CHECKOUT: Order API Response: $orderResult');
              
              if (orderResult['success'] == true) {
                print('✅ CHECKOUT: Order created successfully, clearing cart...');
                // Clear cart only after successful order creation
                await widget.cartService.clearCart();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed successfully! 🎉'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              } else {
                print('❌ CHECKOUT: Order failed: ${orderResult['message']}');
                // Show error if order creation fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order failed: ${orderResult['message']}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some delicious food from our menu!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}