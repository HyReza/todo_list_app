import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/controllers/todo_controller.dart';
import 'package:todolist/views/add_edit_todo_screen.dart';
import 'package:todolist/views/todo_detail_screen.dart';
import 'package:todolist/views/login_screen.dart'; // Import LoginScreen
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDateIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoController>(context, listen: false).fetchTodos();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TodoController>(context, listen: false).fetchTodos();
  }

  void showFlushbar(BuildContext context, String message,
      {Color? backgroundColor, IconData? icon}) {
    Flushbar(
      message: message,
      icon: Icon(
        icon,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: backgroundColor,
      backgroundColor: backgroundColor ?? Colors.blue,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoController>(context);

    final now = DateTime.now();
    final weekDates =
        List.generate(7, (index) => now.add(Duration(days: index)));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              todoController.setToken(''); // Clear token

              // Navigate to LoginScreen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false, // Remove all previous routes
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out successfully!'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weekDates.length,
                  itemBuilder: (context, index) {
                    final date = weekDates[index];
                    final isSelected = index == selectedDateIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDateIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.white : Colors.blue.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E().format(date),
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              DateFormat.d().format(date),
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: todoController.todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 100,
                            color: Colors.blue.shade200,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No tasks available!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: todoController.todos.length,
                      itemBuilder: (context, index) {
                        final todo = todoController.todos[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              todo.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            trailing: Icon(
                              todo.completed
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color:
                                  todo.completed ? Colors.green : Colors.grey,
                              size: 28,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TodoDetailScreen(todo: todo),
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Delete Task'),
                                  content: Text(
                                      'Are you sure you want to delete this task?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await todoController
                                            .deleteTodo(todo.id);
                                        Navigator.pop(ctx);
                                        showFlushbar(
                                          context,
                                          'Task deleted successfully!',
                                          backgroundColor: Colors.red,
                                          icon: Icons.delete_forever,
                                        );
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTodoScreen()),
          );
          if (result != null && result == true) {
            await todoController.fetchTodos();
            setState(() {});

            showFlushbar(
              context,
              'New task added successfully!',
              backgroundColor: Colors.green,
              icon: Icons.check_circle_outline,
            );
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 28),
      ),
    );
  }
}
