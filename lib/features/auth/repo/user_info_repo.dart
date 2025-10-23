import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataServiceProvider = Provider((ref) => UserDataService(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class UserDataService {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  UserDataService({required this.auth, required this.firestore});

  addUserDataToFirestore(
      {
      required String displayName ,  
      required String username,
      required String email,
      String? profilePic,
      String? description,
      required List<String> department,
      required String type
      }) async {
    UserModel user = UserModel(
       displayName: displayName,
        username: username,
        email: email,
        profilePic: profilePic ?? "",
        userId: auth.currentUser!.uid,
        description: description ?? "",
        type: type, 
        departement: department);
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .set(user.toMap());
  }

  Future<UserModel> fetchCurrentUserData() async {
    final currentUserMap =
        await firestore.collection("users").doc(auth.currentUser!.uid).get();

    UserModel user = UserModel.fromMap(currentUserMap.data()!);
    return user;
  }

  Future<UserModel> fetchAnytUserData(userId) async {
    final currentUserMap =
        await firestore.collection("users").doc(userId).get();

    UserModel user = UserModel.fromMap(currentUserMap.data()!);
    return user;
  }

}
