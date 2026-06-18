import 'package:amlystuhub/features/auth/domain/models%20/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // storing data in firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // stream to listen to authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // get the current user
  User? get currentUser => _auth.currentUser;

  // sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      // Rethrow the error so your controller can catch it and show it to the student
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign Up Method
  Future<UserCredential?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required int gradeLevel,
    required bool isApStudent,
  }) async {
    try {
      if (email.trim().isEmpty ||
          name.trim().isEmpty ||
          password.trim().isEmpty) {
        throw 'Please fill in all fields.';
      }
      if (!email.trim().toLowerCase().endsWith('@stu.amly.us')) {
        throw 'Access Denied: You must use your official @stu.amly.us school email.';
      }
      UserCredential? credential;
      try {
        credential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        if (credential.user != null) {
          final newUser = UserModel(
            uid: credential.user!.uid,
            name: name.trim(),
            email: email.trim().toLowerCase(),
            role: 'student', // Default account registration tier
            gradeLevel: gradeLevel,
            isApStudent: isApStudent,
            createdAt: DateTime.now(),
          );
          await _firestore.collection('users').doc(newUser.uid).set({
            ...newUser.toMap(),
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        throw 'Success';
      } on FirebaseAuthException catch (e) {
        throw _handleAuthException(e);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ignore: strict_top_level_inference
  _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is poorly formatted.';
      case 'weak-password':
        return 'The password is too weak. Use a stronger password.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
