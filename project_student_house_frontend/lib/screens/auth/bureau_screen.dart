import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/services/api_service.dart';

class BureauScreen extends StatefulWidget {
  const BureauScreen({super.key});

  @override
  State<BureauScreen> createState() => _BureauScreenState();
}

class _BureauScreenState extends State<BureauScreen> {
  final ApiService api = ApiService();
  final TextEditingController controller = TextEditingController();

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  List tasks = [];
  String priority = "medium";
  DateTime? dueDateTime;

  @override
  void initState() {
    super.initState();
    initNotifications();
    loadTasks();
  }

  // 🔔 INIT NOTIFICATIONS
  void initNotifications() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    notifications.initialize(settings);
  }

  // 🔔 SHOW NOTIFICATION
  Future<void> showReminder(String title) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Tasks',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await notifications.show(
      0,
      'Nouvelle tâche',
      title,
      details,
    );
  }

  // 📅 LOAD + SORT BY DATE
  Future<void> loadTasks() async {
    tasks = await api.getTasks();

    tasks.sort((a, b) {
      if (a['due_date'] == null || b['due_date'] == null) return 0;
      return DateTime.parse(a['due_date'])
          .compareTo(DateTime.parse(b['due_date']));
    });

    setState(() {});
  }

  // 🔴 TASK OVERDUE
  bool isOverdue(String? dueDate) {
    if (dueDate == null) return false;
    return DateTime.parse(dueDate).isBefore(DateTime.now());
  }

  // 🎨 COLOR PRIORITY + OVERDUE
  Color getColor(String priority, String? dueDate) {
    if (dueDate != null && isOverdue(dueDate)) {
      return Colors.red;
    }

    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  // 🏷 PRIORITY BADGE
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

  // 📅 FORMAT DATE
  String formatDate(String date) {
    final dt = DateTime.parse(date);
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  // ➕ ADD TASK
  Future<void> addTask() async {
    if (controller.text.isEmpty) return;
    if (dueDateTime == null) return;

    await api.addTask(
      controller.text,
      priority,
      dueDateTime!.toIso8601String(),
    );

    showReminder(controller.text);

    controller.clear();
    dueDateTime = null;

    Navigator.pop(context);
    loadTasks();
  }

  // 🗑 DELETE TASK
  void deleteTask(int id) async {
    await api.deleteTask(id);
    loadTasks();
  }

  // 📅 BOTTOM SHEET
  void showAddSheet() {
    controller.clear();
    priority = "medium";
    dueDateTime = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "Nouvelle tâche",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // TITLE
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: "Tâche",
                        prefixIcon: const Icon(Icons.task),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // PRIORITY
                    DropdownButtonFormField(
                      value: priority,
                      items: const [
                        DropdownMenuItem(value: "high", child: Text("HIGH")),
                        DropdownMenuItem(value: "medium", child: Text("MEDIUM")),
                        DropdownMenuItem(value: "low", child: Text("LOW")),
                      ],
                      onChanged: (v) {
                        setModalState(() {
                          priority = v.toString();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Priorité",
                        prefixIcon: const Icon(Icons.flag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // DATE PICKER
                    InkWell(
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (date == null) return;

                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time == null) return;

                        setModalState(() {
                          dueDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                dueDateTime == null
                                    ? "Choisir la date de réalisation"
                                    : "${dueDateTime!.day}/${dueDateTime!.month}/${dueDateTime!.year} "
                                      "${dueDateTime!.hour.toString().padLeft(2, '0')}:${dueDateTime!.minute.toString().padLeft(2, '0')}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Enregistrer"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
                  child: ListTile(
                    leading: Container(
                      width: 5,
                      height: 50,
                      color: getColor(t['priority'], t['due_date']),
                    ),

                    title: Text(
                      t['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),

                        priorityBadge(t['priority']),

                        const SizedBox(height: 5),

                        if (t['due_date'] != null)
                          Text(
                            "📅 ${formatDate(t['due_date'])}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
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