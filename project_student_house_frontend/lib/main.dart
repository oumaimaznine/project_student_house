import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/dashboard_screen.dart';

void main() {
  runApp(const StudentHouseApp());
}


class StudentHouseApp extends StatefulWidget {
  const StudentHouseApp({super.key});

  static _StudentHouseAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_StudentHouseAppState>();

  @override
  State<StudentHouseApp> createState() => _StudentHouseAppState();
}

class _StudentHouseAppState extends State<StudentHouseApp> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  // 🔄 charger le mode sauvegardé
  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('darkMode') ?? false;
    });
  }

  // 🌙 changer mode sombre
  void changeTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);

    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student House',

      // 🌞 LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),

      // 🌙 DARK THEME (BLACK FULL)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // 🔥 FULL BLACK

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),

        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.black,
        ),

        cardColor: const Color(0xFF1E1E1E),

        iconTheme: const IconThemeData(color: Colors.white),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),

      // 🔁 SWITCH MODE
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(user: null),
      },
    );
  }
}