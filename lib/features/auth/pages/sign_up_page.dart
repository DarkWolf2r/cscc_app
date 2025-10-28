import 'package:cscc_app/features/auth/repo/auth_repo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;

  final signUpKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF4A8BFF),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 0.75,

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
                      "Computer Science Community Club",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 12,
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
                  height: MediaQuery.of(context).size.height / 0.8,
                  padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: signUpKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          Text(
                            "Sign Up",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF4A8BFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          TextFormField(
                            // key: key,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Color(0xFF4A8BFF),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            validator: (value) {
                              value != null && !EmailValidator.validate(value)
                                  ? 'Enter a valid email'
                                  : null;
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "Enter your email",
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color(0xFF4A8BFF),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A8BFF),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A8BFF),
                                ),
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Color(0xFF4A8BFF),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            // key: key,
                            controller: _passwordController,
                            validator: (password) =>
                                password != null && password.length < 6
                                ? 'Enter a password with at least 6 characters'
                                : null,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: Color(0xFF4A8BFF),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter your password",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF4A8BFF),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color(0xFF4A8BFF),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A8BFF),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A8BFF),
                                ),
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Color(0xFF4A8BFF),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            obscureText: _obscurePassword,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: Color(0xFF4A8BFF),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            validator: (confirmPassword) {
                              if (confirmPassword != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              hintText: "Confirm your password",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF4A8BFF),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A8BFF),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A8BFF),
                                ),
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Color(0xFF4A8BFF),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            obscureText: _obscureConfirmPassword,
                          ),
                          const SizedBox(height: 40),
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

                            onPressed:
                                (signUpKey.currentState?.validate() ?? false)
                                ? () async {
                                    await ref
                                        .read(authServiceProvider)
                                        .sendEmailToVerify(
                                          context,
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );
                                  }
                                : () {},

                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "Or login with",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey)),
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
                                  onPressed: () async {
                                    await ref
                                        .read(authServiceProvider)
                                        .signInWithGitHub(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
