import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Objectifs")),
      body: const Center(
        child: Text("🎯 Objectifs"),
      ),
    );
  }
}