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

final currentUserModelProvider = StreamProvider<UserModel?>((ref) {
  // Read the current auth user value cleanly
  final authUserAsync = ref.watch(authStreamProvider);
  final user = authUserAsync.value;

  if (user == null) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          print(
            '⚠️ [Firestore] User document users/${user.uid} DOES NOT EXIST!',
          );
          return null;
        }
        print('✅ [Firestore] User model successfully parsed.');
        return UserModel.fromDocument(snapshot);
      });
});
