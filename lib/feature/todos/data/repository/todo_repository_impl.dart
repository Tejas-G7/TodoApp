import 'dart:convert';

import 'package:todo_app/core/utils/enums/status_code.dart';
import 'package:todo_app/feature/todos/domain/todo_store/todo_database.dart';

import '../../../../core/network/network_response.dart';
import '../../../../core/network/todo_network.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entity/todo.dart';
import '../../domain/repository/todo_repository.dart';
import '../model/todo_dto.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoNetwork network;
  final TodoDatabase db;

  TodoRepositoryImpl(this.network, this.db);

  @override
  Future<Result<List<Todo>>> getTodos() async {
    try {
      final localTodos = await db.getAll();

      final response = await network.get(Uri.parse(TodoConstants.baseUrl));
      if (response.statusCode == StatusCode.success.code) {
        final list = TodoDTO.fromList(jsonDecode(response.body));
        for (final dto in list) {
          await db.insert(dto.toTodo());
        }

        return Success(await db.getAll());
      }

      return Success(localTodos);
    } catch (e) {
      return Success(await db.getAll());
    }
  }

  @override
  Future<Result<bool>> addTodo(int id, String title) async {
    final todo = Todo(id: id, title: title, completed: false, isSynced: false);

    await db.insert(todo);

    try {
      final response = await network.post(
        Uri.parse(TodoConstants.baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toMap()),
      );

      if (response.statusCode == StatusCode.success.code || response.statusCode == StatusCode.created.code) {
        await db.update(todo.copyWith(isSynced: true));
        return const Success(true);
      }
      return Failure("Failed to sync todo");
    } catch (_) {
      return const Success(true);
    }
  }

  @override
  Future<Result<bool>> updateTodo(int id, String title) async {
    final todos = await db.getAll();
    final todo = todos.firstWhere((e) => e.id == id);

    final updated = todo.copyWith(title: title, isSynced: false);
    await db.update(updated);

    try {
      await network.patch(
        Uri.parse('${TodoConstants.baseUrl}/$id'),
        body: jsonEncode({"title": title}),
      );
      await db.update(updated.copyWith(isSynced: true));
      return const Success(true);
    } catch (_) {
      return const Success(true);
    }
  }

  @override
  Future<Result<bool>> toggleTodo(int id, bool completed) async {
    final todos = await db.getAll();
    final todo = todos.firstWhere((e) => e.id == id);

    final updated = todo.copyWith(completed: completed, isSynced: false);

    await db.update(updated);

    try {
      await network.patch(
        Uri.parse('${TodoConstants.baseUrl}/$id'),
        body: jsonEncode({"completed": completed}),
      );
      await db.update(updated.copyWith(isSynced: true));
      return const Success(true);
    } catch (_) {
      return const Success(true);
    }
  }

  @override
  Future<Result<bool>> deleteTodo(int id) async {
    await db.delete(id);
    try {
      await network.delete(Uri.parse('${TodoConstants.baseUrl}/$id'));
      return const Success(true);
    } catch (_) {
      return const Success(true);
    }
  }
}
