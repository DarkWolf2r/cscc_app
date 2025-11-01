// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:cscc_app/cores/method.dart';
import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/features/auth/repo/user_info_repo.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  final String? email;
  final String? github;

  const UserInfoPage(this.email, this.github, {super.key});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isValidate = true;
  File? picture;
  String typeValue = 'Membre';
  String bureauType = '';
  final userInfoKey = GlobalKey<FormState>();
  String randomNumber = const Uuid().v4();

  List<String> userDepartement = [];

  final List<String> departementValue = [
    "Developpement",
    "Security",
    "Communication",
    "Robotics",
  ];

  final List<String> membreDeBureauList = [
    "Chef Developement",
    "Chef Security",
    "Chef Robotic",
    "Chef Communication",
    "Chef Logistic",
    "Chef Events",
    "VP Intern",
    "VP Extern",
  ];

  Future<void> validateUsername() async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .get();
    final usernames = usersSnapshot.docs
        .map((u) => u["username"] as String)
        .toList();

    if (usernames.contains(usernameController.text.trim())) {
      setState(() => isValidate = false);
    } else {
      setState(() => isValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF4A8BFF),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 0.6,
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
                  children: [
                    Text(
                      "CSCC",
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Team",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              Positioned(
                top: 200,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 0.6,
                  padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "User Informations",
                        style: GoogleFonts.lato(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF4A8BFF),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Username field
                      Form(
                        key: userInfoKey,
                        child: TextFormField(
                          onChanged: (_) => validateUsername(),
                          autovalidateMode: AutovalidateMode.always,
                          validator: (_) =>
                              isValidate ? null : "Username already taken",
                          controller: usernameController,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              isValidate
                                  ? Icons.verified_user_outlined
                                  : Icons.cancel,
                              color: isValidate ? Colors.green : Colors.red,
                            ),
                            hintText: 'Insert username',
                            border: const OutlineInputBorder(),
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

                      // Type selection
                      Row(
                        children: [
                          Text(
                            "Select your Type : ",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A8BFF),
                            ),
                          ),
                          const SizedBox(width: 20),
                          DropdownButton<String>(
                            value: typeValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: const [
                              DropdownMenuItem(
                                value: "Membre",
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
                                if (typeValue != "Membre du bureau") {
                                  bureauType = '';
                                }
                              });
                            },
                          ),
                        ],
                      ),

                      // Bureau role (only if "Membre du bureau")
                      if (typeValue == "Membre du bureau") ...[
                        const SizedBox(height: 15),
                        const Text(
                          "Select your Bureau Role : ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4A8BFF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                          iconEnabledColor: Colors.black,
                          value: bureauType.isNotEmpty ? bureauType : null,
                          hint: const Text("Choose your bureau position"),
                          items: membreDeBureauList
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => bureauType = value!);
                          },
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Department chips
                      const Text(
                        'Add your Department : ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4A8BFF),
                        ),
                      ),
                      const SizedBox(height: 10),
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

                      // Description
                      const Text(
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
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "What are your interests? (Optional)",
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF4A8BFF)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF4A8BFF)),
                          ),
                          fillColor: Theme.of(context).colorScheme.surface,
                          filled: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Profile picture
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add a profile picture : ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A8BFF),
                            ),
                          ),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                (picture == null || picture!.path.isEmpty)
                                ? const AssetImage('assets/profile.png')
                                : FileImage(picture!) as ImageProvider,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      FlatButton(
                        colour: Colors.blueAccent,
                        text: "SELECT",
                        onPressed: () async {
                          picture = await pickImage();
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 20),

                      // Continue button
                      FlatButton(
                        text: "CONTINUE",

                        colour:
                            isValidate &&
                                userDepartement.isNotEmpty &&
                                (typeValue != 'Membre du bureau' ||
                                    bureauType.isNotEmpty)
                            ? Colors.blueAccent
                            : Colors.blueGrey,
                        onPressed: () async {
                          if (!isValidate ||
                              userDepartement.isEmpty ||
                              (typeValue == 'Membre du bureau' &&
                                  bureauType.isEmpty))
                            return;

                          if (picture == null) {
                            final byteData = await rootBundle.load(
                              'assets/profile.png',
                            );
                            final tempDir = await getTemporaryDirectory();
                            final file = File(
                              '${tempDir.path}/default_profile.png',
                            );
                            await file.writeAsBytes(
                              byteData.buffer.asUint8List(),
                            );
                            picture = file;
                          }

                          final profilePic = await putFileInStorage(
                            picture!,
                            randomNumber,
                            "image",
                          );

                          await ref
                              .read(userDataServiceProvider)
                              .addUserDataToFirestore(
                                context: context,
                                type: bureauType.isNotEmpty
                                    ? bureauType
                                    : typeValue,
                                department: userDepartement,
                                email: widget.email,
                                github: widget.github,
                                username: usernameController.text.trim(),
                                profilePic: profilePic,
                                description: descriptionController.text.trim(),
                              );
                        },
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
