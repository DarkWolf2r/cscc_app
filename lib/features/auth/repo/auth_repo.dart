import 'package:cscc_app/features/auth/login/login_page.dart';
import 'package:cscc_app/features/auth/user_info/user_info_page.dart';
import 'package:cscc_app/features/auth/verify_email/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(
    auth: FirebaseAuth.instance,
    googleProvider: GoogleAuthProvider(),
  ),
);

class AuthService {
  FirebaseAuth auth;
  GoogleAuthProvider googleProvider;

  AuthService({required this.auth, required this.googleProvider});

  Future<UserCredential> signInWithGoogle() async {
    googleProvider.addScope('email');
    return await auth.signInWithProvider(googleProvider);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      SnackBar(content: Text(e.message ?? "Unknown error"));
    }
  }

  Future<UserCredential> signInWithGitHub() async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();

      githubProvider.addScope('read:user');
      githubProvider.addScope('user:email');

      return await FirebaseAuth.instance.signInWithProvider(githubProvider);
    } catch (e) {
      throw Exception("GitHub sign in failed: $e");
    }
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

 Future<UserCredential?> sendEmailToVerify(
  BuildContext context,
  String email,
  String password,
) async {
  try {
    // Create user account
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // Navigate to verification page
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyEmailPage(      
           email: email,
          ),
        ),
      );
    }

  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Sign up failed")),
      );
    }
    return null;
  }
} }

  Future<void> signUp2(String email, String password) async {}

