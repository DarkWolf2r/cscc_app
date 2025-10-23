import 'package:cscc_app/features/auth/user_info/user_info_page.dart';
import 'package:cscc_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:cscc_app/features/auth/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home:SignInPage(),
      theme: ThemeData.dark(),
      // StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (!snapshot.hasData) {
      //       return SignInPage();
      //     }
      //     return StreamBuilder(
      //       stream: FirebaseFirestore.instance
      //           .collection("users")
      //           .doc(FirebaseAuth.instance.currentUser!.uid)
      //           .snapshots(),
      //       builder: (context, snapshot) {
      //         final user = FirebaseAuth.instance.currentUser;

      //         if (!snapshot.hasData || !snapshot.data!.exists) {
      //           return UserInfoPage(
      //               displayName: user!.displayName!,
      //               profilePic: user.photoURL!,
      //               email: user.email!);
      //         } 
      //         else {
      //           return HomePage();
      //         }
      //       },
      //     );
      //   },
      // ),
    );
  }
}

