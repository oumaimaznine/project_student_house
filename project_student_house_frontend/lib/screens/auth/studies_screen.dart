import 'package:flutter/material.dart';

class StudiesScreen extends StatelessWidget {
  const StudiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes Etudes")),
      body: const Center(child: Text("Etudes")),
    );
  }
}