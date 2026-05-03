import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "http://127.0.0.1:8000/api";

  // =====================================================
  // TASKS
  // =====================================================

  static Future<List<dynamic>> getTasks() async {
    final response = await http.get(
      Uri.parse("$baseUrl/tasks"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur GET tasks");
    }
  }

  static Future<bool> addTask(
      String title, String priority, String dueDate) async {
    final response = await http.post(
      Uri.parse("$baseUrl/tasks"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "title": title,
        "priority": priority,
        "due_date": dueDate,
      }),
    );

    return response.statusCode == 201;
  }

  static Future<bool> updateTask(
      int id, String title, String priority) async {
    final response = await http.put(
      Uri.parse("$baseUrl/tasks/$id"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "title": title,
        "priority": priority,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/tasks/$id"),
      headers: {"Accept": "application/json"},
    );

    return response.statusCode == 200;
  }

  // =====================================================
  // PLANNING (AI)
  // =====================================================

  static Future<List<dynamic>> generatePlanning(int userId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/generate-planning"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    return jsonDecode(res.body);
  }

  static Future<void> savePlanning(List planning) async {
    await http.post(
      Uri.parse("$baseUrl/save-planning"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": 1,
        "planning": planning,
      }),
    );
  }

  static Future<List<dynamic>> getByDate(String date) async {
    final res = await http.post(
      Uri.parse("$baseUrl/planning-by-date"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": 1,
        "date": date,
      }),
    );

    return jsonDecode(res.body);
  }
}