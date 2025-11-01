import 'package:cscc_app/features/auth/pages/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(auth: FirebaseAuth.instance),
);
final githubLinkProvider = StateProvider<String?>((ref) => null);

class AuthService {
  FirebaseAuth auth;

  AuthService({required this.auth});
  Future<UserCredential?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    try {
      await googleSignIn.initialize(
        serverClientId:
            "102890835302-5dh3es8d578obpnb7eie3ckjoaeiu3af.apps.googleusercontent.com",
      );
      final user = await googleSignIn.authenticate();
      final authUser = user.authentication;
      final cred = GoogleAuthProvider.credential(idToken: authUser.idToken);
      return await auth.signInWithCredential(cred);
    } catch (e) {}
    return null;
  }

  Future<Map<String, String?>> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Sign in failed")));
    }
    Navigator.of(context).pop();
    return {'email': email, 'github': null};
  }

  Future<void> signInWithGitHub(BuildContext context, WidgetRef ref) async {
    try {
      final githubProvider = GithubAuthProvider()
        ..addScope('read:user')
        ..addScope('user:email');

      final credential = await FirebaseAuth.instance.signInWithProvider(
        githubProvider,
      );
      final username = credential.additionalUserInfo?.username;
      final githubLink = username != null
          ? 'https://github.com/$username'
          : null;

      // Store GitHub link in the provider
      ref.read(githubLinkProvider.notifier).state = githubLink;
    } catch (e) {
      throw Exception("GitHub sign in failed: $e");
    }
  }

  Future<void> signOutUser() async {
    try {
      await auth.signOut();
    } catch (e) {
      debugPrint("Error when sign out");
    }
  }

  Future<void> sendEmailToVerify(
    BuildContext context,
    String email,
    String password,
  ) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      // Create user account
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      Navigator.of(context).pop();
      // Navigate to verification page
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmailPage(email: email),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Sign up failed")));
      }
    }
  }
}
