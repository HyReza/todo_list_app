import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/controllers/todo_controller.dart';
import 'package:todolist/views/add_edit_todo_screen.dart';
import 'package:todolist/views/home_screen.dart';
import 'package:todolist/views/login_screen.dart';
import 'package:todolist/views/register_screen.dart';
import 'package:todolist/views/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do List App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
          '/addEditTodo': (context) => AddEditTodoScreen(),
        },
      ),
    );
  }
}
