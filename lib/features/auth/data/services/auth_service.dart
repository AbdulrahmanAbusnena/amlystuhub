import 'package:amlystuhub/features/auth/domain/models /user_model.dart';
import 'package:amlystuhub/features/auth/domain/models /user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Storing data in firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
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

      // Instantiating with type-safe UserRole enum instead of a raw String
      final newUser = UserModel(
        uid: credential.user!.uid,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        role: UserRole.student, // Type-safe initialization
        gradeLevel: gradeLevel,
        isApStudent: isApStudent,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Serialize using the updated model map which utilizes role.toSystemString()
      await _firestore.collection('users').doc(newUser.uid).set({
        ...newUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
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

  // Stream a student's full profile data from firestore in real time

  Stream<UserModel?> getUserDocStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return UserModel.fromDocument(snapshot);
    });
  }
}
