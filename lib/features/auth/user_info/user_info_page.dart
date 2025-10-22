// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/cores/widgets/flat_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// final formkey = GlobalKey<FormState>();

// class UserInfoPage extends ConsumerStatefulWidget {
//   final String displayName;
//   final String profilePic;
//   final String email;

//   const UserInfoPage({
//     super.key,
//     required this.displayName,
//     required this.profilePic,
//     required this.email,
//   });

//   @override
//   ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
// }

// class _UserInfoPageState extends ConsumerState<UserInfoPage> {
//   final TextEditingController usernameController = TextEditingController();
//   bool isValidate = true;
//   void validateUsername() async {
//     final usersMap = await FirebaseFirestore.instance.collection("users").get();

//     final users = usersMap.docs.map((user) => user).toList();
//     //
//     String? targetdUsername;
//     //
//     for (var user in users) {
//       if (usernameController.text == user.data()["username"]) {
//         targetdUsername = user.data()["username"];
//         isValidate = false;
//         setState(() {});
//       }
//       if (usernameController.text != targetdUsername) {
//         isValidate = true;
//         setState(() {});
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 26, horizontal: 14),
//                 child: Text(
//                   'Enter the username',
//                   style: TextStyle(color: Colors.blueGrey),
//                 )),
//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15),
//               child: Form(
//                 child: TextFormField(
//                   onChanged: (username) {
//                     validateUsername();
//                   },
//                   autovalidateMode: AutovalidateMode.always,
//                   validator: (usremane) {
//                     return  isValidate?  null : "Username Already Taken" ;
//                   },
//                   key: formkey,
//                   controller: usernameController,
//                   decoration: InputDecoration(
//                     suffixIcon: isValidate
//                         ? const Icon(Icons.verified_user_outlined)
//                         : const Icon(Icons.cancel),
//                     suffixIconColor: isValidate ? Colors.green : Colors.red,
//                     hintText: 'insert user name',
//                     border: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     focusedBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
//               child: FlatButton(
//                   text: 'CONTINUE',
//                   onPressed: () async {
//                     isValidate
//                         ? await ref
//                             .read(userDataServiceProvider)
//                             .addUserDataToFirestore(
//                                 displayName: widget.displayName,
//                                 username: usernameController.text,
//                                 email: widget.email,
//                                 profilePic: widget.profilePic,
//                                 description: "")
//                         : null;
//                   },
//                   colour: isValidate ? Colors.green : Colors.green.shade100),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
