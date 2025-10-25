// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/features/auth/repo/user_info_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  final String email;
  const UserInfoPage({super.key, required this.email});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final TextEditingController usernameController = TextEditingController();
  bool isValidate = true;
  final userInfoKey = GlobalKey<FormState>();
  String typeValue = 'Membre';
  List<String> userDepartement = [];
  List<String> departementValue = [
    "Developpement",
    "Security",
    "Communication",
    "Robotics",
  ];

  bool isSelected = false;
  void validateUsername() async {
    final usersMap = await FirebaseFirestore.instance.collection("users").get();

    final users = usersMap.docs.map((user) => user).toList();
    //
    String? targetdUsername;
    //
    for (var user in users) {
      if (usernameController.text == user.data()["username"]) {
        targetdUsername = user.data()["username"];
        isValidate = false;
        setState(() {});
      }
      if (usernameController.text != targetdUsername) {
        isValidate = true;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A8BFF),

      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: 0,
              left: 0,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/cscc_logo-removebg2.png',
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "CSCC",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Team",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            Positioned(
              top: 153,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 153,
                padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 26,
                          horizontal: 14,
                        ),
                        child: Text(
                          'Enter the username',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Form(
                          child: TextFormField(
                            onChanged: (username) {
                              validateUsername();
                            },
                            autovalidateMode: AutovalidateMode.always,
                            validator: (usremane) {
                              return isValidate
                                  ? null
                                  : "Username Already Taken";
                            },
                            key: userInfoKey,
                            controller: usernameController,
                            decoration: InputDecoration(
                              suffixIcon: isValidate
                                  ? const Icon(Icons.verified_user_outlined)
                                  : const Icon(Icons.cancel),
                              suffixIconColor: isValidate
                                  ? Colors.green
                                  : Colors.red,
                              hintText: 'insert user name',
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        value: typeValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: const [
                          DropdownMenuItem(
                            value: 'Membre',
                            child: Text('Membre'),
                          ),
                          DropdownMenuItem(
                            value: 'Membre de bureau',
                            child: Text('Membre de bureau'),
                          ),
                          DropdownMenuItem(
                            value: 'President',
                            child: Text('President'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            typeValue = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 500,
                          child: ListView.builder(
                            itemCount: departementValue.length,
                            itemBuilder: (context, index) {
                              final department = departementValue[index];
                              return Padding(
                                padding: EdgeInsetsGeometry.all(8),
                                child: ChoiceChip(
                                  label: Text(department),
                                  selected: userDepartement.contains(
                                    department,
                                  ),
                                  onSelected: (value) {
                                    setState(() {
                                      if (value) {
                                        userDepartement.add(department);
                                      } else {
                                        userDepartement.remove(department);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 30,
                          left: 8,
                          right: 8,
                        ),
                        child: FlatButton(
                          text: "CONTINUE",
                          onPressed: () async {
                            // add users data inside datebase
                            isValidate && userDepartement.isNotEmpty
                                ? await ref
                                      .read(userDataServiceProvider)
                                      .addUserDataToFirestore(
                                        type: typeValue,
                                        department: userDepartement,
                                        email: widget.email,
                                        username: usernameController.text,
                                        profilePic: "",
                                        description: "",
                                      )
                                : null;
                          },
                          colour: isValidate
                              ? Colors.green
                              : Colors.green.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//////
  //  Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 26, horizontal: 14),
  //                 child: Text(
  //                   'Enter the username',
  //                   style: TextStyle(color: Colors.blueGrey),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 15, right: 15),
  //                 child: Form(
  //                   child: TextFormField(
  //                     onChanged: (username) {
  //                       validateUsername();
  //                     },
  //                     autovalidateMode: AutovalidateMode.always,
  //                     validator: (usremane) {
  //                       return isValidate ? null : "Username Already Taken";
  //                     },
  //                     key: userInfoKey,
  //                     controller: usernameController,
  //                     decoration: InputDecoration(
  //                       suffixIcon: isValidate
  //                           ? const Icon(Icons.verified_user_outlined)
  //                           : const Icon(Icons.cancel),
  //                       suffixIconColor: isValidate ? Colors.green : Colors.red,
  //                       hintText: 'insert user name',
  //                       border: const OutlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.blue),
  //                       ),
  //                       enabledBorder: const OutlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.blue),
  //                       ),
  //                       focusedBorder: const OutlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.green),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               DropdownButton<String>(
  //                 value: typeValue,
  //                 icon: const Icon(Icons.arrow_drop_down),
  //                 items: const [
  //                   DropdownMenuItem(value: 'Membre', child: Text('Membre')),
  //                   DropdownMenuItem(
  //                     value: 'Membre de bureau',
  //                     child: Text('Membre de bureau'),
  //                   ),
  //                   DropdownMenuItem(
  //                     value: 'President',
  //                     child: Text('President'),
  //                   ),
  //                 ],
  //                 onChanged: (value) {
  //                   setState(() {
  //                     typeValue = value!;
  //                   });
  //                 },
  //               ),
  //               const SizedBox(height: 20),

  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: SizedBox(
  //                   height: 500,
  //                   child: ListView.builder(
  //                     itemCount: departementValue.length,
  //                     itemBuilder: (context, index) {
  //                       final department = departementValue[index];
  //                       return Padding(
  //                         padding: EdgeInsetsGeometry.all(8),
  //                         child: ChoiceChip(
  //                           label: Text(department),
  //                           selected: userDepartement.contains(department),
  //                           onSelected: (value) {
  //                             setState(() {
  //                               if (value) {
  //                                 userDepartement.add(department);
  //                               } else {
  //                                 userDepartement.remove(department);
  //                               }
  //                             });
  //                           },
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(bottom: 30, left: 8, right: 8),
  //                 child: FlatButton(
  //                   text: "CONTINUE",
  //                   onPressed: () async {
  //                     // add users data inside datebase
  //                     isValidate && userDepartement.isNotEmpty
  //                         ? await ref
  //                               .read(userDataServiceProvider)
  //                               .addUserDataToFirestore(
  //                                 type: typeValue,
  //                                 department: userDepartement,
  //                                 email: widget.email,
  //                                 username: usernameController.text,
  //                                 profilePic: "",
  //                                 description: "",
  //                               )
  //                         : null;
  //                   },
  //                   colour: isValidate ? Colors.green : Colors.green.shade100,
  //                 ),
  //               ),
  //             ],
            