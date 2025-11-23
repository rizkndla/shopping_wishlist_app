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
        scaffoldBackgroundColor: Color(0xFFeae6e0),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF325eba),
          background: Color(0xFFeae6e0),
          surface: Color(0xFFf7f4f0),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF325eba),
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}