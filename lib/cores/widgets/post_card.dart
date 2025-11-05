import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/widgets/like_animation.dart';
import 'package:cscc_app/cores/widgets/view_profile.dart';
import 'package:cscc_app/features/profile/profile_page.dart';
import 'package:cscc_app/features/screens/comments_screen.dart';
import 'package:cscc_app/features/screens/edit_post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cscc_app/cores/firestore_methods.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    checkIfFollowing();
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Post deleted successfully")));
  }

  Future<void> handleReport(String postId, String reportedUserId) async {
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'reportedUserId': reportedUserId,
        'postId': postId,
        'reporterId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now(),
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Reported successfully")));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> handleUnfollow(
    String currentUserId,
    String profileUserId,
  ) async {
    await FireStoreMethods().followUser(currentUserId, profileUserId);
    setState(() {
      isFollowing = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Unfollowed successfully")));
  }

  void showPostOptions(
    BuildContext context,
    String postOwnerId,
    String postId,
  ) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isMyPost = currentUserId == postOwnerId;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
              if (isMyPost) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Edit"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPostScreen(postId: postId),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    deletePost(postId);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.report, color: Colors.red),
                  title: const Text(
                    "Report",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    handleReport(postId, postOwnerId);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_remove),
                  title: const Text("Unfollow"),
                  onTap: () {
                    Navigator.pop(context);
                    handleUnfollow(currentUserId, postOwnerId);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstagramStyleImages(List<String> postUrls) {
    final PageController _pageController = PageController();
    int currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: postUrls.length,
                onPageChanged: (index) => setState(() => currentPage = index),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      postUrls[index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

            if (postUrls.length != 1)
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    '${currentPage + 1}/${postUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            if (postUrls.length != 1)
              Positioned(
                bottom: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(postUrls.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: currentPage == index ? 16 : 6,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  }

  void checkIfFollowing() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final profileUserId = widget.snap['uid'];

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    final followingList = List<String>.from(doc['following'] ?? []);
    setState(() {
      isFollowing = followingList.contains(profileUserId);
    });
  }

  // void openProfile(BuildContext context, String profileUid) async {
  //   try {
  //     final docSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(profileUid)
  //         .get();

  //     if (!docSnap.exists || docSnap.data() == null) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text("User not found")));
  //       return;
  //     }

  //     final data = docSnap.data()! as Map<String, dynamic>;

  //     final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  //     if (data['email'] != null && data['email'] != currentUserEmail) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text("User email mismatch")));
  //       return;
  //     }

  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => ViewProfilePage(userId: profileUid)),
  //     );
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Error fetching user info")));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final snap = widget.snap;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final profileUserId = snap['uid'];

    bool isLiked = snap['likes'].contains(currentUserId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: primaryColor.withOpacity(0.3), width: 0.8),
      ),
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header (User info + follow + options = type + title)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      final currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      final postUserId = snap['uid'];

                      if (currentUserId == postUserId) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewProfilePage(userId: postUserId),
                          ),
                        );
                        // final postUserId = snap['uid'];

                        // openProfile(context, postUserId);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(snap['profImage']),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snap['username'],
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          timeago.format(snap['datePublished'].toDate()),
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (snap['uid'] != currentUserId)
                    TextButton(
                      onPressed: () async {
                        final result = await FireStoreMethods().followUser(
                          currentUserId,
                          profileUserId,
                        );
                        setState(() {
                          isFollowing = result;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFollowing
                                  ? 'Unfollowed'
                                  : 'Followed successfully',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: isFollowing
                            ? Colors.white
                            : primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(
                            color: primaryColor.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Text(
                        isFollowing ? 'Unfollow' : 'Follow',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: isFollowing ? Colors.black : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  IconButton(
                    icon: const Icon(Icons.more_vert_sharp),
                    onPressed: () =>
                        showPostOptions(context, snap['uid'], snap['postId']),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 1),

            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title with small left padding
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Flexible(
                    child: Text(
                      snap['title'],
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // Type chip (same design as before)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    snap['type'].toString().toUpperCase(),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // --- Images
            if (snap['postUrls'] != null &&
                (snap['postUrls'] as List).isNotEmpty)
              _buildInstagramStyleImages(List<String>.from(snap['postUrls'])),

            // --- Description (if exists)
            if (snap['description'] != null &&
                snap['description'].toString().trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                child: Text(
                  snap['description'],
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ),
              ),

            const SizedBox(height: 4),

            // --- Like + Comment row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(
                    "${snap['likes'].length}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CommentsScreen(postId: snap['postId']),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 2),
                  Text(
                    "$commentLen",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}