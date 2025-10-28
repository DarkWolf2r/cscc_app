import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataServiceProvider = Provider(
  (ref) => UserDataService(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class UserDataService {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  UserDataService({required this.auth, required this.firestore});

   addUserDataToFirestore({
    required String username,
    required String email,
    String? profilePic,
    String? description,
    required List<String> department,
    required String type,
    required BuildContext context,
  }) async {
    UserModel user = UserModel(
      username: username,
      email: email,
      userId: auth.currentUser!.uid,
      description: description,
      type: type,
      departement: department,
      profilePic: profilePic,
    );

    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .set(user.toMap());
    Navigator.of(context).pop();
  }

  Future<UserModel> fetchCurrentUserData() async {
    final currentUserMap = await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get();

    UserModel user = UserModel.fromMap(currentUserMap.data()!);
    return user;
  }

  Future<UserModel> fetchAnytUserData(userId) async {
    final currentUserMap = await firestore
        .collection("users")
        .doc(userId)
        .get();

    UserModel user = UserModel.fromMap(currentUserMap.data()!);
    return user;
  }
}
