import 'package:flutter/material.dart';
import '../../domain/entity/todo.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onChange,
    required this.onDelete,
  });

  final Todo todo;
  final void Function(bool?, int) onChange;
  final void Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(todo.id),
      child: CheckboxListTile(
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        value: todo.completed,
        onChanged: (checked) => onChange(checked, todo.id),
      ),
    );
  }
}
