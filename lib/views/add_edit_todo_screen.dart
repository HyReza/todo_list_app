import 'package:flutter/material.dart';
import 'package:todolist/controllers/todo_controller.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/todo.dart';

class AddEditTodoScreen extends StatefulWidget {
  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Todo? todo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mengambil todo yang dikirimkan sebagai argumen
    final Todo? todoArg = ModalRoute.of(context)?.settings.arguments as Todo?;
    if (todoArg != null) {
      todo = todoArg;
      titleController.text = todo!.title;
      descriptionController.text = todo!.description;
    }
  }

  void saveTodo(BuildContext context) {
    final todoController = Provider.of<TodoController>(context, listen: false);
    if (todo == null) {
      todoController.addTodo(titleController.text, descriptionController.text);
    } else {
      todoController.updateTodo(
          todo!.id, titleController.text, descriptionController.text);
    }

    // Menampilkan Snackbar untuk memberi tahu bahwa tugas berhasil diubah
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(todo == null
            ? 'Task added successfully!'
            : 'Task updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Kembali ke HomeScreen setelah selesai
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo == null ? 'Add Task' : 'Edit Task'),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.blue.shade700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.blue.shade700),
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => saveTodo(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  todo == null ? 'Add Task' : 'Save Changes',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
