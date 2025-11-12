import 'package:flutter/material.dart';
import 'feedback2.dart';

String logoDeliti = "assets/Deliti Png.png";
String version = "v1.1.3";

List<String> gambarMenuVege = [
  "assets/gambar/MENU-VEGE/dish1.jpeg",
  "assets/gambar/MENU-VEGE/dish2.jpeg",
  "assets/gambar/MENU-VEGE/dish3.jpeg",
];

List<String> gambarMenuHealthy = [
  "assets/gambar/MENU-HEALTHY/dish1.jpeg",
  "assets/gambar/MENU-HEALTHY/dish2.jpeg",
  "assets/gambar/MENU-HEALTHY/dish3.jpeg",
];

List<String> gambarMenuBeast = [
  "assets/gambar/MENU-BEAST/dish1.jpeg",
  "assets/gambar/MENU-BEAST/dish2.jpeg",
  "assets/gambar/MENU-BEAST/dish3.jpeg",
];

void main() {
  runApp(const DelitiApp());
}

class DelitiApp extends StatelessWidget {
  const DelitiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deliti - Healthy Delicious Food',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Arial',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int _selectedCategory = 0;
  final List<String> categories = ['All Dishes', 'Vegetarian', 'Healthy Meal', 'Beast Meal'];
  final Set<String> _hoveredItems = <String>{};

  User? _currentUser;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(_animationController);
    
    _animationController.forward();
  }

  void _logout() {
    setState(() {
      _currentUser = null;
    });
  }

  void _showProfileMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              _showProfileDialog();
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ),
      ],
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('My Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                backgroundImage: _currentUser?.profilePicture != null
                    ? AssetImage(_currentUser!.profilePicture!)
                    : null,
                child: _currentUser?.profilePicture == null
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                _currentUser?.name ?? 'No Name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _currentUser?.email ?? 'No Email',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _updateHoverState(String uniqueId, bool isHovered) {
    setState(() {
      if (isHovered) {
        _hoveredItems.add(uniqueId);
      } else {
        _hoveredItems.remove(uniqueId);
      }
    });
  }

  bool _isHovered(String uniqueId) {
    return _hoveredItems.contains(uniqueId);
  }

  void _navigateToFeedback() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedbackPage()),
    );
  }

  void _showLoginDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool showPassword = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Login to Deliti'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      hintText: 'you@gmail.com',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    if (!email.endsWith('@gmail.com')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Only Gmail accounts are allowed'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logging in...')),
                    );

                    Future.delayed(const Duration(milliseconds: 800), () {
                      final user = AuthService.login(email, password);
                      
                      if (user != null) {
                        Navigator.pop(context);
                        setState(() {
                          _currentUser = user;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Welcome back, ${user.name}!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid email or password'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    });
                  },
                  child: const Text('Login'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Filter dishes based on selected category
  List<Dish> getFilteredDishes() {
    switch (_selectedCategory) {
      case 0: // All Dishes
        return allDishes;
      case 1: // Vegetarian
        return allDishes.where((dish) => dish.category == 'vegetarian').toList();
      case 2: // Healthy Meal
        return allDishes.where((dish) => dish.category == 'healthy').toList();
      case 3: // Beast Meal
        return allDishes.where((dish) => dish.category == 'beast').toList();
      default:
        return allDishes;
    }
  }

  // Build dish cards from filtered list
  List<Widget> _buildFilteredDishCards() {
    final filteredDishes = getFilteredDishes();
    
    // Group dishes by category for display
    final Map<String, List<Dish>> dishesByCategory = {};
    
    for (var dish in filteredDishes) {
      if (!dishesByCategory.containsKey(dish.category)) {
        dishesByCategory[dish.category] = [];
      }
      dishesByCategory[dish.category]!.add(dish);
    }
    
    // If showing all dishes, display by category
    if (_selectedCategory == 0) {
      return dishesByCategory.entries.map((entry) {
        return _buildMenuCategory(
          _getCategoryTitle(entry.key),
          entry.value.map((dish) => _buildAnimatedDishCard(
            dish.name,
            dish.price,
            dish.imagePath,
            '${dish.category}-${dish.name}',
          )).toList(),
        );
      }).toList();
    } 
    // If filtering by specific category, show all dishes in that category
    else {
      return [
        _buildMenuCategory(
          categories[_selectedCategory],
          filteredDishes.map((dish) => _buildAnimatedDishCard(
            dish.name,
            dish.price,
            dish.imagePath,
            '${dish.category}-${dish.name}',
          )).toList(),
        )
      ];
    }
  }

  String _getCategoryTitle(String category) {
    switch (category) {
      case 'vegetarian':
        return 'Vegetarian Dishes';
      case 'healthy':
        return 'Healthy Meal';
      case 'beast':
        return 'Beast Meal';
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: _currentUser != null 
        ? _buildUserProfile()
        : _buildLoginButton(),
      actions: [
        PopupMenuButton<String>(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onSelected: (value) {
            if (value == 'feedback') {
              _navigateToFeedback();
            } else if (value == 'login' && _currentUser == null) {
              _showLoginDialog();
            } else if (value == 'profile' && _currentUser != null) {
              _showProfileDialog();
            } else if (value == 'logout' && _currentUser != null) {
              _logout();
            }
          },
          itemBuilder: (BuildContext context) {
            if (_currentUser != null) {
              return [
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('My Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'feedback',
                  child: Text('Give Feedback'),
                ),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            } else {
              return [
                const PopupMenuItem<String>(
                  value: 'login',
                  child: Text('Login'),
                ),
                const PopupMenuItem<String>(
                  value: 'feedback',
                  child: Text('Give Feedback'),
                ),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Settings'),
                ),
              ];
            }
          },
        ),
      ],
    );
  }

  Widget _buildUserProfile() {
    return GestureDetector(
      onTap: _showProfileMenu,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            backgroundImage: _currentUser?.profilePicture != null
                ? AssetImage(_currentUser!.profilePicture!)
                : null,
            child: _currentUser?.profilePicture == null
                ? const Icon(Icons.person, size: 16, color: Colors.black)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            _currentUser?.name.split(' ').first ?? 'User',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return _isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : InkWell(
            onTap: _showLoginDialog,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  fontStyle: FontStyle.italic,
                  color: Colors.white
                ),
              ),
            ),
          );
  }

  Widget _buildHeaderSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        color: Colors.black,
        child: Column(
          children: [
            // Logo Container - Optimized for PNG with transparency
            Container(
              width: 200, // Adjust width as needed
              height: 150, // Adjust height as needed
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.transparent, // Changed to transparent
                borderRadius: BorderRadius.circular(12),
                // Removed border and shadow for cleaner logo display
              ),
              child: Image.asset(
                logoDeliti,
                fit: BoxFit.contain, // Changed from BoxFit.cover to contain
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fastfood,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Logo Not Found',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redirecting to order page...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Order Now',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
        child: Column(
          children: [
            _buildMenuTitle(),
            const SizedBox(height: 24),
            _buildCategoryFilter(),
            const SizedBox(height: 32),
            _buildFilteredMenuContent(),
            const SizedBox(height: 40),
            _buildFeedbackSection(),
          ],
        ),
    );
  }

  Widget _buildMenuTitle() {
    return const Center(
      child: Text(
        'Our Menu',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Center(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildAnimatedCategoryChip(
                categories[index], 
                _selectedCategory == index,
                () {
                  setState(() {
                    _selectedCategory = index;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilteredMenuContent() {
    final filteredContent = _buildFilteredDishCards();
    
    if (filteredContent.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          'No dishes found in this category',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      );
    }
    
    return Column(children: filteredContent);
  }

  // Old method - kept for reference but not used anymore
  Widget _buildMenuCategories() {
    return Column(
      children: [
        _buildMenuCategory('Vegetarian Dishes', _buildVegetarianDishes()),
        _buildMenuCategory('Healthy Meal', _buildHealthyDishes()),
        _buildMenuCategory('Beast Meal', _buildBeastDishes()),
      ],
    );
  }

  // Old methods - kept for reference
  List<Widget> _buildVegetarianDishes() {
    return [
      _buildAnimatedDishCard('Dish1', '000,00', gambarMenuVege[0], 'vege-1'),
      _buildAnimatedDishCard('Dish2', '000,00', gambarMenuVege[1], 'vege-2'),
      _buildAnimatedDishCard('Dish3', '000,00', gambarMenuVege[2], 'vege-3'),
    ];
  }

  List<Widget> _buildHealthyDishes() {
    return [
      _buildAnimatedDishCard('Dish1', '000,00', gambarMenuHealthy[0], 'healthy-1'),
      _buildAnimatedDishCard('Dish2', '000,00', gambarMenuHealthy[1], 'healthy-2'),
      _buildAnimatedDishCard('Dish3', '000,00', gambarMenuHealthy[2], 'healthy-3'),
    ];
  }

  List<Widget> _buildBeastDishes() {
    return [
      _buildAnimatedDishCard('Dish1', '000,00', gambarMenuBeast[0], 'beast-1'),
      _buildAnimatedDishCard('Dish2', '000,00', gambarMenuBeast[1], 'beast-2'),
      _buildAnimatedDishCard('Dish3', '000,00', gambarMenuBeast[2], 'beast-3'),
    ];
  }

  Widget _buildAnimatedCategoryChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.red[400] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.red[400]! : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected ? [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDishCard(String name, String price, String imagePath, String uniqueId) {
    return GestureDetector(
      onTap: () {
        _showDishDetails(name, price, imagePath);
      },
      child: MouseRegion(
        onEnter: (_) => _updateHoverState(uniqueId, true),
        onExit: (_) => _updateHoverState(uniqueId, false),
        child: _buildDishCardContent(name, price, imagePath, uniqueId),
      ),
    );
  }

  Widget _buildMenuCategory(String title, List<Widget> dishes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.red, width: 3),
                right: BorderSide(color: Colors.red, width: 3),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: dishes,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return GestureDetector(
      onTap: _navigateToFeedback,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.feedback,
              color: Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have feedback?  $version',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Help us improve your experience',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showDishDetails(String name, String price, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp $price',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDishCardContent(String name, String price, String imagePath, String uniqueId) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..scale(_isHovered(uniqueId) ? 1.02 : 1.0),
      child: Stack(
        children: [
          Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: _isHovered(uniqueId) 
                    ? Colors.red.withOpacity(0.2)
                    : Colors.black12,
                  blurRadius: _isHovered(uniqueId) ? 8 : 4,
                  offset: Offset(0, _isHovered(uniqueId) ? 4 : 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 100,
                        width: double.infinity,
                        child: Image.asset(
                          imagePath, 
                          fit: BoxFit.cover,
                          color: _isHovered(uniqueId) 
                            ? Colors.black.withOpacity(0.1)
                            : null,
                          colorBlendMode: _isHovered(uniqueId) 
                            ? BlendMode.darken 
                            : BlendMode.srcOver,
                        ),
                      ),
                    ),
                    if (_isHovered(uniqueId))
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _isHovered(uniqueId) ? 15 : 14,
                          color: _isHovered(uniqueId) 
                            ? Colors.red[800]
                            : Colors.black,
                        ),
                        child: Text(name),
                      ),
                      const SizedBox(height: 2),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          'Rp $price',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: _isHovered(uniqueId) ? 16 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final String? profilePicture;
  
  User({
    required this.name,
    required this.email,
    this.profilePicture,
  });
}

class AuthService {
  static final Map<String, String> _validUsers = {
    'a@gmail.com': 'a',
  };

  static User? login(String email, String password) {
    if (_validUsers[email] == password) {
      return User(
        name: _getNameFromEmail(email),
        email: email,
        profilePicture: null,
      );
    }
    return null;
  }

  static String _getNameFromEmail(String email) {
    final namePart = email.split('@').first;
    return namePart[0].toUpperCase() + namePart.substring(1);
  }
}

class Dish {
  final String name;
  final String price;
  final String imagePath;
  final String category;

  Dish({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}

List<Dish> allDishes = [
  Dish(name: 'Vegetable Salad', price: '25,000', imagePath: "assets/gambar/MENU-VEGE/dish1.jpeg", category: 'vegetarian'),
  Dish(name: 'Tofu Stir Fry', price: '30,000', imagePath: "assets/gambar/MENU-VEGE/dish2.jpeg", category: 'vegetarian'),
  Dish(name: 'Mushroom Pasta', price: '35,000', imagePath: "assets/gambar/MENU-VEGE/dish3.jpeg", category: 'vegetarian'),
  
  Dish(name: 'Grilled Chicken', price: '45,000', imagePath: "assets/gambar/MENU-HEALTHY/dish1.jpeg", category: 'healthy'),
  Dish(name: 'Quinoa Bowl', price: '40,000', imagePath: "assets/gambar/MENU-HEALTHY/dish2.jpeg", category: 'healthy'),
  Dish(name: 'Salmon Salad', price: '50,000', imagePath: "assets/gambar/MENU-HEALTHY/dish3.jpeg", category: 'healthy'),
  
  Dish(name: 'Beef Steak', price: '75,000', imagePath: "assets/gambar/MENU-BEAST/dish1.jpeg", category: 'beast'),
  Dish(name: 'BBQ Ribs', price: '65,000', imagePath: "assets/gambar/MENU-BEAST/dish2.jpeg", category: 'beast'),
  Dish(name: 'Burger Combo', price: '55,000', imagePath: "assets/gambar/MENU-BEAST/dish3.jpeg", category: 'beast'),
];