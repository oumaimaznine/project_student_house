import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String message = "";
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      final url = Uri.parse("http://127.0.0.1:8000/api/login");

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {

        setState(() {
          message = "Connexion réussie ✅";
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              user: data['user'],
            ),
          ),
        );

      } else {
        setState(() {
          message = data['message'] ?? "Email ou mot de passe incorrect ❌";
        });
      }

    } catch (e) {
      setState(() {
        message = "Erreur serveur ❌";
      });
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              // 🔵 LOGO
              const CircleAvatar(
                radius: 45,
                backgroundColor: Color.fromARGB(255, 60, 142, 209),
                child: Icon(Icons.home, size: 45, color: Colors.white),
              ),

              const SizedBox(height: 15),

              const Text(
                "Student House",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 60, 142, 209),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Ton hub académique intelligent",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // 📧 EMAIL
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 🔒 PASSWORD
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔵 BUTTON LOGIN (COULEUR MODIFIÉE)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 142, 209), // 🔵 TA COULEUR
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Se connecter",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 15),

              // ⚠️ MESSAGE
              Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),

              const SizedBox(height: 10),

              // 🔗 REGISTER
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Pas encore de compte ? S'inscrire",
                  style: TextStyle(color: Color.fromARGB(255, 60, 142, 209)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}