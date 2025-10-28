// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/features/auth/model/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final userDataServiceProvider = Provider(
//   (ref) => UserDataService(
//     auth: FirebaseAuth.instance,
//     firestore: FirebaseFirestore.instance,
//   ),
// );

// class UserDataService {
//   FirebaseAuth auth;
//   FirebaseFirestore firestore;
//   UserDataService({required this.auth, required this.firestore});

//   Future<void> addUserDataToFirestore({
//     required String username,
//     required String email,
//     String? profilePic,
//     String? description,
//     required List<String> department,
//     required String type,
//   }) async {
//     final String userId = auth.currentUser?.uid ?? 'test_uid';

//     UserModel user = UserModel(
//       username: username,
//       email: email,
//       userId: userId,
//       description: description ?? "",
//       type: type,
//       departement: department,
//       profilePic: profilePic ?? "",
//     );

//     await firestore.collection("users").doc(userId).set(user.toMap());
//   }
//   Future<UserModel> fetchCurrentUserData() async {
//     final String userId = auth.currentUser?.uid ?? 'test_uid';
//     final doc = await firestore.collection("users").doc(userId).get();

//     if (!doc.exists) {
//       UserModel testUser = UserModel(
//         username: "Test User",
//         email: "test@example.com",
//         userId: userId,
//         description: "Just a test user",
//         type: "tester",
//         departement: ["AI", "Mobile"],
//         profilePic:
//             "https://cdn-icons-png.flaticon.com/512/149/149071.png",
//       );
//       await firestore.collection("users").doc(userId).set(testUser.toMap());
//       return testUser;
//     }

//     return UserModel.fromMap(doc.data()!);
//   }

//   Future<UserModel> fetchAnytUserData(String userId) async {
//     final doc = await firestore.collection("users").doc(userId).get();

//     if (!doc.exists) {
//       throw Exception("User not found");
//     }

//     return UserModel.fromMap(doc.data()!);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  }) async {
    UserModel user = UserModel(
      username: username,
      email: email,
      userId: auth.currentUser!.uid,
      description: description,
      type: type,
      departement: department,
      profilePic: profilePic ,
    );
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .set(user.toMap());
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
