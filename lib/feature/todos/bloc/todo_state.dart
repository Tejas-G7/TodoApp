import 'package:equatable/equatable.dart';

import '../domain/entity/todo.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final String? error;

  TodoLoaded(this.todos, {this.error});

  @override
  List<Object?> get props => [todos, error];
}

class TodoError extends TodoState {
  final String message;

  TodoError(this.message);

  @override
  List<Object?> get props => [message];
}

class TodoActionSuccess extends TodoState {
  final String message;

  TodoActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
