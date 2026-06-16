import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
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

  _handleAuthException(FirebaseAuthException e) {}
}
