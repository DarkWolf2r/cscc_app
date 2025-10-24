import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _email = TextEditingController();

  Future<void> _forgotPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email first")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset link sent! Check your email."),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error sending reset email")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF4A8BFF),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
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
              top: 153,
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      // Positioned(
                      //   // top: 600,
                      //   right: 0,
                      //   child: Image.asset(
                      //     'assets/images/imgg17.png',
                      //     width: 220,
                      //     height: 130,
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      Text(
                        "Forget Password",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4A8BFF),
                          ),
                        ),
                      ),
                      Text(
                        "Enter your email to reset your password",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4A8BFF),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Color(0xFF4A8BFF),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color(0xFF4A8BFF),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF4A8BFF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF4A8BFF)),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFF4A8BFF),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A8BFF),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _forgotPassword,
                        child: Text(
                          "Send Email",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: 5,
              child: IconButton(
                icon: Row(
                  children: [
                    Icon(Icons.arrow_left, color: Color(0xFF4A8BFF)),
                    SizedBox(width: 2),
                    Text(
                      "Back to Login",
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
                  Navigator.pop(context);
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
