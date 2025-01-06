import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/services/api_service.dart';

class TodoController with ChangeNotifier {
  List<Todo> _todos = [];
  String _token = '';

  List<Todo> get todos => _todos;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  Future<void> fetchTodos() async {
    try {
      final response = await ApiService.getTodos(_token);
      _todos = response.map<Todo>((todo) => Todo.fromJson(todo)).toList();
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(String title, String description) async {
    try {
      final response = await ApiService.addTodo(title, description, _token);
      _todos.add(Todo.fromJson(response));
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> updateTodo(int id, String title, String description) async {
    try {
      final updatedTodo =
          await ApiService.updateTodo(id, title, description, _token);
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todos[index] = Todo.fromJson(updatedTodo);
        notifyListeners();
      }
    } catch (error) {
      throw Exception('Failed to update todo');
    }
  }

  // todo_controller.dart
  Future<void> updateTodoStatus(int id, bool completed) async {
    try {
      // Panggil API untuk memperbarui status `completed` menggunakan PUT
      final updatedTodo =
          await ApiService.updateTodoStatus(id, completed, _token);

      // Cari indeks todo berdasarkan id
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        // Perbarui data pada daftar `_todos`
        _todos[index] = Todo.fromJson(updatedTodo);
        notifyListeners();
      }
    } catch (error) {
      throw Exception('Failed to update todo status');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await ApiService.deleteTodo(id, _token);
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to delete todo');
    }
  }

  // Tambahkan fungsi untuk mengambil todo berdasarkan ID
  Future<Todo?> getTodoById(int id) async {
    try {
      // Mencari todo berdasarkan id dari list _todos
      return _todos.firstWhere((todo) => todo.id == id,
          orElse: () =>
              Todo(id: -1, title: '', description: '', completed: false));
    } catch (error) {
      throw Exception('Todo not found');
    }
  }
}
