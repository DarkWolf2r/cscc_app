import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cscc_app/features/auth/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

// class _AuthTestState extends State<AuthTest> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // body: Center(child: Text("Check console for result")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: addTestData,
//           child: Text('Send to Firestore'),
//         ),
//       ),

//     );
//   }
// }
