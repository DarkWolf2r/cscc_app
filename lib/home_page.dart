import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/features/auth/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('HOME PAGE')),
      body: Center(
        child: FlatButton(
          text: "SIGN OUT",
          onPressed: () {
            ref.read(authServiceProvider).signOutUser();
          },
          colour: Colors.black,
        ),
      ),
    );
  }
}
