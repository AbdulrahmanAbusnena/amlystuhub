enum AuthStatus { initial, authenticated, unauthenticated, unknown }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState({required this.status, this.errorMessage});

  // Factory constructor to make changing the state easier (learned this from Fireship)
  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
  factory AuthState.authenticated() =>
      AuthState(status: AuthStatus.authenticated);
  factory AuthState.unauthenticated() =>
      AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.unknown() => AuthState(status: AuthStatus.unknown);
}
