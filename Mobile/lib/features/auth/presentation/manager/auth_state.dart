abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Map<String, dynamic> user;

  AuthSuccess({required this.user});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
