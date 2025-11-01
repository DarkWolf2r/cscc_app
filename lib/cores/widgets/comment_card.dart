import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/firestore_methods.dart';
import 'package:cscc_app/cores/widgets/like_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late bool isLiked;
  late String currentUserId;
  late List likes;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    likes = (widget.snap['likes'] ?? []) as List<dynamic>;
    isLiked = likes.contains(currentUserId);
  }

  void _showCommentOptions() {
    final isMyComment = widget.snap['uid'] == currentUserId;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                if (isMyComment) ...[
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text("Edit"),
                    onTap: () {
                      Navigator.pop(context);
                      _editCommentDialog();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await FireStoreMethods().deleteComment(
                        widget.snap['postId'],
                        widget.snap['commentId'],
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Comment deleted")),
                        );
                      }
                    },
                  ),
                ] else
                  ListTile(
                    leading: const Icon(Icons.report, color: Colors.red),
                    title: const Text(
                      "Report",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Comment reported successfully"),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editCommentDialog() {
    final controller = TextEditingController(text: widget.snap['text']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Comment"),
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: "Update your comment...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FireStoreMethods().editComment(
                widget.snap['postId'],
                widget.snap['commentId'],
                controller.text.trim(),
              );
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snap = widget.snap;
    final profilePic = snap['profilePic'] ?? '';
    final name = snap['name'] ?? 'Unknown';
    final text = snap['text'] ?? '';
    final timestamp = snap['datePublished'];
    final likes = (snap['likes'] ?? []) as List<dynamic>;

    return GestureDetector(
      onLongPress: _showCommentOptions, // detect long press here
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture
            CircleAvatar(
              backgroundImage: profilePic.isNotEmpty
                  ? NetworkImage(profilePic)
                  : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              radius: 18,
            ),
            const SizedBox(width: 12),

            // Comment text area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timestamp != null
                            ? timeago.format((timestamp as Timestamp).toDate())
                            : '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  // Comment text below
                  if (text.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Heart button + like count
            Column(
              children: [
                LikeAnimation(
                  isAnimating: isLiked,
                  smallLike: true,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked
                          ? Colors.red
                          : Colors.grey.withOpacity(0.7),
                      size: 18,
                    ),
                    onPressed: () async {
                      await FireStoreMethods().likeComment(
                        snap['postId'],
                        snap['commentId'],
                        currentUserId,
                        likes,
                      );
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                  ),
                ),
                if (likes.isNotEmpty)
                  Text(
                    '${likes.length}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      height: 0.8,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/cores/firestore_methods.dart';
// import 'package:cscc_app/cores/widgets/like_animation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class CommentCard extends StatefulWidget {
//   final Map<String, dynamic> snap;
//   const CommentCard({Key? key, required this.snap}) : super(key: key);

//   @override
//   State<CommentCard> createState() => _CommentCardState();
// }

// class _CommentCardState extends State<CommentCard> {
//   late bool isLiked;
//   late String currentUserId;
//   late List likes;

//   @override
//   void initState() {
//     super.initState();
//     currentUserId = FirebaseAuth.instance.currentUser!.uid;
//     likes = (widget.snap['likes'] ?? []) as List<dynamic>;
//     isLiked = likes.contains(currentUserId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final snap = widget.snap;
//     final profilePic = snap['profilePic'] ?? '';
//     final name = snap['name'] ?? 'Unknown';
//     final text = snap['text'] ?? '';
//     final timestamp = snap['datePublished'];
//     final likes = (snap['likes'] ?? []) as List<dynamic>;

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Profile picture
//           CircleAvatar(
//             backgroundImage: profilePic.isNotEmpty
//                 ? NetworkImage(profilePic)
//                 : const AssetImage('assets/default_avatar.png')
//                       as ImageProvider,
//             radius: 18,
//           ),
//           const SizedBox(width: 12),

//           // Comment text area
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       name,
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(
//                           context,
//                         ).colorScheme.onSurface.withOpacity(0.9),
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       timestamp != null
//                           ? timeago.format((timestamp as Timestamp).toDate())
//                           : '',
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Comment text below
//                 if (text.isNotEmpty) ...[
//                   const SizedBox(height: 3),
//                   Text(
//                     text,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       fontSize: 14,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           // Heart button + like count
//           Column(
//             children: [
//               LikeAnimation(
//                 isAnimating: isLiked,
//                 smallLike: true,
//                 child: IconButton(
//                   visualDensity: VisualDensity.compact,
//                   icon: Icon(
//                     isLiked ? Icons.favorite : Icons.favorite_border,
//                     color: isLiked ? Colors.red : Colors.grey.withOpacity(0.7),
//                     size: 18,
//                   ),
//                   onPressed: () async {
//                     await FireStoreMethods().likeComment(
//                       snap['postId'],
//                       snap['commentId'],
//                       currentUserId,
//                       likes,
//                     );
//                     setState(() {
//                       isLiked = !isLiked;
//                     });
//                   },
//                 ),
//               ),
//               if (likes.isNotEmpty)
//                 Text(
//                   '${likes.length}',
//                   style: const TextStyle(
//                     color: Colors.grey,
//                     fontSize: 11,
//                     height: 0.8,
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
