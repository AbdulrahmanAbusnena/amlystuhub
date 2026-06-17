import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/services/auth_service.dart';

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

// instantiating our data service using riverpod
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// streaming the firebase user object to track sesssion changes

final authStreamProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// managing the manual registration and login state of the user

final authStateProvider = StateNotifierProvider<AuthController, AuthState>((
  ref,
) {
  final service = ref.watch(authServiceProvider);
  return AuthController(service);
});

// Controller Logic

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(AuthState.initial());
}
