import 'package:cscc_app/features/auth/login/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cscc_app/features/auth/sign_up/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with RouteAware {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;

  Future<void> _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text("Signed in successfully")));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Error signing in")));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleProvider = GoogleAuthProvider();
    googleProvider.addScope('email');
    return await _auth.signInWithProvider(googleProvider);
  }

  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     final googleProvider = GoogleAuthProvider();
  //     googleProvider.addScope('email');

  // final userCredential = await FirebaseAuth.instance.signInWithProvider(
  // googleProvider,
  // );

  //     if (userCredential.user != null) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder:
  //               (context) => HomePage(
  //                 onToggleTheme: () {
  //                   print("Theme toggled!");
  //                 },
  //               ),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint("Error signing in with Google: $e");
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Sign in failed: $e")));
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF5F9EA0),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned(
              top: 140,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Welcome to TaskFlow",
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
                          color: Color(0xFF5F9EA0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Color(0xFF5F9EA0),
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFF5F9EA0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Color(0xFF5F9EA0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Color(0xFF5F9EA0)),
                        ),
                        floatingLabelStyle: TextStyle(color: Color(0xFF5F9EA0)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      cursorColor: Color(0xFF5F9EA0),
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF5F9EA0),
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
                            color: Color(0xFF5F9EA0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Color(0xFF5F9EA0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Color(0xFF5F9EA0)),
                        ),
                        floatingLabelStyle: TextStyle(color: Color(0xFF5F9EA0)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      obscureText: _obscurePassword,
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
                                  color: Color(0xFF5F9EA0),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5F9EA0),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _signIn,
                      child: Text(
                        "Login",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
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
                            borderRadius: BorderRadius.circular(20),
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
                            // onPressed: () async {
                            //   try {
                            //     UserCredential user = await signInWithGoogle();
                            //     // ignore: avoid_print
                            //     print("User: ${user.user?.displayName}");
                            //   } catch (e) {
                            //     // ignore: avoid_print
                            //     print("Error: $e");
                            //   }
                            // },
                            onPressed: () async {
                              try {
                                UserCredential user = await signInWithGoogle();
                                // ignore: avoid_print
                                print("User: ${user.user?.displayName}");
                                Navigator.pushReplacementNamed(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  "/home",
                                );
                              } catch (e) {
                                // ignore: avoid_print
                                print("Error: $e");
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Google login failed: $e"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
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
                              try {
                                await signInWithGitHub();
                                Navigator.pushReplacementNamed(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  "/home",
                                );
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("GitHub login failed: $e"),
                                  ),
                                );
                              }
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
                                color: Color(0xFF5F9EA0),
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
            // Positioned(
            //   // top: 28,
            //   top: 58,
            //   right: 8,
            //   child: Image.asset(
            //     'assets/images/imgg2.png',
            //     width: 200,
            //     height: 200,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// extension on GoogleSignIn {
//   Future<GoogleSignInAccount?> signIn() {}
// }
