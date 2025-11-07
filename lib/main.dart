import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/dark_theme/theme_page.dart';
import 'package:cscc_app/cores/dark_theme/theme_provider.dart';
import 'package:cscc_app/features/auth/pages/login_page.dart';
import 'package:cscc_app/features/auth/pages/user_info_page.dart';
import 'package:cscc_app/features/auth/pages/verify_email_page.dart';
import 'package:cscc_app/features/auth/repo/auth_repo.dart';
import 'package:cscc_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: lightTheme,
      // darkTheme: darkTheme,
      theme: lightTheme.copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          surface: Colors.white,
          inverseSurface: Colors.black,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
      ),
      darkTheme: darkTheme.copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          surface: const Color.fromRGBO(24, 27, 46, 1),
          inverseSurface: Colors.white,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
      ),
      themeMode: appThemeState.themeMode,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return SignInPage();
          } else if (!(snapshot.data!.emailVerified) &&
              !(snapshot.data!.providerData.any(
                (p) =>
                    p.providerId == 'github.com' ||
                    p.providerId == 'google.com',
              ))) {
            return VerifyEmailPage(email: snapshot.data!.email!);
          } else {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final githubLink = ref.watch(githubLinkProvider);

                final user = FirebaseAuth.instance.currentUser;
                if (!(snapshot.hasData && snapshot.data!.exists)) {
                  return UserInfoPage(user?.email, githubLink);
                }
                return HomePage();
              },
 
 
            );
          }
        },
      ),
    );
  }
}
