import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    String username = '';
    String password = '';

    on<AuthUsernameChanged>((event, emit) {
      username = event.username;
      _validateFields(username, password, emit);
    });

    on<AuthPasswordChanged>((event, emit) {
      password = event.password;
      _validateFields(username, password, emit);
    });

    on<AuthLogoutRequested>((event, emit) {
      emit(AuthInitial());
    });

    on<AuthLoginRequested>((event, emit) async {
      username = event.username;
      password = event.password;

      final validation = _validateFields(username, password, emit);
      if (!validation) return;

      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      if (username == "admin" && password == "Admin@123") {
        emit(AuthAuthenticated());
      } else {
        emit(AuthFailure("Invalid username or password"));
      }
    });
  }



  bool _validateFields(String username, String password, Emitter<AuthState> emit) {
    String? usernameError;
    String? passwordError;

    if (username.isEmpty) usernameError = "Username cannot be empty";
    if (password.isEmpty) passwordError = "Password cannot be empty";
    if (password.isNotEmpty && password.length < 6) passwordError = "Password must be at least 6 characters";

    if (usernameError != null || passwordError != null) {
      emit(AuthInputInvalid(usernameError: usernameError, passwordError: passwordError));
      return false;
    }
    return true;
  }
}
