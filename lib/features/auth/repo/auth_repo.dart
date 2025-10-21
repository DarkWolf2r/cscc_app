import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider((ref) =>
    AuthService(auth: FirebaseAuth.instance, googleSignIn:GoogleSignInAuthentication(idToken: idToken)));

class AuthService {
  FirebaseAuth auth;
  GoogleSignIn googleSignIn;
  AuthService({required this.auth, required this.googleSignIn});

  Future<UserCredential> signInWithGoogle() async {
    final googleProvider = GoogleAuthProvider();
    googleProvider.addScope('email');
    return await auth.signInWithProvider(googleProvider);
  }
}
