import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '/services/api_service.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {

  bool isLoading = false;
  List<Map<String, dynamic>> planning = [];

  DateTime selectedDay = DateTime.now();

  // =========================
  // GENERATE PLANNING
  // =========================
  Future<void> generatePlanning() async {
    setState(() => isLoading = true);

    try {
      final data = await ApiService.generatePlanning(1);

      setState(() {
        planning = List<Map<String, dynamic>>.from(data);
      });

    } catch (e) {
      debugPrint("ERROR generate: $e");
    }

    setState(() => isLoading = false);
  }

  // =========================
  // LOAD BY DATE
  // =========================
  Future<void> loadByDate(DateTime date) async {
    try {
      final data = await ApiService.getByDate(
        date.toIso8601String().split("T")[0],
      );

      setState(() {
        planning = List<Map<String, dynamic>>.from(data);
      });

    } catch (e) {
      debugPrint("LOAD ERROR: $e");
    }
  }

  // =========================
  // COLORS
  // =========================
  Color priorityColor(String? p) {
    if (p == "high") return Colors.red;
    if (p == "medium") return Colors.orange;
    return Colors.green;
  }

  // =========================
  // EXAM ALERT
  // =========================
  bool get hasExamWarning {
    return planning.any((task) {
      final dueStr = task["due_at"];
      if (dueStr == null) return false;

      final due = DateTime.tryParse(dueStr.toString());
      if (due == null) return false;

      return due.difference(DateTime.now()).inDays <= 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Cuisine - Planning AI"),
        backgroundColor: Colors.orange,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Planning AI 📚",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "AI Smart Planning + Calendar Filter",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // CALENDAR
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),

              selectedDayPredicate: (day) =>
                  isSameDay(selectedDay, day),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                });

                loadByDate(selectedDay);
              },
            ),

            const SizedBox(height: 15),

            // ALERT
            if (hasExamWarning)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "⚠ Deadline / Exam proche",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: generatePlanning,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Generate Planning"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),

            const SizedBox(height: 15),

            if (isLoading)
              const Center(child: CircularProgressIndicator()),

            if (!isLoading && planning.isEmpty)
              const Center(child: Text("No tasks for this day")),

            if (planning.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: planning.length,
                  itemBuilder: (context, index) {

                    final item = planning[index];

                    return Card(
                      child: ListTile(

                        leading: CircleAvatar(
                          backgroundColor:
                              priorityColor(item["color"]?.toString()),
                          child: const Icon(
                            Icons.schedule,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(item["title"]?.toString() ?? ""),

                        subtitle: Text(
                          "${item["start_at"] ?? ""} → ${item["end_at"] ?? ""}",
                        ),

                        trailing: Text(item["color"]?.toString() ?? ""),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}