import 'package:flutter/material.dart';
import '/services/api_service.dart';

class BureauScreen extends StatefulWidget {
  const BureauScreen({super.key});

  @override
  State<BureauScreen> createState() => _BureauScreenState();
}

class _BureauScreenState extends State<BureauScreen> {
  final ApiService api = ApiService();
  final TextEditingController controller = TextEditingController();

  List tasks = [];
  String priority = "medium";

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await api.getTasks();
    setState(() {});
  }

  // 🎨 Couleur priorité
  Color getColor(String p) {
    switch (p.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  // 🏷 BADGE PRIORITÉ (NEW)
  Widget priorityBadge(String p) {
    Color color;

    switch (p.toLowerCase()) {
      case "high":
        color = Colors.red;
        break;
      case "medium":
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        p.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 📅 Format date Laravel → Flutter
  String formatDate(String date) {
    final dt = DateTime.parse(date);
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  // ➕ ADD TASK
  void addTask() async {
    if (controller.text.isEmpty) return;

    await api.addTask(controller.text, priority);

    controller.clear();
    Navigator.pop(context);
    loadTasks();
  }

  // 🗑 DELETE TASK
  void deleteTask(int id) async {
    await api.deleteTask(id);
    loadTasks();
  }

  // ➕ MODERN BOTTOM SHEET
  void showAddSheet() {
    controller.clear();
    priority = "medium";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Nouvelle tâche",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Que dois-tu faire ?",
                prefixIcon: const Icon(Icons.task),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: priority,
              items: const [
                DropdownMenuItem(value: "high", child: Text("HIGH")),
                DropdownMenuItem(value: "medium", child: Text("MEDIUM")),
                DropdownMenuItem(value: "low", child: Text("LOW")),
              ],
              onChanged: (v) => setState(() => priority = v.toString()),
              decoration: InputDecoration(
                labelText: "Priorité",
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: addTask,
                icon: const Icon(Icons.add),
                label: const Text("Enregistrer dans le bureau"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 📱 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Bureau"),
        backgroundColor: Colors.indigo,
      ),

      body: tasks.isEmpty
          ? const Center(child: Text("Aucune tâche"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final t = tasks[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 5,
                      height: 50,
                      color: getColor(t['priority']),
                    ),

                    title: Text(
                      t['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),

                        Text(
                          t['created_at'] != null
                              ? formatDate(t['created_at'])
                              : "",
                          style: const TextStyle(fontSize: 12),
                        ),

                        const SizedBox(height: 5),

                        priorityBadge(t['priority']),
                      ],
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteTask(t['id']),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddSheet,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}