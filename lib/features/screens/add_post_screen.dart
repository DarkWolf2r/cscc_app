import 'dart:typed_data';
import 'package:cscc_app/features/screens/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cscc_app/cores/utils.dart' show pickImage, showSnackBar;
import 'package:cscc_app/cores/firestore_methods.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  List<Uint8List> _files = [];
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  String? profilePicUrl;
  String? username;
  String? uid;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (userSnap.exists) {
      final data = userSnap.data()!;
      setState(() {
        uid = currentUser.uid;
        username = data['username'];
        profilePicUrl = data['profilePic'];
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectImage(BuildContext parentContext) async {
    await showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select images'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                final Uint8List file = await pickImage(ImageSource.camera);
                setState(() => _files.add(file));
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.pop(context);
                final List<XFile> pickedFiles = await ImagePicker()
                    .pickMultiImage();
                if (pickedFiles.isNotEmpty) {
                  final List<Uint8List> fileBytes = await Future.wait(
                    pickedFiles.map((xfile) => xfile.readAsBytes()),
                  );
                  setState(() => _files.addAll(fileBytes));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    if (_files.isEmpty && _descriptionController.text.isEmpty) return;
    setState(() => isLoading = true);

    try {
      String res;
      if (_files.isNotEmpty) {
        res = await FireStoreMethods().uploadPost(
          _descriptionController.text,
          _files.first,
          uid,
          username,
          profImage,
        );
      } else {
        res = await FireStoreMethods().uploadTextPost(
          _descriptionController.text,
          uid,
          username,
          profImage,
        );
      }

      if (res == "success") {
        if (mounted) showSnackBar(context, 'Posted!');
        setState(() => _files.clear());
        Navigator.pop(context);
      } else {
        if (mounted) showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String selectedVisibility = "Everyone";
  List<String> selectedDepartments = ["Everyone"];

  List<String> departments = [
    "Development",
    "Security",
    "Robotics",
    "Communication",
  ];

  List<String> memberTypes = ["All Members", "Bureau Members Only"];
  String selectedMemberType = "All Members";

  Widget _buildImageGrid() {
    int count = _files.length;

    void openFullScreenViewer(BuildContext context, int startIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FullScreenImageViewer(files: _files, initialIndex: startIndex),
        ),
      );
    }

    if (count == 1) {
      return GestureDetector(
        onTap: () => openFullScreenViewer(context, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            _files[0],
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (count == 2) {
      return Row(
        children: [
          for (int i = 0; i < 2; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => openFullScreenViewer(context, i),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      _files[i],
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    } else if (count == 3) {
      return SizedBox(
        height: 240,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => openFullScreenViewer(context, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    _files[0],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              flex: 1,
              child: Row(
                children: _files.sublist(1, 3).asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Uint8List f = entry.value;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => openFullScreenViewer(context, index),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(f, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    } else {
      int extra = count - 4;
      return SizedBox(
        height: 360,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1,
          children: List.generate(4, (index) {
            if (index == 3 && extra > 0) {
              return GestureDetector(
                onTap: () => openFullScreenViewer(context, index),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(_files[index], fit: BoxFit.cover),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Center(
                        child: Text(
                          '+$extra',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return GestureDetector(
              onTap: () => openFullScreenViewer(context, index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(_files[index], fit: BoxFit.cover),
              ),
            );
          }),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPostEnabled =
        _descriptionController.text.trim().isNotEmpty || _files.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Header Row =====
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        profilePicUrl != null && profilePicUrl!.isNotEmpty
                        ? NetworkImage(profilePicUrl!)
                        : const AssetImage('assets/profile.png')
                              as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setStateModal) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(
                                      context,
                                    ).viewInsets.bottom,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Who can see your post?",
                                            style: GoogleFonts.lato(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          DropdownButton<String>(
                                            value: selectedVisibility,
                                            items: const [
                                              DropdownMenuItem(
                                                value: "Everyone",
                                                child: Text("Everyone"),
                                              ),
                                              DropdownMenuItem(
                                                value: "Custom",
                                                child: Text(
                                                  "Custom (choose departments)",
                                                ),
                                              ),
                                            ],
                                            onChanged: (val) {
                                              setStateModal(() {
                                                selectedVisibility = val!;
                                                if (val == "Everyone") {
                                                  selectedDepartments = [
                                                    "Everyone",
                                                  ];
                                                }
                                              });
                                            },
                                          ),
                                          if (selectedVisibility == "Custom")
                                            Column(
                                              children: [
                                                CheckboxListTile(
                                                  value: selectedDepartments
                                                      .contains("Everyone"),
                                                  title: const Text("Everyone"),
                                                  activeColor: primaryColor,
                                                  onChanged: (val) {
                                                    setStateModal(() {
                                                      if (val == true) {
                                                        selectedDepartments = [
                                                          "Everyone",
                                                          ...departments,
                                                        ];
                                                      } else {
                                                        selectedDepartments
                                                            .clear();
                                                      }
                                                    });
                                                  },
                                                ),
                                                ...departments.map((d) {
                                                  bool isSelected =
                                                      selectedDepartments
                                                          .contains(d);
                                                  return CheckboxListTile(
                                                    value: isSelected,
                                                    title: Text(d),
                                                    activeColor: primaryColor,
                                                    onChanged: (val) {
                                                      setStateModal(() {
                                                        if (val == true) {
                                                          selectedDepartments
                                                              .add(d);
                                                        } else {
                                                          selectedDepartments
                                                              .remove(d);
                                                          selectedDepartments
                                                              .remove(
                                                                "Everyone",
                                                              );
                                                        }
                                                      });
                                                    },
                                                  );
                                                }),
                                              ],
                                            ),
                                          const SizedBox(height: 10),
                                          DropdownButton<String>(
                                            value: selectedMemberType,
                                            items: memberTypes
                                                .map(
                                                  (m) => DropdownMenuItem(
                                                    value: m,
                                                    child: Text(m),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (val) {
                                              setStateModal(
                                                () => selectedMemberType = val!,
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Save"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedDepartments.contains("Everyone")
                                        ? "Everyone"
                                        : selectedDepartments.join(', '),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    selectedMemberType,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  TextButton(
                    onPressed:
                        isPostEnabled &&
                            uid != null &&
                            username != null &&
                            profilePicUrl != null
                        ? () => postImage(uid!, username!, profilePicUrl!)
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: isPostEnabled
                          ? primaryColor
                          : Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      "Post",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===== TextField =====
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: "Share your thoughts...",
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 18,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (_files.isNotEmpty) _buildImageGrid(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ===== Bottom Row =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => _selectImage(context),
                    icon: const Icon(
                      Icons.image_outlined,
                      color: primaryColor,
                      size: 22,
                    ),
                    label: Text(
                      "Add Image",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: primaryColor, size: 28),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cscc_app/cores/utils.dart' show pickImage, showSnackBar;
// import 'package:cscc_app/cores/firestore_methods.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AddPostScreen extends ConsumerStatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends ConsumerState<AddPostScreen> {
//   List<Uint8List> _files = [];
//   bool isLoading = false;
//   final TextEditingController _descriptionController = TextEditingController();
//   String? profilePicUrl;
//   String? username;
//   String? uid;

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   Future<void> getUserData() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) return;

//     final userSnap = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(currentUser.uid)
//         .get();

//     if (userSnap.exists) {
//       final data = userSnap.data()!;
//       setState(() {
//         uid = currentUser.uid;
//         username = data['username'];
//         profilePicUrl = data['profilePic'];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   // Future<void> _selectImage(BuildContext parentContext) async {
//   //   await showDialog(
//   //     context: parentContext,
//   //     builder: (BuildContext context) {
//   //       return SimpleDialog(
//   //         title: const Text('Select an image'),
//   //         children: <Widget>[
//   //           SimpleDialogOption(
//   //             padding: const EdgeInsets.all(20),
//   //             child: const Text('Take a photo'),
//   //             onPressed: () async {
//   //               Navigator.pop(context);
//   //               final Uint8List file = await pickImage(ImageSource.camera);
//   //               setState(() => _file = file);
//   //             },
//   //           ),
//   //           SimpleDialogOption(
//   //             padding: const EdgeInsets.all(20),
//   //             child: const Text('Choose from Gallery'),
//   //             onPressed: () async {
//   //               Navigator.pop(context);
//   //               final Uint8List file = await pickImage(ImageSource.gallery);
//   //               setState(() => _file = file);
//   //             },
//   //           ),
//   //           // SimpleDialogOption(
//   //           //   padding: const EdgeInsets.all(20),
//   //           //   child: const Text("Cancel"),
//   //           //   onPressed: () => Navigator.pop(context),
//   //           // ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   Future<void> _selectImage(BuildContext parentContext) async {
//     await showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Select images'),
//           children: <Widget>[
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.camera);
//                 setState(() => _files.add(file));
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from Gallery'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final List<XFile> pickedFiles = await ImagePicker()
//                     .pickMultiImage();
//                 if (pickedFiles.isNotEmpty) {
//                   final List<Uint8List> fileBytes = await Future.wait(
//                     pickedFiles.map((xfile) => xfile.readAsBytes()),
//                   );
//                   setState(() => _files.addAll(fileBytes));
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void postImage(String uid, String username, String profImage) async {
//     if (_file == null && _descriptionController.text.isEmpty) return;
//     setState(() => isLoading = true);

//     try {
//       String res;
//       if (_file != null) {
//         res = await FireStoreMethods().uploadPost(
//           _descriptionController.text,
//           _file!,
//           uid,
//           username,
//           profImage,
//         );
//       } else {
//         res = await FireStoreMethods().uploadTextPost(
//           _descriptionController.text,
//           uid,
//           username,
//           profImage,
//         );
//       }

//       if (res == "success") {
//         if (mounted) showSnackBar(context, 'Posted!');
//         clearImage();
//         Navigator.pop(context);
//       } else {
//         if (mounted) showSnackBar(context, res);
//       }
//     } catch (err) {
//       showSnackBar(context, err.toString());
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   void clearImage() => setState(() => _file = null);

//   String selectedVisibility = "Everyone";
//   List<String> selectedDepartments = ["Everyone"];

//   List<String> departments = [
//     "Development",
//     "Security",
//     "Robotics",
//     "Communication",
//   ];

//   List<String> memberTypes = ["All Members", "Bureau Members Only"];
//   String selectedMemberType = "All Members";

//   @override
//   Widget build(BuildContext context) {
//     // bool isPostEnabled =
//     //     _descriptionController.text.trim().isNotEmpty || _file != null;
//     bool isPostEnabled =
//         _descriptionController.text.trim().isNotEmpty || _files.isNotEmpty;

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // IconButton(
//                   //   icon: const Icon(Icons.close, color: Colors.white70),
//                   //   onPressed: () => Navigator.pop(context),
//                   // ),
//                   // const SizedBox(width: 10),
//                   CircleAvatar(
//                     radius: 18,
//                     backgroundImage:
//                         profilePicUrl != null && profilePicUrl!.isNotEmpty
//                         ? NetworkImage(profilePicUrl!)
//                         : const AssetImage('assets/profile.png')
//                               as ImageProvider,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () async {
//                         await showModalBottomSheet(
//                           isScrollControlled: true,
//                           context: context,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(20),
//                             ),
//                           ),
//                           builder: (context) {
//                             return StatefulBuilder(
//                               builder: (context, setStateModal) {
//                                 return SafeArea(
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                       bottom: MediaQuery.of(
//                                         context,
//                                       ).viewInsets.bottom,
//                                     ),
//                                     child: SingleChildScrollView(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(16),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Who can see your post?",
//                                               style: GoogleFonts.lato(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 16),

//                                             DropdownButton<String>(
//                                               value: selectedVisibility,
//                                               items: const [
//                                                 DropdownMenuItem(
//                                                   value: "Everyone",
//                                                   child: Text("Everyone"),
//                                                 ),
//                                                 DropdownMenuItem(
//                                                   value: "Custom",
//                                                   child: Text(
//                                                     "Custom (choose departments)",
//                                                   ),
//                                                 ),
//                                               ],
//                                               onChanged: (val) {
//                                                 setStateModal(() {
//                                                   selectedVisibility = val!;
//                                                   if (selectedVisibility ==
//                                                       "Everyone") {
//                                                     selectedDepartments = [
//                                                       "Everyone",
//                                                     ];
//                                                   }
//                                                 });
//                                               },
//                                             ),

//                                             const SizedBox(height: 10),

//                                             if (selectedVisibility == "Custom")
//                                               Column(
//                                                 children: [
//                                                   CheckboxListTile(
//                                                     value: selectedDepartments
//                                                         .contains("Everyone"),
//                                                     title: const Text(
//                                                       "Everyone",
//                                                     ),
//                                                     activeColor: primaryColor,
//                                                     onChanged: (val) {
//                                                       setStateModal(() {
//                                                         if (val == true) {
//                                                           selectedDepartments =
//                                                               [
//                                                                 "Everyone",
//                                                                 ...departments,
//                                                               ];
//                                                         } else {
//                                                           selectedDepartments
//                                                               .clear();
//                                                         }
//                                                       });
//                                                     },
//                                                   ),
//                                                   ...departments.map((d) {
//                                                     bool isSelected =
//                                                         selectedDepartments
//                                                             .contains(d);
//                                                     return CheckboxListTile(
//                                                       value: isSelected,
//                                                       title: Text(d),
//                                                       activeColor: primaryColor,
//                                                       onChanged: (val) {
//                                                         setStateModal(() {
//                                                           if (val == true) {
//                                                             selectedDepartments
//                                                                 .add(d);
//                                                             if (selectedDepartments
//                                                                     .length ==
//                                                                 departments
//                                                                     .length) {
//                                                               selectedDepartments
//                                                                   .insert(
//                                                                     0,
//                                                                     "Everyone",
//                                                                   );
//                                                             }
//                                                           } else {
//                                                             selectedDepartments
//                                                                 .remove(d);
//                                                             selectedDepartments
//                                                                 .remove(
//                                                                   "Everyone",
//                                                                 );
//                                                           }
//                                                         });
//                                                       },
//                                                     );
//                                                   }).toList(),
//                                                 ],
//                                               ),

//                                             const SizedBox(height: 10),

//                                             DropdownButton<String>(
//                                               value: selectedMemberType,
//                                               items: memberTypes.map((m) {
//                                                 return DropdownMenuItem(
//                                                   value: m,
//                                                   child: Text(m),
//                                                 );
//                                               }).toList(),
//                                               onChanged: (val) {
//                                                 setStateModal(
//                                                   () =>
//                                                       selectedMemberType = val!,
//                                                 );
//                                               },
//                                             ),

//                                             const SizedBox(height: 20),
//                                             Center(
//                                               child: ElevatedButton(
//                                                 onPressed: () =>
//                                                     Navigator.pop(context),
//                                                 child: const Text("Save"),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         );

//                         setState(() {});
//                       },

//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade400),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   // Text(
//                                   //   selectedDepartments.join(', '),
//                                   //   style: const TextStyle(
//                                   //     fontSize: 14,
//                                   //     fontWeight: FontWeight.w600,
//                                   //   ),
//                                   //   overflow: TextOverflow.ellipsis,
//                                   // ),
//                                   Text(
//                                     selectedDepartments.contains("Everyone")
//                                         ? "Everyone"
//                                         : selectedDepartments.join(', '),
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),

//                                   Text(
//                                     selectedMemberType,
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const Icon(Icons.arrow_drop_down, size: 20),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(width: 40),

//                   // Post Button
//                   TextButton(
//                     // onPressed: isPostEnabled
//                     //     ? () => postImage(
//                     //         mockUser['uid']!,
//                     //         mockUser['username']!,
//                     //         mockUser['photoUrl']!,
//                     //       )
//                     //     : null,
//                     onPressed:
//                         isPostEnabled &&
//                             uid != null &&
//                             username != null &&
//                             profilePicUrl != null
//                         ? () => postImage(uid!, username!, profilePicUrl!)
//                         : null,
//                     style: TextButton.styleFrom(
//                       backgroundColor: isPostEnabled
//                           ? primaryColor
//                           : Colors.grey.shade600,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 18,
//                         vertical: 8,
//                       ),
//                     ),
//                     child: Text(
//                       "Post",
//                       style: GoogleFonts.lato(
//                         textStyle: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // ===== TextField =====
//               Expanded(
//                 child: TextField(
//                   controller: _descriptionController,
//                   maxLines: null,
//                   onChanged: (_) => setState(() {}),
//                   decoration: InputDecoration(
//                     hintText: "Share your thoughts...",
//                     border: InputBorder.none,
//                     hintStyle: GoogleFonts.lato(
//                       textStyle: TextStyle(
//                         color: Colors.grey.shade500,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                   style: GoogleFonts.lato(
//                     textStyle: TextStyle(
//                       color: Theme.of(context).brightness == Brightness.dark
//                           ? Colors.white
//                           : Colors.black87,
//                       fontSize: 18,
//                       height: 1.4,
//                     ),
//                   ),
//                 ),
//               ),

//               // if (_file != null)
//               //   ClipRRect(
//               //     borderRadius: BorderRadius.circular(12),
//               //     child: Image.memory(
//               //       _file!,
//               //       height: 220,
//               //       width: double.infinity,
//               //       fit: BoxFit.cover,
//               //     ),
//               //   ),
//               if (_files.isNotEmpty) _buildImageGrid(),
//               Widget _buildImageGrid() {
//                 int count = _files.length;
//                 double size = 120;

//                 if (count == 1) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.memory(
//                       _files[0],
//                       width: double.infinity,
//                       height: 250,
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 } else if (count == 2) {
//                   return Row(
//                     children: _files.take(2).map((f) {
//                       return Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.memory(f, height: 200, fit: BoxFit.cover),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 } else if (count == 3) {
//                   return SizedBox(
//                     height: 240,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.memory(_files[0], width: double.infinity, fit: BoxFit.cover),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: _files.sublist(1, 3).map((f) {
//                               return Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(2.0),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: Image.memory(f, fit: BoxFit.cover),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   // أكثر من 4 صور
//                   int extra = count - 4;
//                   return SizedBox(
//                     height: 250,
//                     child: GridView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 4,
//                         mainAxisSpacing: 4,
//                       ),
//                       itemCount: 4,
//                       itemBuilder: (context, index) {
//                         if (index == 3 && extra > 0) {
//                           return Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.memory(
//                                   _files[index],
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Container(
//                                 color: Colors.black54,
//                                 child: Center(
//                                   child: Text(
//                                     '+$extra',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         } else {
//                           return ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.memory(
//                               _files[index],
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 }
//               },


//               const SizedBox(height: 10),

//               // ===== Bottom Row =====
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton.icon(
//                     onPressed: () => _selectImage(context),
//                     icon: const Icon(
//                       Icons.image_outlined,
//                       color: primaryColor,
//                       size: 22,
//                     ),
//                     label: Text(
//                       "Add Image",
//                       style: GoogleFonts.lato(
//                         textStyle: const TextStyle(
//                           color: primaryColor,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.add, color: primaryColor, size: 28),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }







// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cscc_app/cores/utils.dart' show pickImage, showSnackBar;
// import 'package:cscc_app/cores/firestore_methods.dart';
// import 'package:cscc_app/cores/colors.dart';

// class AddPostScreen extends ConsumerStatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends ConsumerState<AddPostScreen> {
//   Uint8List? _file;
//   bool isLoading = false;
//   final TextEditingController _descriptionController = TextEditingController();

//   Future<void> _selectImage(BuildContext parentContext) async {
//     await showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Select an image'),
//           children: <Widget>[
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.camera);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from Gallery'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.gallery);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text("Cancel"),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void postImage(String uid, String username, String profImage) async {
//     if (_file == null) return;
//     setState(() => isLoading = true);

//     try {
//       String res = await FireStoreMethods().uploadPost(
//         _descriptionController.text,
//         _file!,
//         uid,
//         username,
//         profImage,
//       );

//       if (res == "success") {
//         if (mounted) showSnackBar(context, 'Posted!');
//         clearImage();
//       } else {
//         if (mounted) showSnackBar(context, res);
//       }
//     } catch (err) {
//       showSnackBar(context, err.toString());
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   void clearImage() => setState(() => _file = null);

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const mockUser = {
//       'uid': 'test_uid',
//       'username': 'Test User',
//       'photoUrl': 'https://via.placeholder.com/150',
//     };

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: [
//           Positioned(
//             // top: 60,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surface,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(25),
//                   topRight: Radius.circular(25),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (isLoading)
//                       const LinearProgressIndicator(
//                         color: primaryColor,
//                         backgroundColor: Colors.white,
//                       ),
//                     const SizedBox(height: 20),
//                     Text(
//                       "Create a Post",
//                       style: GoogleFonts.lato(
//                         textStyle: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: primaryColor,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: _descriptionController,
//                       style: const TextStyle(color: Colors.black, fontSize: 18),
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                         hintText: "Share your thoughts...",
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         enabledBorder: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           borderSide: BorderSide(color: Color(0xFF4A8BFF)),
//                         ),
//                         focusedBorder: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           borderSide: BorderSide(color: Color(0xFF4A8BFF)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     if (_file != null)
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.memory(
//                           _file!,
//                           height: 220,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: () => _selectImage(context),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4A8BFF),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 12,
//                             ),
//                           ),
//                           icon: const Icon(
//                             Icons.image_outlined,
//                             color: Colors.white,
//                           ),
//                           label: const Text(
//                             "Add Image",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed:
//                               (_descriptionController.text.isEmpty &&
//                                   _file == null)
//                               ? null
//                               : () => postImage(
//                                   mockUser['uid']!,
//                                   mockUser['username']!,
//                                   mockUser['photoUrl']!,
//                                 ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 (_descriptionController.text.isEmpty &&
//                                     _file == null)
//                                 ? Colors.blueGrey
//                                 : const Color(0xFF4A8BFF),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 25,
//                               vertical: 12,
//                             ),
//                           ),
//                           child: const Text(
//                             "Post",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'dart:typed_data';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cscc_app/cores/utils.dart' show pickImage, showSnackBar;
// import 'package:cscc_app/cores/firestore_methods.dart';

// class AddPostScreen extends ConsumerStatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends ConsumerState<AddPostScreen> {
//   Uint8List? _file;
//   bool isLoading = false;
//   final TextEditingController _descriptionController = TextEditingController();

//   Future<void> _selectImage(BuildContext parentContext) async {
//     await showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           children: <Widget>[
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.camera);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from Gallery'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.gallery);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text("Cancel"),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // void postImage() async {
//   //   setState(() => isLoading = true);
//   //   try {
//   //     String res = await FireStoreMethods().uploadPost(
//   //       _descriptionController.text,
//   //       _file!,
//   //       mockUser['uid']!,
//   //       mockUser['username']!,
//   //       mockUser['photoUrl']!,
//   //     );
//   //     if (res == "success") {
//   //       showSnackBar(context, 'Posted!');
//   //       setState(() {
//   //         isLoading = false;
//   //         _file = null;
//   //         _descriptionController.clear();
//   //       });
//   //     } else {
//   //       showSnackBar(context, res);
//   //     }
//   //   } catch (err) {
//   //     showSnackBar(context, err.toString());
//   //     setState(() => isLoading = false);
//   //   }
//   // }
//   void postImage(String uid, String username, String profImage) async {
//     if (_file == null) return;
//     setState(() => isLoading = true);

//     try {
//       String res = await FireStoreMethods().uploadPost(
//         _descriptionController.text,
//         _file!,
//         uid,
//         username,
//         profImage,
//       );

//       if (res == "success") {
//         if (mounted) showSnackBar(context, 'Posted!');
//         clearImage();
//       } else {
//         if (mounted) showSnackBar(context, res);
//       }
//     } catch (err) {
//       showSnackBar(context, err.toString());
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   void clearImage() => setState(() => _file = null);

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const mockUser = {
//       'uid': 'test_uid',
//       'username': 'Test User',
//       'photoUrl': 'https://via.placeholder.com/150',
//     };
//     return Scaffold(
//       backgroundColor: primaryColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         // leading: IconButton(
//         //   icon: const Icon(Icons.close, color: Colors.white70),
//         //   onPressed: () => Navigator.pop(context),
//         // ),
//         leading: _file != null
//           ? IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: clearImage,
//             )
//           : null,
//         title: const Text('Create a post', style: TextStyle(color: Colors.white)),
//         actions: [
//           TextButton(
//             // onPressed: _descriptionController.text.isEmpty && _file == null
//             //     ? null
//             //     : postImage,
//             onPressed: (_descriptionController.text.isEmpty && _file == null)
//                 ? null
//                 : () => postImage(
//                       mockUser['uid']!,
//                       mockUser['username']!,
//                       mockUser['photoUrl']!,
//                     ),
//             child: Text(
//               "Post",
//               style: TextStyle(
//                 color: (_descriptionController.text.isEmpty && _file == null)
//                     ? Colors.grey
//                     : Colors.blueAccent,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             isLoading
//                 ? const LinearProgressIndicator()
//                 : const Padding(padding: EdgeInsets.only(top: 0.0)),
//             const Divider(),
//             Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 22,
//                   backgroundImage: NetworkImage(
//                     'https://via.placeholder.com/150',
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[850],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: const [
//                       Text(
//                         "Anyone",
//                         style: TextStyle(color: Colors.white70, fontSize: 13),
//                       ),
//                       Icon(Icons.arrow_drop_down, color: Colors.white70),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: TextField(
//                 controller: _descriptionController,
//                 style: const TextStyle(color: Colors.white, fontSize: 18),
//                 maxLines: null,
//                 decoration: const InputDecoration(
//                   hintText: "Share your thoughts...",
//                   hintStyle: TextStyle(color: Colors.white54),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             if (_file != null)
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   image: DecorationImage(
//                     image: MemoryImage(_file!),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.image_outlined,
//                     color: Colors.white70,
//                     size: 26,
//                   ),
//                   onPressed: () => _selectImage(context),
//                 ),
//                 // TextButton.icon(
//                 //   onPressed: () {},
//                 //   icon: const Icon(
//                 //     Icons.auto_awesome,
//                 //     color: Colors.amberAccent,
//                 //   ),
//                 //   label: const Text(
//                 //     "Rewrite with AI",
//                 //     style: TextStyle(color: Colors.amberAccent),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/firestore_methods.dart';
// import 'package:cscc_app/cores/utils.dart' show pickImage, showSnackBar;
// import 'package:cscc_app/features/auth/model/user_model.dart' show UserModel;
// import 'package:cscc_app/features/auth/provider/providers.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// class AddPostScreen extends ConsumerStatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends ConsumerState<AddPostScreen> {
//   Uint8List? _file;
//   bool isLoading = false;
//   final TextEditingController _descriptionController = TextEditingController();

//   Future<void> _selectImage(BuildContext parentContext) async {
//     await showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Create a Post'),
//           children: <Widget>[
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.camera);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from Gallery'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.gallery);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text("Cancel"),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void postImage(String uid, String username, String profImage) async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       String res = await FireStoreMethods().uploadPost(
//         _descriptionController.text,
//         _file!,
//         uid,
//         username,
//         profImage,
//       );
//       if (res == "success") {
//         setState(() {
//           isLoading = false;
//         });
//         if (context.mounted) {
//           showSnackBar(context, 'Posted!');
//         }
//         clearImage();
//       } else {
//         if (context.mounted) {
//           showSnackBar(context, res);
//         }
//       }
//     } catch (err) {
//       setState(() {
//         isLoading = false;
//       });
//       showSnackBar(context, err.toString());
//     }
//   }

//   void clearImage() {
//     setState(() {
//       _file = null;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _descriptionController.dispose();
//   }

//   @override
// Widget build(BuildContext context) {
//   const mockUser = {
//     'uid': 'test_uid',
//     'username': 'Test User',
//     'photoUrl': 'https://via.placeholder.com/150'
//   };

//   return _file == null
//       ? Center(
//           child: IconButton(
//             icon: const Icon(Icons.upload),
//             onPressed: () => _selectImage(context),
//           ),
//         )
//       : Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: clearImage,
//             ),
//             title: const Text('Post to'),
//             centerTitle: false,
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => postImage(
//                   mockUser['uid']!,
//                   mockUser['username']!,
//                   mockUser['photoUrl']!,
//                 ),
//                 child: const Text(
//                   "Post",
//                   style: TextStyle(
//                     color: Colors.blueAccent,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: Column(
//             children: <Widget>[
//               isLoading
//                   ? const LinearProgressIndicator()
//                   : const Padding(padding: EdgeInsets.only(top: 0.0)),
//               const Divider(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   const CircleAvatar(
//                     backgroundImage:
//                         NetworkImage('https://via.placeholder.com/150'),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.3,
//                     child: TextField(
//                       controller: _descriptionController,
//                       decoration: const InputDecoration(
//                         hintText: "Write a caption...",
//                         border: InputBorder.none,
//                       ),
//                       maxLines: 8,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 45.0,
//                     width: 45.0,
//                     child: AspectRatio(
//                       aspectRatio: 487 / 451,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             fit: BoxFit.fill,
//                             alignment: FractionalOffset.topCenter,
//                             image: MemoryImage(_file!),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],
//           ),
//         );
// }

  // @override
  // Widget build(BuildContext context) {
  //   // final UserNotifier userProvider = Provider.of<UserNotifier>(context);

  //   return _file == null
  //       ? Center(
  //           child: IconButton(
  //             icon: const Icon(Icons.upload),
  //             onPressed: () => _selectImage(context),
  //           ),
  //         )
  //       : Scaffold(
  //           appBar: AppBar(
  //             backgroundColor: Colors.transparent,
  //             leading: IconButton(
  //               icon: const Icon(Icons.arrow_back),
  //               onPressed: clearImage,
  //             ),
  //             title: const Text('Post to'),
  //             centerTitle: false,
  //             actions: <Widget>[
  //               TextButton(
  //                 // onPressed: () => postImage(
  //                 //   userProvider.getUser.uid,
  //                 //   userProvider.getUser.username,
  //                 //   userProvider.getUser.photoUrl,
  //                 // ),
  //                 onPressed: () => {},
  //                 child: const Text(
  //                   "Post",
  //                   style: TextStyle(
  //                     color: Colors.blueAccent,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16.0,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           // POST FORM
  //           body: Column(
  //             children: <Widget>[
  //               isLoading
  //                   ? const LinearProgressIndicator()
  //                   : const Padding(padding: EdgeInsets.only(top: 0.0)),
  //               const Divider(),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   CircleAvatar(
  //                     // backgroundImage: NetworkImage(
  //                     //   UserNotifier.getUser.photoUrl,
  //                     // ),
  //                   ),
  //                   SizedBox(
  //                     width: MediaQuery.of(context).size.width * 0.3,
  //                     child: TextField(
  //                       controller: _descriptionController,
  //                       decoration: const InputDecoration(
  //                         hintText: "Write a caption...",
  //                         border: InputBorder.none,
  //                       ),
  //                       maxLines: 8,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 45.0,
  //                     width: 45.0,
  //                     child: AspectRatio(
  //                       aspectRatio: 487 / 451,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           image: DecorationImage(
  //                             fit: BoxFit.fill,
  //                             alignment: FractionalOffset.topCenter,
  //                             image: MemoryImage(_file!),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const Divider(),
  //             ],
  //           ),
  //         );
  // }
// }

    // final currentUserAsync = ref.watch(currentUserProvider);

    // return currentUserAsync.when(
    //   data: (user) {
    //     if (_file == null) {
    //       return Scaffold(
    //         backgroundColor: primaryColor,
    //         body: Center(
    //           child: IconButton(
    //             icon: const Icon(Icons.upload),
    //             onPressed: () => _selectImage(context),
    //           ),
    //         ),
    //       );
    //     }

    //     return Scaffold(
    //       backgroundColor: primaryColor,
    //       appBar: AppBar(
    //         backgroundColor: Colors.transparent,
    //         leading: IconButton(
    //           icon: const Icon(Icons.arrow_back),
    //           onPressed: clearImage,
    //         ),
    //         title: const Text('Post to'),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               print("Posting: ${_descriptionController.text}");
    //             },
    //             child: const Text(
    //               "Post",
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 16.0,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       body: Column(
    //         children: [
    //           if (isLoading) const LinearProgressIndicator(),
    //           const Divider(),
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               CircleAvatar(
    //                 // backgroundImage: NetworkImage(user.photoUrl),
    //               ),
    //               const SizedBox(width: 10),
    //               Expanded(
    //                 child: TextField(
    //                   controller: _descriptionController,
    //                   decoration: const InputDecoration(
    //                     hintText: "Write a caption...",
    //                     border: InputBorder.none,
    //                   ),
    //                   maxLines: 8,
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 45,
    //                 width: 45,
    //                 child: Image.memory(_file!, fit: BoxFit.cover),
    //               ),
    //             ],
    //           ),
    //           const Divider(),
    //         ],
    //       ),
    //     );
    //   },
    //   loading: () => const Center(child: CircularProgressIndicator()),
    //   error: (e, _) => Center(child: Text('Error loading user: $e')),

    // );

// import 'dart:typed_data';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/utils.dart' show pickImage;
// import 'package:cscc_app/features/auth/model/user_model.dart';
// import 'package:cscc_app/features/auth/provider/providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// class AddPostScreen extends ConsumerStatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends ConsumerState<AddPostScreen> {
//   Uint8List? _file;
//   bool isLoading = false;
//   final TextEditingController _descriptionController = TextEditingController();

//   // 🔹 نافذة اختيار الصورة
//   Future<void> _selectImage(BuildContext context) async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Create a Post'),
//           children: [
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.camera);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from Gallery'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.gallery);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text("Cancel"),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // 🔹 لإلغاء الصورة
//   void clearImage() => setState(() => _file = null);

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUserAsync = ref.watch(currentUserProvider);

//     return currentUserAsync.when(
//       data: (user) {
//         // 🔹 إذا ما كاينش صورة مختارة
//         if (_file == null) {
//           return Scaffold(
//             backgroundColor: primaryColor,
//             body: Center(
//               child: IconButton(
//                 icon: const Icon(Icons.upload, color: Colors.white, size: 40),
//                 onPressed: () => _selectImage(context),
//               ),
//             ),
//           );
//         }

//         // 🔹 واجهة النشر
//         return Scaffold(
//           backgroundColor: primaryColor,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: clearImage,
//             ),
//             title: const Text('Post to'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   // هنا لاحقاً تدمجي Firestore upload
//                   print(
//                     "Posting by ${user.username}: ${_descriptionController.text}",
//                   );
//                 },
//                 child: const Text(
//                   "Post",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               if (isLoading) const LinearProgressIndicator(),
//               const Divider(),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     // backgroundImage: NetworkImage(user.profilePic),
//                     radius: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       controller: _descriptionController,
//                       decoration: const InputDecoration(
//                         hintText: "Write a caption...",
//                         border: InputBorder.none,
//                         hintStyle: TextStyle(color: Colors.white70),
//                       ),
//                       style: const TextStyle(color: Colors.white),
//                       maxLines: 8,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 45,
//                     width: 45,
//                     child: Image.memory(_file!, fit: BoxFit.cover),
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],
//           ),
//         );
//       },

//       loading: () => const Center(child: CircularProgressIndicator()),

//       // 🔹 وضع تجريبي في حالة عدم وجود مستخدم
//       error: (e, _) {
//         final mockUser = UserModel(
//           userId: 'test123',
//           username: 'Test User',
//           profilePic: 'https://via.placeholder.com/150',
//           email: 'test@example.com',
//           description: 'Testing user profile',
//           type: 'guest',
//           departement: ['Test Dept'],
//         );

//         if (_file == null) {
//           return Scaffold(
//             backgroundColor: primaryColor,
//             body: Center(
//               child: IconButton(
//                 icon: const Icon(Icons.upload, color: Colors.white, size: 40),
//                 onPressed: () => _selectImage(context),
//               ),
//             ),
//           );
//         }

//         // نفس الواجهة ولكن بالمستخدم التجريبي
//         return Scaffold(
//           backgroundColor: primaryColor,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: clearImage,
//             ),
//             title: const Text('Post to (Mock Mode)'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   print("Posting mock: ${_descriptionController.text}");
//                 },
//                 child: const Text(
//                   "Post",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               if (isLoading) const LinearProgressIndicator(),
//               const Divider(),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     // backgroundImage: NetworkImage(mockUser.profilePic),
//                     radius: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       controller: _descriptionController,
//                       decoration: const InputDecoration(
//                         hintText: "Write a caption...",
//                         border: InputBorder.none,
//                         hintStyle: TextStyle(color: Colors.white70),
//                       ),
//                       style: const TextStyle(color: Colors.white),
//                       maxLines: 8,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 45,
//                     width: 45,
//                     child: Image.memory(_file!, fit: BoxFit.cover),
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// import 'dart:typed_data';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/utils.dart' show pickImage;
// import 'package:cscc_app/features/auth/provider/providers.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AddPostScreen extends ConsumerStatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends ConsumerState<AddPostScreen> {
//   Uint8List? _file;
//   bool isLoading = false;
//   final TextEditingController _descriptionController = TextEditingController();

//   Future<void> _selectImage(BuildContext parentContext) async {
//     await showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Create a Post'),
//           children: <Widget>[
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 final Uint8List file = await pickImage(ImageSource.camera);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from Gallery'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 final Uint8List file = await pickImage(ImageSource.gallery);
//                 setState(() => _file = file);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text("Cancel"),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // void postImage(String uid, String username, String profImage) async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   // start the loading
//   //   try {
//   //     // upload to storage and db
//   //     String res = await FireStoreMethods().uploadPost(
//   //       _descriptionController.text,
//   //       _file!,
//   //       uid,
//   //       username,
//   //       profImage,
//   //     );
//   //     if (res == "success") {
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //       if (context.mounted) {
//   //         showSnackBar(
//   //           context,
//   //           'Posted!',
//   //         );
//   //       }
//   //       clearImage();
//   //     } else {
//   //       if (context.mounted) {
//   //         showSnackBar(context, res);
//   //       }
//   //     }
//   //   } catch (err) {
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //     showSnackBar(
//   //       context,
//   //       err.toString(),
//   //     );
//   //   }
//   // }

//   void clearImage() {
//     setState(() {
//       _file = null;
//     });
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final UserProvider userProvider = Provider.of<UserProvider>(context);
//     final currentUserAsync = ref.watch(currentUserProvider);

//     return currentUserAsync.when(
//       data: (user) {
//         if (_file == null) {
//           return Center(
//             child: IconButton(
//               icon: const Icon(Icons.upload),
//               onPressed: () => _selectImage(context),
//             ),
//           );
//         }
//         return Scaffold(
//           backgroundColor: primaryColor,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: clearImage,
//             ),
//             title: const Text('Post to'),
//             centerTitle: false,
//             actions: <Widget>[
//               TextButton(
//                 // onPressed: () => postImage(
//                 //   userProvider.getUser.uid,
//                 //   userProvider.getUser.username,
//                 //   userProvider.getUser.photoUrl,
//                 // ),
//                 // onPressed: () => {},
//                 onPressed: () {
//                   print("Posting: ${_descriptionController.text}");
//                 },
//                 child: const Text(
//                   "Post",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: Column(
//             children: <Widget>[
//               if (isLoading)
//                 const LinearProgressIndicator()
//               else
//                 const SizedBox(height: 4),
//               const Divider(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   CircleAvatar(
//                     // backgroundImage: NetworkImage(
//                     //   userProvider.getUser.photoUrl,
//                     // ),
//                     backgroundImage: NetworkImage(user.photoUrl),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.3,
//                     child: TextField(
//                       controller: _descriptionController,
//                       decoration: const InputDecoration(
//                         hintText: "Write a caption...",
//                         border: InputBorder.none,
//                       ),
//                       maxLines: 8,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 45.0,
//                     width: 45.0,
//                     child: AspectRatio(
//                       aspectRatio: 487 / 451,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             fit: BoxFit.fill,
//                             alignment: FractionalOffset.topCenter,
//                             image: MemoryImage(_file!),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (e, _) => Center(child: Text('Error loading user: $e')),
//     );
//   }
// }
