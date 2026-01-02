import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/navigation/app_routers.dart';
import 'package:todo_app/core/navigation/app_routes.dart';
import 'package:todo_app/feature/auth/bloc/auth_bloc.dart';
import 'package:todo_app/feature/todos/bloc/todo_bloc.dart';
import 'package:todo_app/feature/todos/bloc/todo_event.dart';
import 'package:todo_app/feature/todos/di/todo_di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TaskBloc>()..add(LoadTodos())),
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
