import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Wishlist',
      theme: ThemeData(
        primaryColor: Color(0xFF325eba),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF325eba),
          secondary: Color(0xFF1c1c1c),
          background: Color(0xFFeae6e0),
          surface: Color(0xFFf7f4f0),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFFeae6e0),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF325eba),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        // ✅ FIX: Gunakan CardThemeData bukan CardTheme
        cardTheme: CardThemeData(
          color: Color(0xFFf7f4f0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFf7f4f0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF325eba), width: 2),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}