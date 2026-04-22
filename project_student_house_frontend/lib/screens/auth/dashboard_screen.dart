import 'package:flutter/material.dart';
import 'app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  final dynamic user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    final String userName = user != null
        ? (user['name'] ?? 'Utilisateur')
        : 'Utilisateur';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔵 APP BAR
      appBar: AppBar(
        title: const Text("Student House"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      // 🍔 DRAWER ✔ CORRIGÉ
      drawer: AppDrawer(user: user),

      // 📊 BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 👋 GREETING
              Text(
                "Bonjour $userName 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Bienvenue dans ton espace étudiant \nOrganise ton travail et réussis tes objectifs ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              // 🧱 GRID MENU
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
               dashboardCard(Icons.school, "Mes Etudes", Colors.green),

dashboardCard(Icons.calendar_month, "Planning", Colors.orange),

dashboardCard(Icons.insights, "Stats", Colors.purple),

dashboardCard(Icons.smart_toy, "IA Solver", Colors.teal),

dashboardCard(Icons.work_outline, "Projets", Colors.blue),

dashboardCard(Icons.flag, "Objectifs", Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🧱 CARD WIDGET
  Widget dashboardCard(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}