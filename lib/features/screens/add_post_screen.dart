import 'dart:typed_data';
import 'package:cscc_app/cores/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cscc_app/cores/utils.dart' show pickImage, showSnackBar;
import 'package:cscc_app/cores/firestore_methods.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectImage(BuildContext parentContext) async {
    await showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                final Uint8List file = await pickImage(ImageSource.camera);
                setState(() => _file = file);
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.pop(context);
                final Uint8List file = await pickImage(ImageSource.gallery);
                setState(() => _file = file);
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // void postImage() async {
  //   setState(() => isLoading = true);
  //   try {
  //     String res = await FireStoreMethods().uploadPost(
  //       _descriptionController.text,
  //       _file!,
  //       mockUser['uid']!,
  //       mockUser['username']!,
  //       mockUser['photoUrl']!,
  //     );
  //     if (res == "success") {
  //       showSnackBar(context, 'Posted!');
  //       setState(() {
  //         isLoading = false;
  //         _file = null;
  //         _descriptionController.clear();
  //       });
  //     } else {
  //       showSnackBar(context, res);
  //     }
  //   } catch (err) {
  //     showSnackBar(context, err.toString());
  //     setState(() => isLoading = false);
  //   }
  // }
  void postImage(String uid, String username, String profImage) async {
    if (_file == null) return;
    setState(() => isLoading = true);

    try {
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );

      if (res == "success") {
        if (mounted) showSnackBar(context, 'Posted!');
        clearImage();
      } else {
        if (mounted) showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void clearImage() => setState(() => _file = null);

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const mockUser = {
      'uid': 'test_uid',
      'username': 'Test User',
      'photoUrl': 'https://via.placeholder.com/150',
    };
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.close, color: Colors.white70),
        //   onPressed: () => Navigator.pop(context),
        // ),
        leading: _file != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: clearImage,
            )
          : null,
        title: const Text('Create a post', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            // onPressed: _descriptionController.text.isEmpty && _file == null
            //     ? null
            //     : postImage,
            onPressed: (_descriptionController.text.isEmpty && _file == null)
                ? null
                : () => postImage(
                      mockUser['uid']!,
                      mockUser['username']!,
                      mockUser['photoUrl']!,
                    ),
            child: Text(
              "Post",
              style: TextStyle(
                color: (_descriptionController.text.isEmpty && _file == null)
                    ? Colors.grey
                    : Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0.0)),
            const Divider(),
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "Anyone",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.white70),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Share your thoughts...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_file != null)
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: MemoryImage(_file!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.image_outlined,
                    color: Colors.white70,
                    size: 26,
                  ),
                  onPressed: () => _selectImage(context),
                ),
                // TextButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.auto_awesome,
                //     color: Colors.amberAccent,
                //   ),
                //   label: const Text(
                //     "Rewrite with AI",
                //     style: TextStyle(color: Colors.amberAccent),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
