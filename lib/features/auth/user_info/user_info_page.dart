// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/method.dart';

import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/features/auth/repo/user_info_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  final String email;
  const UserInfoPage({super.key, required this.email});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final TextEditingController usernameController = TextEditingController();
  bool isValidate = false;
  Image picture = Image.asset('assets/profile.png');
  final userInfoKey = GlobalKey<FormState>();
  String typeValue = 'Membre';
  String bureauType = 'Membre de Bureau';
  List<String> userDepartement = [];
  List<String> departementValue = [
    "Developpement",
    "Security",
    "Communication",
    "Robotics",
  ];
  List<String> membreDeBureauList = [
    "Chef Developement",
    "Chef Security",
    "Chef Robotic",
    "Chef Communication",
  ];
  bool isPressed = false;
  String randomNumber = const Uuid().v4();
  TextEditingController? descriptionController = TextEditingController();

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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF4A8BFF),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 0.85,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
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
                top: 200,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "User Informations",

                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4A8BFF),
                          ),
                        ),
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     vertical: 20,
                      //     horizontal: 0,
                      //   ),
                      //   child: Text(
                      //     'Enter the username',
                      //     style: TextStyle(
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.w900,
                      //       color: Color(0xFF4A8BFF),
                      //     ),
                      //   ),
                      // ),
                      Form(
                        child: TextFormField(
                          onChanged: (username) {
                            validateUsername();
                          },
                          autovalidateMode: AutovalidateMode.always,
                          validator: (usremane) {
                            return isValidate ? null : "Username Already Taken";
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
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Select you Type : ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A8BFF),
                            ),
                          ),
                          const SizedBox(width: 20),
                          DropdownButton<String>(
                            dropdownColor: Colors.white,
                            style: TextStyle(color: Colors.black),
                            iconEnabledColor: Colors.black,
                            value: typeValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: <DropdownMenuItem<String>>[
                              DropdownMenuItem(
                                value: 'Membre',
                                child: Text('Membre'),
                              ),
                              DropdownMenuItem(
                                value: 'Membre du bureau',
                                child: Text('Membre du bureau'),
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Add Your deparetement : ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4A8BFF),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: departementValue.length,

                          itemBuilder: (context, index) {
                            final department = departementValue[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                selectedColor: Colors.greenAccent,
                                label: Text(department),
                                selected: userDepartement.contains(department),
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
                      const SizedBox(height: 10),
                      Text(
                        'Description : ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4A8BFF),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          // labelText: "Description",
                          hintText: "What are your interests? (Optional)",

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF4A8BFF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF4A8BFF)),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFF4A8BFF),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add a profile picture : ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF4A8BFF),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                  bottom: 12,
                                ),
                                child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: picture,
                                ),
                              ),
                            ],
                          ),
                          FlatButton(
                            colour: Colors.blueAccent,
                            onPressed: () async {
                              picture = await pickImage();

                              setState(() {});
                            },
                            text: "SELECT",
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FlatButton(
                      //  isPressed: isPressed,
                        text: "CONTINUE",
                        onPressed: () async {
                          // setState(() {
                          //   isPressed = !isPressed;
                          // });
                          String profilePic = "";

                          profilePic = await putFileInStorage(
                            picture,
                            randomNumber,
                            "image",
                          );
                          setState(() {});

                          // add users data inside datebase
                          isValidate && userDepartement.isNotEmpty
                              ? await ref
                                    .read(userDataServiceProvider)
                                    .addUserDataToFirestore(
                                      type: typeValue,
                                      department: userDepartement,
                                      email: widget.email,
                                      username: usernameController.text,
                                      profilePic: profilePic,

                                      description:
                                          descriptionController?.text ?? "",
                                    )
                              : () {};
                        },
                        colour: isValidate && userDepartement.isNotEmpty
                            ? Colors.blueAccent
                            : Colors.blueGrey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            