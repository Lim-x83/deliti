import 'package:apk_deliti/pages/report_page.dart';
import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../themes/app_theme.dart';
import '../models/user_model.dart';
import 'login_page.dart';
import 'menu_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import 'orders_page.dart'; // ← ADD THIS IMPORT

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final CartService cartService = CartService();
  User? _currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Deliti',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        actions: [
          // REPLACED: Always show 3-dot menu
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMainMenu,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartService.itemCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() async {
    final user = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    if (user != null) {
      setState(() => _currentUser = user);
      await cartService.setUser(user);
      setState(() {});
    }
  }

  void _logout() {
    setState(() {
      _currentUser = null;
      cartService.clearUser();
      cartService.clearCart();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showMainMenu() {
    final List<PopupMenuEntry<String>> menuItems = [];

    // Always available items
    menuItems.addAll([
      PopupMenuItem<String>(
        value: 'artikel',
        child: const Row(
          children: [
            Icon(Icons.article, size: 20),
            SizedBox(width: 8),
            Text('Artikel'),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'about',
        child: const Row(
          children: [
            Icon(Icons.info_outline, size: 20),
            SizedBox(width: 8),
            Text('About Deliti'),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'report',
        child: const Row(
          children: [
            Icon(Icons.report_problem, size: 20),
            SizedBox(width: 8),
            Text('Report'),
          ],
        ),
      ),
    ]);

    // User-specific items
    if (_currentUser != null) {
      // Add logged-in user items at the top
      menuItems.insertAll(0, [
        PopupMenuItem<String>(
          value: 'profile',
          child: const Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 8),
              Text('My Profile'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'orders',
          child: const Row(
            children: [
              Icon(Icons.receipt_long, size: 20),
              SizedBox(width: 8),
              Text('My Orders'),
            ],
          ),
        ),
        const PopupMenuDivider(), // Divider between user and general items
      ]);
    }

    // Login/Logout item (always at bottom)
    menuItems.add(
      PopupMenuItem<String>(
        value: _currentUser != null ? 'logout' : 'login',
        child: Row(
          children: [
            Icon(_currentUser != null ? Icons.logout : Icons.login, size: 20),
            const SizedBox(width: 8),
            Text(_currentUser != null ? 'Logout' : 'Login'),
          ],
        ),
      ),
    );

    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
      items: menuItems,
    ).then((value) {
      if (value != null) {
        _handleMenuSelection(value);
      }
    });
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'login':
        _navigateToLogin();
        break;
      case 'logout':
        _logout();
        break;
      case 'profile':
        if (_currentUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(currentUser: _currentUser!)),
          );
        }
        break;
          case 'orders':
            if (_currentUser != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersPage(currentUser: _currentUser!)), // ← FIXED
              );
            }
        break;
      case 'artikel':
        // Navigate to Artikel page
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ArtikelPage()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel page coming soon!')),
        );
        break;
      case 'about':
        // Navigate to About page
        // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('About Deliti page coming soon!')),
        );
        break;
      case 'report':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportPage()),
        );
        break;
    }
  }

  Widget _buildBody() {
    if (_currentIndex == 1) {
      return MenuPage(cartService: cartService);
    }
    if (_currentIndex == 2) {
      return CartPage(
        cartService: cartService,
        currentUser: _currentUser,
      );
    }
    
    // Original home content for index 0
    return SingleChildScrollView(
      child: Column(
        children: [
          // ... your existing home content
          
          // Show user info if logged in
          if (_currentUser != null) ...[
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        _currentUser!.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${_currentUser!.name}!',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Ready to order some delicious food?',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}