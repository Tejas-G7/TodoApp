import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/feature/todos/ui/widgets/add_todo_dialog.dart';

import '../../../core/navigation/app_routes.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../domain/entity/todo.dart';
import 'widgets/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutRequested());
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showAddTodoDialog() {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddTodoDialog(controller: _scrollController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTodoDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add Todo"),
      ),
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search todos",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (query) {
            context.read<TaskBloc>().add(SearchTodo(query));
          },
        ),
        leading: Icon(Icons.today_outlined),
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: BlocConsumer<TaskBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TodoLoaded) {
              final todos = state.todos;

              if (todos.isEmpty) {
                return const Center(
                  child: Text("No todos yet", style: TextStyle(fontSize: 16)),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TaskBloc>().add(LoadTodos());
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final Todo todo = todos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: TodoTile(
                        todo: todo,
                        onChange: (checked, id) {
                          if (checked != null) {
                            context.read<TaskBloc>().add(ToggleTodo(id: id, toggle: checked));
                          }
                        },
                        onDelete: (id) {
                          context.read<TaskBloc>().add(DeleteTodo(id));
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }
}
