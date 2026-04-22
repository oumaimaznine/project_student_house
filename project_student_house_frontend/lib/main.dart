import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/dashboard_screen.dart';

void main() {
  runApp(const StudentHouseApp());
}

class StudentHouseApp extends StatelessWidget {
  const StudentHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student House',

      // 🚀 PAGE DE DÉPART
      initialRoute: '/login',

      // 🧭 ROUTES
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}