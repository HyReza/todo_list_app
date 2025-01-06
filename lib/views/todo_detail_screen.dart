import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/controllers/todo_controller.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo todo;

  TodoDetailScreen({required this.todo});

  @override
  _TodoDetailScreenState createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late Todo todo;

  @override
  void initState() {
    super.initState();
    todo = widget.todo;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Memastikan data selalu terupdate setiap kali tampilan dibuka atau kembali
    _updateTodo();
  }

  Future<void> _updateTodo() async {
    final todoController = Provider.of<TodoController>(context, listen: false);
    final updatedTodo = await todoController.getTodoById(todo.id);
    if (updatedTodo != null && mounted) {
      setState(() {
        todo = updatedTodo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Description Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        todo.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Status Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        todo.completed ? 'Completed' : 'Pending',
                        style: TextStyle(
                          fontSize: 18,
                          color: todo.completed ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Edit Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/addEditTodo',
                    arguments: todo,
                  ).then((updatedTodo) async {
                    if (updatedTodo != null) {
                      // Casting updatedTodo ke tipe Todo
                      setState(() {
                        todo = updatedTodo as Todo; // Melakukan casting ke Todo
                      });
                    }
                  });
                },
                icon: Icon(Icons.edit),
                label: Text('Edit Task'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Toggle Complete/Incomplete Button
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final updatedStatus = !todo.completed;
                  try {
                    await todoController.updateTodoStatus(
                      todo.id,
                      updatedStatus,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          updatedStatus
                              ? 'Task marked as completed!'
                              : 'Task marked as pending!',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    setState(() {
                      // Membuat objek Todo baru dengan status yang diperbarui
                      todo = Todo(
                        id: todo.id,
                        title: todo.title,
                        description: todo.description,
                        completed: updatedStatus,
                      );
                    });
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update task status.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: todo.completed ? Colors.green : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  todo.completed ? Icons.undo : Icons.check,
                ),
                label: Text(
                  todo.completed ? 'Undo Complete' : 'Mark as Completed',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
