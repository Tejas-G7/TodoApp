abstract class AuthEvent {}

class AuthUsernameChanged extends AuthEvent {
  final String username;

  AuthUsernameChanged(this.username);
}

class AuthPasswordChanged extends AuthEvent {
  final String password;

  AuthPasswordChanged(this.password);
}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  AuthLoginRequested({required this.username, required this.password});
}

class AuthLogoutRequested extends AuthEvent {}
