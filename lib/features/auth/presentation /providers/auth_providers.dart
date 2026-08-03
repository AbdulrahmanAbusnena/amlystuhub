import 'package:amlystuhub/features/auth/domain/models%20/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

final currentUserProvider = StreamProvider<UserModel?>((ref) {
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

  return authService.getUserDocStream(firebaseUser.uid);
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// 2. Fetches the active UserModel directly from Firestore whenever Auth state changes
final currentUserModelProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value(null);
      }
      // Listen to the Firestore document for real-time user updates
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((snapshot) {
            if (!snapshot.exists || snapshot.data() == null) {
              return null;
            }
            return UserModel.fromDocument(snapshot);
          });
    },
    loading: () => const Stream.empty(),
    error: (_, __) => Stream.value(null),
  );
});
