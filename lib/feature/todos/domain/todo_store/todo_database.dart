import '../entity/todo.dart';

abstract class TodoDatabase {

  Future<void> insert(Todo todo);

  Future<List<Todo>> getAll();

  Future<void> update(Todo todo);

  Future<void> delete(int id);

  Future<List<Todo>> unsynced();

}