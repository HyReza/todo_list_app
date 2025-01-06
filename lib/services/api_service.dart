import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://apitodos.hyreza.my.id/api";

  // Login API
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Validasi token
      if (responseData.containsKey('token')) {
        return responseData;
      } else {
        throw Exception("Token not found in response");
      }
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to login");
    }
  }

  // Register API
  static Future<Map<String, dynamic>> register(String name, String email,
      String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to register");
    }
  }

  // Fetch Todos
  static Future<List<dynamic>> getTodos(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/todo"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('data')) {
        return responseData['data'];
      } else {
        throw Exception("Data field not found in response");
      }
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to fetch todos");
    }
  }

  // Add Todo
  static Future<Map<String, dynamic>> addTodo(
      String title, String description, String token) async {
    final response = await http.post(
      Uri.parse("$baseUrl/todo"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "description": description,
        "completed": 0,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to add todo");
    }
  }

  // Update Todo Status
  static Future<Map<String, dynamic>> updateTodoStatus(
      int id, bool completed, String token) async {
    final response = await http.put(
      Uri.parse("$baseUrl/todo/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "completed": completed ? 1 : 0
      }), // Status: 1 (completed) or 0 (not completed)
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(
          errorResponse['message'] ?? "Failed to update todo status");
    }
  }

  // Update Todo
  static Future<Map<String, dynamic>> updateTodo(
      int id, String title, String description, String token) async {
    final response = await http.put(
      Uri.parse("$baseUrl/todo/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"title": title, "description": description}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to update todo");
    }
  }

  // Delete Todo
  static Future<void> deleteTodo(int id, String token) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/todo/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to delete todo");
    }
  }
}
