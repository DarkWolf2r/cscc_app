import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

 final authServiceProvider = Provider((ref) =>
     AuthService());

class AuthService {
final auth =  FirebaseAuth .instance;
final googleSignIn = GoogleAuthProvider(

);
  



  



 Future<UserCredential> signInWithGoogle() async {
   final googleProvider = GoogleAuthProvider();
   googleProvider.addScope('email');
   return await auth.signInWithProvider(googleProvider);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
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
//  signInWithGoogle() async {
//     final user = await googleSignIn.signIn();
//     final googleAuth = await user!.authentication;
//     final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

//     await auth.signInWithCredential(credential);
//   }

}
