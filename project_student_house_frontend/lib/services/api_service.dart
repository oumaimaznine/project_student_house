import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🌐 Laravel backend (Chrome / Web)
  final String baseUrl = "http://127.0.0.1:8000/api";

  // ================= GET TASKS =================
  Future<List<dynamic>> getTasks() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tasks"),
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Erreur GET tasks: ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur réseau GET: $e");
    }
  }

  // ================= ADD TASK =================
  Future<bool> addTask(String title, String priority) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/tasks"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": title,
          "priority": priority,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Erreur ADD: $e");
      return false;
    }
  }

  // ================= UPDATE TASK =================
  Future<bool> updateTask(int id, String title, String priority) async {
    try {
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
    } catch (e) {
      print("Erreur UPDATE: $e");
      return false;
    }
  }

  // ================= DELETE TASK =================
  Future<bool> deleteTask(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/tasks/$id"),
        headers: {
          "Accept": "application/json",
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Erreur DELETE: $e");
      return false;
    }
  }
}