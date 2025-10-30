import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/dark_theme/theme_page.dart';
import 'package:cscc_app/cores/dark_theme/theme_provider.dart';
import 'package:cscc_app/features/auth/pages/login_page.dart';
import 'package:cscc_app/features/auth/pages/user_info_page.dart';
import 'package:cscc_app/features/auth/pages/verify_email_page.dart';
import 'package:cscc_app/features/departement/departement_page.dart';
import 'package:cscc_app/features/profile/profile_page.dart';
import 'package:cscc_app/features/profile/setting_page.dart';

// import 'package:cscc_app/features/departement/departement_page.dart';
// import 'package:cscc_app/features/profile/profile_page.dart';
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

      // theme: lightTheme,
      // darkTheme: darkTheme,
      theme: lightTheme.copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      darkTheme: darkTheme.copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      themeMode: appThemeState.themeMode,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return SignInPage();
          } else if (!(snapshot.data!.emailVerified)) {
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
                final user = FirebaseAuth.instance.currentUser;
                if (!(snapshot.hasData && snapshot.data!.exists)) {
                  return UserInfoPage(email: user!.email!);
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
