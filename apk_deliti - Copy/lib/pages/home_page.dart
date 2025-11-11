import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../themes/app_theme.dart';
import '../models/user_model.dart'; // ← ADD THIS
import 'login_page.dart';
import 'menu_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final CartService cartService = CartService();
  User? _currentUser; // ← ADD THIS to track logged in user

  // Update the AppBar to show user info when logged in
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
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              if (cartService.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartService.itemCount > 9 ? '9+' : cartService.itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // UPDATE THIS: Show user info or login button
          _currentUser != null 
              ? _buildUserProfile()
              : IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    _navigateToLogin();
                  },
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

  // ADD THIS: Build user profile widget
  Widget _buildUserProfile() {
    return GestureDetector(
      onTap: _showUserMenu,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Text(
                _currentUser!.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _currentUser!.name.split(' ')[0], // Show first name only
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

// In your _HomePageState class, update the _navigateToLogin method:
void _navigateToLogin() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
  
  // If login was successful, update the user state AND connect to cart
  if (result != null && result is User) {
    setState(() {
      _currentUser = result;
      cartService.setUser(result); // ← ADD THIS LINE - Connect user to cart!
    });
    
    // Show welcome message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome back, ${result.name}! 🎉'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

  // Also update the logout method:
  void _logout() {
    setState(() {
      _currentUser = null;
      cartService.clearUser(); // ← ADD THIS - Clear user from cart!
      cartService.clearCart(); // ← Clear the cart data
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ADD THIS: Show user menu (logout, profile, etc.)
  void _showUserMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          child: const Text('My Profile'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage())
            );
          },
        ),
        PopupMenuItem(
          child: const Text('Logout'),
          onTap: _logout,
        ),
      ],
    );
  }


  Widget _buildBody() {
    if (_currentIndex == 1) {
      return MenuPage(cartService: cartService);
    }
    if (_currentIndex == 2) {
      return CartPage(
        cartService: cartService,
        currentUser: _currentUser, // ← ADD THIS - Pass user to cart page!
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

  // ... your existing test methods
}