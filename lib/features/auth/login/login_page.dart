import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/cores/widgets/my_text_field.dart';
import 'package:cscc_app/features/auth/login/forget_password.dart';
import 'package:cscc_app/features/auth/repo/auth_repo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cscc_app/features/auth/sign_up/sign_up_page.dart';

// ignore: must_be_immutable
class SignInPage extends ConsumerWidget {
  SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;
    bool obscurePassword = true;
    @override
    final key = GlobalKey<FormState>();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF4A8BFF),
      body: Stack(
        children: [
          Positioned(
            // top: 28,
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
            top: 130,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "HELLO",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "Welcome to CSCC",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 230,
            child: Form(
              key: key,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.fromLTRB(24, 35, 24, 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Sign In",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4A8BFF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    MyTextField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                      prefixIcon: Icons.email,
                      labelText: "Email",
                      contoller: emailController,
                      hintText: "Enter your email",
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Password is required';
                        }
                        if (password.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          obscurePassword = !obscurePassword;
                        },
                      ),
                      prefixIcon: Icons.lock,
                      labelText: "Password",
                      contoller: passwordController,
                      hintText: "Password",
                      obscureText: obscurePassword,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // GestureDetector(
                        //   onTap: _forgotPassword,
                        //   TextButton(
                        //     onPressed: _forgotPassword,
                        //     child: Text(
                        //       "Forgot Password ?   ",
                        //       style: GoogleFonts.lato(
                        //         textStyle: TextStyle(
                        //           color: Color(0xFF5F9EA0),
                        //           fontWeight: FontWeight.w900,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgetPassword(),
                              ),
                            ),
                            child: Text(
                              "Forgot Password ?   ",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: Color(0xFF4A8BFF),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    //
                    FlatButton(
                      text: "login",
                      onPressed: () async {
                        await ref
                            .read(authServiceProvider)
                            .signInWithEmailAndPassword(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                      },
                      colour: const Color(0xFF4A8BFF),
                    ),

                    //
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or login with",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Image.asset(
                              'assets/icons8-google.png',
                              width: 35,
                              height: 35,
                            ),

                            onPressed: () async {
                              await ref
                                  .read(authServiceProvider)
                                  .signInWithGoogle();
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Image.asset(
                              'assets/github.png',
                              width: 35,
                              height: 35,
                            ),
                            onPressed: () {
                              ref.read(authServiceProvider).signInWithGitHub();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account ? ",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Color(0xFF4A8BFF),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
