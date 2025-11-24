import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'pages/home_page.dart';

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
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}