import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/services/auth_service.dart';
import '../controllers/auth_controllers.dart';

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

final currentuserModelProvider = StreamProvider<UserModel?>((ref) {
  // listening to the current state of the user session
  final authState = ref.watch(authStreamProvider);
  // listening to the backend to get the cureent stte
  final authService = ref.watch(authServiceProvider);
  // extractung value out of the AsyncValue
  final firebaseUser = authState.value;

  // If logged out, stop and return to an emtpy stream

  if (firebaseUser == null) {
    return Stream.value(null);
  }
  // TODO: adding the logic to fetch the user document from Firestore based on the logged-in user's UID
  // return authService.getUserDocStream(firebaseUser.uid);
});
