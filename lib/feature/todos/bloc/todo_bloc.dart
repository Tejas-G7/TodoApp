import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/network/network_response.dart' as result;
import '../domain/entity/todo.dart';
import '../domain/repository/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TaskBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  final List<Todo> _allTodos = [];

  TaskBloc(this.repository) : super(TodoLoading()) {
    on<LoadTodos>(_onLoad);
    on<AddTodos>(_onAdd);
    on<UpdateTodo>(_onUpdate);
    on<ToggleTodo>(_onToggle);
    on<DeleteTodo>(_onDelete);
    on<SearchTodo>(_onSearch);
  }

  void _emitLoaded(Emitter<TodoState> emit, {String? error}) {
    emit(TodoLoaded(List.unmodifiable(_allTodos), error: error));
  }

  Future<void> _onLoad(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final response = await repository.getTodos();

    if (response is result.Success<List<Todo>>) {
      _allTodos
        ..clear()
        ..addAll(response.data);
      _emitLoaded(emit);
    } else if (response is result.Failure<List<Todo>>) {
      _emitLoaded(emit, error: response.error);
    }
  }

  Future<void> _onAdd(AddTodos event, Emitter<TodoState> emit) async {
    final id = const Uuid().v4().hashCode;
    final todo = Todo(id: id, title: event.title, completed: false);

    _allTodos.insert(0, todo);
    _emitLoaded(emit);

    final response = await repository.addTodo(id, event.title);

    if (response is result.Failure<bool>) {
      _allTodos.removeWhere((t) => t.id == id);
      _emitLoaded(emit, error: response.error);
    }
  }


  Future<void> _onUpdate(UpdateTodo event, Emitter<TodoState> emit) async {
    final index = _allTodos.indexWhere((t) => t.id == event.id);
    if (index == -1) return;

    final oldTodo = _allTodos[index];
    final updatedTodo = oldTodo.copyWith(title: event.title);

    _allTodos[index] = updatedTodo;
    _emitLoaded(emit);

    final response = await repository.updateTodo(event.id, event.title);

    if (response is result.Failure<bool>) {
      _allTodos[index] = oldTodo;
      _emitLoaded(emit, error: response.error);
    }
  }

  Future<void> _onToggle(ToggleTodo event, Emitter<TodoState> emit) async {
    final index = _allTodos.indexWhere((t) => t.id == event.id);
    if (index == -1) return;

    final oldTodo = _allTodos[index];
    final toggledTodo = oldTodo.copyWith(completed: event.toggle);

    _allTodos[index] = toggledTodo;
    _emitLoaded(emit);

    final response = await repository.toggleTodo(event.id, event.toggle);

    if (response is result.Failure<bool>) {
      _allTodos[index] = oldTodo;
      _emitLoaded(emit, error: response.error);
    }
  }

  Future<void> _onDelete(DeleteTodo event, Emitter<TodoState> emit) async {
    final index = _allTodos.indexWhere((t) => t.id == event.id);
    if (index == -1) return;

    final removedTodo = _allTodos.removeAt(index);
    _emitLoaded(emit);

    final response = await repository.deleteTodo(event.id);

    if (response is result.Failure<bool>) {
      _allTodos.insert(index, removedTodo);
      _emitLoaded(emit, error: response.error);
    }
  }

  void _onSearch(SearchTodo event, Emitter<TodoState> emit) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      _emitLoaded(emit);
      return;
    }

    final sorted = List<Todo>.from(_allTodos)
      ..sort((a, b) {
        final aMatch = a.title.toLowerCase().contains(query);
        final bMatch = b.title.toLowerCase().contains(query);
        if (aMatch && !bMatch) return -1;
        if (!aMatch && bMatch) return 1;
        return 0;
      });

    emit(TodoLoaded(sorted));
  }
}
