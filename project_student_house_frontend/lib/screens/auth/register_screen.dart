import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String message = "";

  Future<void> register() async {
    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      final url = Uri.parse("http://127.0.0.1:8000/api/register");

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {

        setState(() {
          message = "Compte créé avec succès ✅";
        });

        print("TOKEN: ${data['token']}");
        print("USER: ${data['user']}");

      } else {
        setState(() {
          message = data['message'] ?? "Erreur lors de l'inscription ❌";
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

              // 🔵 ICON
              const CircleAvatar(
                radius: 45,
                backgroundColor: Color.fromARGB(255, 60, 142, 209),
                child: Icon(Icons.home, size: 45, color: Colors.white),
              ),

              const SizedBox(height: 10),

              const Text(
                "Student House",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 60, 142, 209),
                ),
              ),

              const SizedBox(height: 20),

              // 👤 NAME
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Nom",
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

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

              // 🔵 BUTTON REGISTER
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 142, 209),
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
                          "Créer un compte",
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

              // 🔗 LOGIN
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Tu as déjà un compte ? Se connecter",
                  style: TextStyle(
                    color: Color.fromARGB(255, 60, 142, 209),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}