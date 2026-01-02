abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthInputInvalid extends AuthState {
  final String? usernameError;
  final String? passwordError;
  AuthInputInvalid({this.usernameError, this.passwordError});
}
