import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthTest(),
    );
  }
}

class AuthTest extends StatefulWidget {
  const AuthTest({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthTestState createState() => _AuthTestState();
}

class _AuthTestState extends State<AuthTest> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _registerUser();
  }

  void _registerUser() async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: "test@example.com", password: "123456");
      // ignore: avoid_print
      print("User registered: ${user.user?.uid}");
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  void addTestData() async {
    await FirebaseFirestore.instance.collection('test').add({
      'name': 'Orla',
      'timestamp': FieldValue.serverTimestamp(),
    });
    // ignore: avoid_print
    print("Data added!");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(child: Text("Check console for result")),
      body: Center(
        child: ElevatedButton(
          onPressed: addTestData,
          child: Text('Send to Firestore'),
        ),
      ),

    );
  }
}