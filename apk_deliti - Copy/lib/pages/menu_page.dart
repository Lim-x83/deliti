import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../themes/app_theme.dart';
import 'food_detail_page.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';

class MenuPage extends StatefulWidget {
  final CartService cartService;

  const MenuPage({super.key, required this.cartService});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<dynamic> _menuItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    try {
      final items = await ApiService.getMenuItems();
      setState(() {
        _menuItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load menu: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    if (_menuItems.isEmpty) {
      return _buildEmptyState();
    }

    return _buildMenuContent();
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Menu'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading delicious menu...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Menu'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to Load Menu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadMenuItems,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Menu'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Menu Items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for our delicious offerings!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuContent() {
    // Group items by category
    final vegetarianItems = _menuItems.where((item) => item['category'] == 'vegetarian').toList();
    final healthyItems = _menuItems.where((item) => item['category'] == 'healthy').toList();
    final beastItems = _menuItems.where((item) => item['category'] == 'beast').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Menu'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          if (vegetarianItems.isNotEmpty)
            _buildCategory('Vegetarian', vegetarianItems),
          if (healthyItems.isNotEmpty)
            _buildCategory('Healthy Meal', healthyItems),
          if (beastItems.isNotEmpty)
            _buildCategory('Beast Meal', beastItems),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(context, item)).toList(),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, dynamic menuItem) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildMenuItemImage(menuItem['image_path']), // ← FIXED
        title: Text(
          menuItem['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rp ${double.parse(menuItem['price']).toStringAsFixed(0)}'),
            if (menuItem['description'] != null)
              Text(
                menuItem['description'].toString().length > 50
                    ? '${menuItem['description'].toString().substring(0, 50)}...'
                    : menuItem['description'].toString(),
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          color: AppTheme.primaryColor,
          onPressed: () {
            final newItem = CartItem(
              id: menuItem['id'].toString(),
              name: menuItem['name'],
              imagePath: menuItem['image_path'],
              price: double.parse(menuItem['price']),
              menuItemId: menuItem['id'],
            );
            
            widget.cartService.addToCart(newItem);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${menuItem['name']} added to cart!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailPage(
                menuItem: MenuItemModel.fromJson(menuItem), // ← USE MenuItemModel
                cartService: widget.cartService,
              ),
            ),
          );
        },        
      ),
    );
  }


  Widget _buildMenuItemImage(String imagePath) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.fastfood,
                color: Colors.grey,
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }

}