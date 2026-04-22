import 'package:flutter/material.dart';

class IASolverScreen extends StatelessWidget {
  const IASolverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IA Solver")),
      body: const Center(
        child: Text("🤖 IA Solver"),
      ),
    );
  }
}