import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/widgets/follow_button.dart';
import 'package:cscc_app/cores/widgets/like_animation.dart';
import 'package:cscc_app/features/screens/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:cscc_app/cores/firestore_methods.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() => commentLen = snap.docs.length);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deletePost(String postId) async {
    await FireStoreMethods().deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    final snap = widget.snap;
    final currentUserId = "CURRENT_USER_ID";
    final profileUserId = snap['uid'];

    bool isLiked = snap['likes'].contains(currentUserId);
    bool isFollowing = false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(snap['profImage']),
            ),
            title: Text(
              snap['username'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat.yMMMd().format(snap['datePublished'].toDate()),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => deletePost(snap['postId']),
            ),
          ),

          // --- Follow Button ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FollowButton(
              text: isFollowing ? 'Unfollow' : 'Follow',
              backgroundColor: isFollowing ? Colors.white : Colors.blue,
              borderColor: Colors.grey,
              textColor: isFollowing ? Colors.black : Colors.white,
              onTap: () {
                FireStoreMethods().followUser(currentUserId, profileUserId);
                setState(() {
                  isFollowing = !isFollowing;
                });
              },
            ),
          ),

          // --- Image ---
          if (snap['postUrl'] != null && snap['postUrl'].toString().isNotEmpty)
            Image.network(
              snap['postUrl'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),

          // --- Like Button ---
          Row(
            children: [
              LikeAnimation(
                isAnimating: isLiked,
                smallLike: true,
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                      snap['postId'],
                      currentUserId,
                      snap['likes'],
                    );
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
              ),
              Text("${snap['likes'].length} likes"),
            ],
          ),

          // --- Description ---
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              snap['description'] ?? "",
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),

          // --- Comments Button ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommentsScreen(postId: snap['postId']),
                  ),
                );
              },
              child: Text('View all $commentLen comments'),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:cscc_app/cores/firestore_methods.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:intl/intl.dart';

// class PostCard extends StatefulWidget {
//   final Map<String, dynamic> snap;
//   const PostCard({Key? key, required this.snap}) : super(key: key);

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   bool isLikeAnimating = false;
//   int commentLen = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchCommentLen();
//   }

//   fetchCommentLen() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(widget.snap['postId'])
//           .collection('comments')
//           .get();
//       setState(() => commentLen = snap.docs.length);
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   deletePost(String postId) async {
//     await FireStoreMethods().deletePost(postId);
//   }

//   bool isLiked = snap['likes'].contains(currentUserId);

// LikeAnimation(
//   isAnimating: isLiked,
//   smallLike: true,
//   child: IconButton(
//     icon: Icon(
//       isLiked ? Icons.favorite : Icons.favorite_border,
//       color: isLiked ? Colors.red : Colors.grey,
//     ),
//     onPressed: () => FireStoreMethods().likePost(
//       snap['postId'],
//       currentUserId,
//       snap['likes'],
//     ),
//   ),
// ),


//   @override
//   Widget build(BuildContext context) {
//     final snap = widget.snap;

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       color: Theme.of(context).colorScheme.surface,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // --- Header ---
//           ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(snap['profImage']),
//             ),
//             title: Text(
//               snap['username'],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               DateFormat.yMMMd().format(snap['datePublished'].toDate()),
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.more_vert),
//               onPressed: () => deletePost(snap['postId']),
//             ),
//           ),

//           // --- Image (if exists) ---
//           if (snap['postUrl'] != null && snap['postUrl'].toString().isNotEmpty)
//             Image.network(
//               snap['postUrl'],
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 250,
//             ),

//           // --- Description ---
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               snap['description'] ?? "",
//               style: const TextStyle(fontSize: 15, height: 1.4),
//             ),
//           ),

//           // --- Footer (likes/comments) ---
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "${snap['likes'].length} likes",
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 TextButton( onPressed: () { Navigator.push( context, MaterialPageRoute( builder: (_) => CommentsScreen(postId: snap['postId']), ), ); }, child: Text('View all $commentLen comments'), )
//               ],
//             ),
//           ),

          
//         ],
//       ),
//     );
//   }
// }