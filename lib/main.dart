import 'package:flutter/material.dart';
import 'login.dart';
// import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank System',
      theme: ThemeData(
        primaryColor: const Color(0xFF5E2EB8),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF5E2EB8),
        ),
      ),
      home: const LoginPage(),
      // home: HomeScreen(),
    );
  }
}
