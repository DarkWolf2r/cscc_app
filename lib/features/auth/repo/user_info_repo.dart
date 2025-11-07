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

  Future<void> addUserDataToFirestore({
    required String username,
    String? email,
    String? github,
    String? profilePic,
    String? description,
    int followers = 0,
    List<String>? following   ,
    required List<String> department,
    required String type,
    required BuildContext context,
  }) async {
    UserModel user = UserModel(
      followers: followers,
      username: username,
      following: following,
      email: email,
      github: github,
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

    try {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .set(user.toMap());
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed : ${e.toString()}")));
    }
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
