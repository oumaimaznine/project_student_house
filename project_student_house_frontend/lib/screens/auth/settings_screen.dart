import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool notifications = true;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? "";
      emailController.text = prefs.getString('email') ?? "";
      notifications = prefs.getBool('notifications') ?? true;
      darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  void saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil mis à jour ✅")),
    );
  }

  void toggleDark(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);

    setState(() => darkMode = value);
    StudentHouseApp.of(context)?.changeTheme(value);
  }

  void toggleNotif(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);

    setState(() => notifications = value);
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Widget card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          )
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.blue,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // 👤 PROFILE
          card(
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white, size: 40),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nom",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text("Enregistrer"),
                ),
              ],
            ),
          ),

          sectionTitle("Préférences"),

          // ⚙️ SETTINGS
          card(
            child: Column(
              children: [

                SwitchListTile(
                  value: notifications,
                  title: const Text("Notifications"),
                  secondary: const Icon(Icons.notifications),
                  onChanged: toggleNotif,
                ),

                SwitchListTile(
                  value: darkMode,
                  title: const Text("Mode sombre"),
                  secondary: const Icon(Icons.dark_mode),
                  onChanged: toggleDark,
                ),
              ],
            ),
          ),

          sectionTitle("Compte"),

          card(
            child: Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text("Sécurité"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),

                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text("Aide"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔴 LOGOUT (SMALL BUTTON FIX ✔)
          Center(
            child: SizedBox(
              width: 180, // 🔥 largeur réduite
              height: 42, // 🔥 hauteur réduite
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text(
                  "Déconnexion",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}