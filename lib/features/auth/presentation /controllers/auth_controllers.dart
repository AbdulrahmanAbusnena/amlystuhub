import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState({required this.status, this.errorMessage});

  // Factory constructor to make changing the state easier (learned this from Fireship)
  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
  factory AuthState.authenticated() =>
      AuthState(status: AuthStatus.authenticated);
  factory AuthState.loading() => AuthState(status: AuthStatus.loading);
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
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

  Future<void> login(String email, String password) async {
    state = AuthState.loading();

    try {
      await _authService.signInWithEmail(
        email: email.trim(),
        password: password,
      );
      state = AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(_cleanErrorMessage(e.toString()));
    }
  }

  String _cleanErrorMessage(String rawError) {
    if (rawError.contains('Exception:')) {
      return rawError.replaceAll('Exception:', '').trim();
    }
    return rawError;
  }
}
