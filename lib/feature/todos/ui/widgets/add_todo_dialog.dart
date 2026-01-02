import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todo_bloc.dart';
import '../../bloc/todo_event.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _todoTitleController = TextEditingController();

  @override
  void dispose() {
    _todoTitleController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _todoTitleController.text.trim();
    if (text.isEmpty) return;

    context.read<TaskBloc>().add(AddTodos(text));
    _todoTitleController.clear();
    Navigator.pop(context);

    if (widget.controller.hasClients) {
      widget.controller.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 24,
        title: const Text(
          "Add Todo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _todoTitleController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter todo title",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () {
              _todoTitleController.clear();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: _addTodo,
            icon: const Icon(Icons.add),
            label: const Text("Add"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
