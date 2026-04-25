import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'planning_screen.dart';
import 'stats_screen.dart';
import 'ia_solver_screen.dart';
import 'projects_screen.dart';
import 'goals_screen.dart';
import 'bureau_screen.dart';

class DashboardScreen extends StatelessWidget {
  final dynamic user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String userName =
        user != null ? (user['name'] ?? 'Utilisateur') : 'Utilisateur';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Student House"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      drawer: AppDrawer(user: user),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Bonjour $userName 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Bienvenue dans ton espace étudiant",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,

                children: [

                  dashboardCard(
                    context,
                    Icons.school,
                    "Mes Etudes",
                    Colors.green,
                    BureauScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.calendar_month,
                    "Planning",
                    Colors.orange,
                    PlanningScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.insights,
                    "Stats",
                    Colors.purple,
                    StatsScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.smart_toy,
                    "IA Solver",
                    Colors.teal,
                    IASolverScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.work_outline,
                    "Projets",
                    Colors.blue,
                    ProjectsScreen(),
                  ),

                  dashboardCard(
                    context,
                    Icons.flag,
                    "Objectifs",
                    Colors.red,
                    GoalsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    Widget page,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => page,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
          ),
        );
      },

      borderRadius: BorderRadius.circular(20),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}