import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {
  const LoadTodos();
}

class AddTodos extends TodoEvent {
  final String title;

  const AddTodos(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateTodo extends TodoEvent {
  final String title;
  final int id;

  const UpdateTodo({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}

class DeleteTodo extends TodoEvent {
  final int id;

  const DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleTodo extends TodoEvent {
  final int id;
  final bool toggle;

  const ToggleTodo({required this.id, required this.toggle});

  @override
  List<Object?> get props => [id, toggle];
}

class SearchTodo extends TodoEvent {
  final String query;

  const SearchTodo(this.query);

  @override
  List<Object?> get props => [query];
}
