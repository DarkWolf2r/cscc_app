// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:cscc_app/features/auth/login/login_page.dart';
import 'package:cscc_app/features/auth/user_info/user_info_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;

  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;
  Timer? resendTimer;

  // void initState() {
  //   super.initState();
  //   checkEmailVerification();
  //   // if (!isEmailVerified) {
  //   //   timer = Timer.periodic(
  //   //     Duration(seconds: 10),
  //   //     (_) => checkEmailVerification(),
  //   //   );
  //   // }
  // }

  ///
  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });

      resendTimer = Timer.periodic(
        Duration(seconds: 10),
        (_) => setState(() {
          canResendEmail = true;
        }),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email sent to ${widget.email}'),
          backgroundColor: Colors.green,
        ),
      );
      checkEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      setState(() {
        isEmailVerified = user?.emailVerified ?? false;
      });
      if (isEmailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email verified successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        timer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoPage(email: widget.email),
          ),
        );
      } else if (!isEmailVerified) {
        checkEmailVerification();
      }
      // Save verification state
      //    final prefs = await SharedPreferences.getInstance();
      //   await prefs.setBool('isEmailVerified', true);
      //  await prefs.setString('userEmail', user?.email ?? '');

      // Navigate to home screen
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (context) => const Homescreen()));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error : ${e.toString()} ")));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A8BFF),

      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: 0,
            left: 0,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/cscc_logo-removebg2.png',
                width: 400,
                height: 400,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "CSCC",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "Team",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: 250,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const SizedBox(height: 20),
                  Text(
                    "Email Verification",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF4A8BFF),
                      ),
                    ),
                  ),
                  Text(
                    "Check your email to verify your account !",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4A8BFF),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "You can send another verification email after 10seconds!",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4A8BFF),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canResendEmail
                          ? const Color(0xFF4A8BFF)
                          : Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: canResendEmail
                        ? () {
                            sendVerificationEmail();
                          }
                        : () {},
                    child: Text(
                      "Send Email Verification",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 5,
            child: IconButton(
              icon: Row(
                children: [
                  Icon(Icons.arrow_left, color: Color(0xFF4A8BFF)),
                  SizedBox(width: 2),
                  Text(
                    "Back to Sign Up",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Color(0xFF4A8BFF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
            ),
          ),
        ],
      ),

      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Center(
      //       child: Text(
      //         "Please verify your email address to continue.${widget.email}",
      //       ),
      //     ),
      //     SizedBox(height: 24),
      //     ElevatedButton(
      //       onPressed: () async {
      //         await ref.read(authServiceProvider).signOutUser();
      //       },
      //       child: Text("Back"),
      //     ),
      //     const SizedBox(height: 20),
      //     ElevatedButton(
      //       onPressed: () async {
      //         await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      //       },
      //       // canResendEmail ? sendVerificationEmail : null,
      //       child: Text("Resend Email"),
      //     ),
      //   ],
      // ),
    );
  }
}
