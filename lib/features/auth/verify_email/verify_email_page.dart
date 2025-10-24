// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cscc_app/features/auth/sign_up/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/features/auth/repo/auth_repo.dart';
import 'package:cscc_app/home_page.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  final FirebaseAuth auth;
  final User? user;
  final String email;
  final String password;
  const VerifyEmailPage({
    super.key,
    required this.auth,
    this.user,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified = widget.auth.currentUser!.emailVerified;
    if (!isEmailVerified) {
      ref.read(authServiceProvider).sendEmailToVerify(context, widget.email, widget.password);
        timer = Timer.periodic(Duration(seconds: 5), (_) => checkEmailVerified());

    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await widget.auth.currentUser!.reload();
    setState(() {
      isEmailVerified = widget.auth.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isEmailVerified ? Center(child: Text("data"),)
            //  FlatButton(
            //     text: "Continue",
            //     onPressed: () {
            //       ref
            //           .read(authServiceProvider)
            //           .signUp2(widget.email, widget.password);
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => HomePage()),
            //       );
            //     },
            //     colour: Colors.blueAccent,
            //   )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("A verification email has been sent to your email."),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      ref
                          .read(authServiceProvider)
                          .sendEmailToVerify(
                            context,
                            widget.email,
                            widget.password,
                          );

                      setState(() {
                        canResendEmail = false;
                      });
                      await Future.delayed(Duration(seconds: 30));
                      setState(() {
                        canResendEmail = true;
                      });
                    },
                    // canResendEmail ? sendVerificationEmail : null,
                    child: Text("Resend Email"),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      await widget.auth.signOut();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
      ),
    );
  }
}
// ...existing code...
// import 'dart:async';
// import 'package:cscc_app/cores/widgets/flat_button.dart';
// import 'package:cscc_app/features/auth/repo/auth_repo.dart';
// import 'package:cscc_app/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class VerifyEmailPage extends ConsumerStatefulWidget {
//   final FirebaseAuth auth;
//   final User? user;
//   final String email;
//   final String password;

//   const VerifyEmailPage({
//     super.key,
//     required this.auth,
//     required this.user,
//     required this.email,
//     required this.password,
//   });

//   @override
//   ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
// }

// class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
//   bool isEmailVerified = false;
//   bool canResendEmail = false;
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     isEmailVerified =
//         widget.user?.emailVerified ??
//         widget.auth.currentUser?.emailVerified ??
//         false;

//     if (!isEmailVerified &&
//         (widget.user != null || widget.auth.currentUser != null)) {
//       sendVerificationEmail();
//       timer = Timer.periodic(
//         const Duration(seconds: 5),
//         (_) => checkEmailVerified(),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   Future<void> checkEmailVerified() async {
//     final current = widget.auth.currentUser;
//     if (current == null) return;
//     await current.reload();
//     setState(() {
//       isEmailVerified = widget.auth.currentUser?.emailVerified ?? false;
//     });
//     if (isEmailVerified) timer?.cancel();
//   }

//   Future<void> sendVerificationEmail() async {
//     try {
//       final user = widget.user ?? widget.auth.currentUser;
//       if (user == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("No user available")));
//         return;
//       }
//       await user.sendEmailVerification();
//       setState(() => canResendEmail = false);
//       await Future.delayed(const Duration(seconds: 30));
//       setState(() => canResendEmail = true);
//     } catch (_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Error sending verification email")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: isEmailVerified
//             ? FlatButton(
//                 text: "Continue",
//                 onPressed: () {
//                   ref
//                       .read(authServiceProvider)
//                       .signUp2(widget.email, widget.password);
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => HomePage()));
//                 },
//                 colour: Colors.blueAccent,
//               )
//             // ? const Text("Email verified! You can now access the app.")
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "A verification email has been sent to your email.",
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: canResendEmail ? sendVerificationEmail : null,
//                     child: const Text("Resend Email"),
//                   ),
//                   const SizedBox(height: 8),
//                   TextButton(
//                     onPressed: () async {
//                       await widget.auth.signOut();
//                       Navigator.of(context).popUntil((route) => route.isFirst);
//                     },
//                     child: const Text("Cancel"),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
