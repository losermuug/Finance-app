import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthRepository {
  AuthRepository._();

  static final instance = AuthRepository._();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  User? get currentUser => Firebase.apps.isEmpty ? null : _auth.currentUser;
  Stream<User?> authStateChanges() {
    if (Firebase.apps.isEmpty) return Stream.value(null);
    return _auth.authStateChanges();
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(name.trim());
    return credential;
  }

  Future<void> signOut() => _auth.signOut();
}
