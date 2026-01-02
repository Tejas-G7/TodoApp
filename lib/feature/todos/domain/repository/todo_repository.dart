import 'package:todo_app/core/network/network_response.dart' as result;
import 'package:todo_app/feature/todos/domain/entity/todo.dart';

abstract class TodoRepository {
  Future<result.Result<List<Todo>>> getTodos();

  Future<result.Result<bool>> addTodo(int id, String title);

  Future<result.Result<bool>> deleteTodo(int id);

  Future<result.Result<bool>> updateTodo(int id, String title);

  Future<result.Result<bool>> toggleTodo(int id, bool isComplete);
}
