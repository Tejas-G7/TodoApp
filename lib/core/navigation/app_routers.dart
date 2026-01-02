import 'package:flutter/material.dart';
import '../../feature/auth/ui/auth_screen.dart';
import '../../feature/todos/ui/todo_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        );

      case AppRoutes.todos:
        return MaterialPageRoute(
          builder: (_) => const TodoScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
