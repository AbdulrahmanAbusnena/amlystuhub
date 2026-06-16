import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // stream to listen to authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // get the current user
  User? get currentUser => _auth.currentUser;
}
