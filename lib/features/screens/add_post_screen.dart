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

      String department = selectedDepartments.contains("Everyone")
          ? "All"
          : selectedDepartments.join(", ");
      // String type = "General";
      String type = selectedPostType;
      String visibility = selectedMemberType == "Bureau Members Only"
          ? "Bureau Members Only"
          : "Everyone";

      if (_files.isNotEmpty) {
        res = await FireStoreMethods().uploadPost(
          description: _descriptionController.text,
          files: _files,
          uid: uid,
          username: username,
          profImage: profImage,
          department: department,
          type: type,
          visibility: visibility,
        );
      } else {
        res = await FireStoreMethods().uploadTextPost(
          description: _descriptionController.text,
          uid: uid,
          username: username,
          profImage: profImage,
          department: department,
          type: type,
          visibility: visibility,
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
  String selectedPostType = "Announcement";

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
                                return FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Padding(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Who can see your post?",
                                              style: GoogleFonts.lato(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 16),

                                            // Dropdown visibility
                                            DropdownButton<String>(
                                              value: selectedVisibility,
                                              isExpanded: true,
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

                                            // Checkbox list
                                            if (selectedVisibility == "Custom")
                                              Column(
                                                children: [
                                                  CheckboxListTile(
                                                    value:
                                                        selectedDepartments
                                                            .contains(
                                                              "Everyone",
                                                            ) ||
                                                        selectedDepartments
                                                            .contains(
                                                              "All Members",
                                                            ),
                                                    title: const Text(
                                                      "Everyone",
                                                    ),
                                                    activeColor: primaryColor,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    onChanged: (val) {
                                                      setStateModal(() {
                                                        if (val == true) {
                                                          selectedDepartments =
                                                              [
                                                                "Everyone",
                                                                "All Members",
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
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      onChanged: (val) {
                                                        setStateModal(() {
                                                          if (val == true) {
                                                            selectedDepartments
                                                                .add(d);
                                                            if (selectedDepartments
                                                                    .length ==
                                                                departments
                                                                    .length) {
                                                              selectedDepartments
                                                                  .addAll([
                                                                    "Everyone",
                                                                    "All Members",
                                                                  ]);
                                                            }
                                                          } else {
                                                            selectedDepartments
                                                                .remove(d);
                                                            selectedDepartments
                                                                .remove(
                                                                  "Everyone",
                                                                );
                                                            selectedDepartments
                                                                .remove(
                                                                  "All Members",
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
                                              isExpanded: true,
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
                                                  () =>
                                                      selectedMemberType = val!,
                                                );
                                              },
                                            ),

                                            const SizedBox(height: 20),

                                            Text(
                                              "Post Type",
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children:
                                                    [
                                                      "Announcement",
                                                      "Project",
                                                      "Event",
                                                    ].map((type) {
                                                      bool isSelected =
                                                          type ==
                                                          selectedPostType;
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              right: 8,
                                                            ),
                                                        child: ChoiceChip(
                                                          label: Text(type),
                                                          selected: isSelected,
                                                          onSelected: (val) {
                                                            setStateModal(() {
                                                              selectedPostType =
                                                                  type;
                                                            });
                                                          },
                                                          backgroundColor:
                                                              Theme.of(
                                                                    context,
                                                                  ).brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? const Color.fromRGBO(
                                                                  24,
                                                                  27,
                                                                  46,
                                                                  1,
                                                                )
                                                              : Colors
                                                                    .grey
                                                                    .shade200,
                                                          selectedColor:
                                                              primaryColor,
                                                          labelStyle: TextStyle(
                                                            color: isSelected
                                                                ? Colors.white
                                                                : (Theme.of(
                                                                            context,
                                                                          ).brightness ==
                                                                          Brightness
                                                                              .dark
                                                                      ? Colors
                                                                            .white
                                                                      : Colors
                                                                            .black87),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            // Full-width Save button
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryColor,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                    "$selectedMemberType, $selectedPostType",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                          : Color.fromARGB(255, 43, 43, 43),
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
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.add, color: primaryColor, size: 28),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
