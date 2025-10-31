import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/features/auth/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cscc_app/features/auth/model/user_model.dart';
import 'package:cscc_app/cores/firestore_methods.dart';
import 'package:cscc_app/cores/widgets/comment_card.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> postComment(
    String uid,
    String username,
    String? profilePic,
  ) async {
    if (_commentController.text.trim().isEmpty) return;

    final res = await FireStoreMethods().postComment(
      widget.postId,
      _commentController.text.trim(),
      uid,
      username,
      profilePic ?? '',
    );

    if (res == 'success') {
      _commentController.clear();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .orderBy('datePublished', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final comments = snapshot.data!.docs;

              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (ctx, i) => CommentCard(snap: comments[i].data()),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
      bottomNavigationBar: userState.when(
        data: (user) {
          if (user == null) return const SizedBox();

          return SafeArea(
            child: Container(
              height: kToolbarHeight,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic ?? ''),
                    radius: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${user.username}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => postComment(
                      user.userId,
                      user.username,
                      user.profilePic,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/features/auth/model/user_model.dart';
// import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/firestore_methods.dart';
// import 'package:cscc_app/cores/widgets/comment_card.dart';
// // import 'package:cscc_app/models/user.dart';
// // import 'package:cscc_app/providers/user_provider.dart';
// import 'package:cscc_app/cores/utils.dart';

// class CommentsScreen extends StatefulWidget {
//   final String postId;
//   const CommentsScreen({Key? key, required this.postId}) : super(key: key);

//   @override
//   State<CommentsScreen> createState() => _CommentsScreenState();
// }

// class _CommentsScreenState extends State<CommentsScreen> {
//   final TextEditingController _commentController = TextEditingController();

//   Future<void> _postComment({
//     required String uid,
//     required String name,
//     required String profilePic,
//   }) async {
//     if (_commentController.text.trim().isEmpty) return;

//     try {
//       String res = await FireStoreMethods().postComment(
//         widget.postId,
//         _commentController.text.trim(),
//         uid,
//         name,
//         profilePic,
//       );

//       if (res != 'success' && mounted) {
//         showSnackBar(context, res);
//       }

//       setState(() => _commentController.clear());
//     } catch (e) {
//       if (mounted) showSnackBar(context, e.toString());
//     }
//   }

//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final User user = Provider.of<UserProvider>(context).getUser;
//     final UserModel user = Provider.of<UserProvider>(context).getUser;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('Comments'),
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .doc(widget.postId)
//             .collection('comments')
//             .orderBy('datePublished', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text('No comments yet. Be the first to comment!'),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (ctx, index) {
//               final commentData = snapshot.data!.docs[index];
//               return CommentCard(snap: commentData);
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           margin: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           height: kToolbarHeight,
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(user.photoUrl),
//                 radius: 18,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: TextField(
//                   controller: _commentController,
//                   decoration: InputDecoration(
//                     hintText: 'Comment as ${user.username}',
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => _postComment(
//                   uid: user.uid,
//                   name: user.username,
//                   profilePic: user.photoUrl,
//                 ),
//                 child: const Text(
//                   'Post',
//                   style: TextStyle(
//                     color: Colors.blueAccent,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
