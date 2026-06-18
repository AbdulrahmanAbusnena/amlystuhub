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
      throw _cleanAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Custom Login
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return 'Please enter both email and password.';
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return _cleanAuthException(e);
    } catch (e) {
      return e.toString();
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
    UserCredential? credential;

    try {
      if (email.trim().isEmpty ||
          name.trim().isEmpty ||
          password.trim().isEmpty) {
        throw 'Please fill in all fields.';
      }

      if (!email.trim().toLowerCase().endsWith('@stu.amly.us')) {
        throw 'Access Denied: You must use your official @stu.amly.us school email.';
      }

      credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final newUser = UserModel(
        uid: credential.user!.uid,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        role: 'student',
        gradeLevel: gradeLevel,
        isApStudent: isApStudent,
        createdAt: DateTime.now(), // Placeholder value
      );

      await _firestore.collection('users').doc(newUser.uid).set({
        ...newUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      if (credential?.user != null) {
        await credential!.user!.delete();
      }

      throw _cleanAuthException(e);
    } catch (e) {
      if (credential?.user != null) {
        await credential!.user!.delete();
      }

      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _cleanAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No student record found for this email address.';
      case 'wrong-password':
        return 'Incorrect password. Double check and try again.';
      case 'email-already-in-use':
        return 'An account is already running under this school email.';
      case 'weak-password':
        return 'The chosen password security is too weak.';
      default:
        return e.message ?? 'Authentication operation failed.';
    }
  }
}
