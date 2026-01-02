import 'package:todo_app/feature/todos/domain/entity/todo.dart';

class TodoDTO {
  int id;
  String title;
  int userId;
  bool completed;

  TodoDTO({
    required this.id,
    required this.title,
    required this.userId,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {"userId": userId, "id": id, "title": title, "completed": completed};
  }

  factory TodoDTO.toDTO(Map<String, dynamic> todo) {
    return TodoDTO(
      id: todo["id"],
      title: todo["title"],
      userId: todo["userId"] ?? 1,
      completed: todo["completed"],
    );
  }

  static List<TodoDTO> fromList(List<dynamic> list) {
    return list.map((e) => TodoDTO.toDTO(e as Map<String, dynamic>)).toList();
  }

  Todo toTodo() => Todo(id: id, title: title,completed: completed);
}
