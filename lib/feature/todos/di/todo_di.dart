import 'package:get_it/get_it.dart';
import 'package:todo_app/core/network/todo_network.dart';
import 'package:todo_app/feature/auth/bloc/auth_bloc.dart';
import 'package:todo_app/feature/todos/bloc/todo_bloc.dart';
import 'package:todo_app/feature/todos/data/repository/todo_repository_impl.dart';
import 'package:todo_app/feature/todos/data/todo_store/todo_database_impl.dart';
import 'package:todo_app/feature/todos/domain/repository/todo_repository.dart';
import 'package:todo_app/feature/todos/domain/todo_store/todo_database.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton(() => TodoNetwork());
  sl.registerLazySingleton<TodoDatabase>(() => TodoDatabaseImpl.instance);
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl(),sl()));
  sl.registerFactory(() => TaskBloc(sl()));
  sl.registerFactory(() => AuthBloc());
}
