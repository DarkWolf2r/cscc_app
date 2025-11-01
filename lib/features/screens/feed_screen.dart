import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/widgets/post_card.dart';
import 'package:cscc_app/features/screens/add_post_screen.dart';
// import 'package:cscc_app/features/screens/draggable_feed_wrapper_screen.dart';
import 'package:cscc_app/features/screens/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();

  void _goToMessages() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // remove any backgroundColor here
      backgroundColor: primaryColor,
      body: PageView(

        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          // ---- Feed Page ----
          Container(
            color: primaryColor,
            // child: DraggableFeed(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: primaryColor,
                  floating: true,
                  snap: true,
                  elevation: 0,
                  title: Text(
                    "CSCC",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_box_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FractionallySizedBox(
                            heightFactor: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 35),
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top,
                              ),
                              color: Theme.of(context).colorScheme.surface,
                              child: const AddPostScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.messenger_outline,
                        color: Colors.white,
                      ),
                      onPressed: _goToMessages,
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        // topRight: Radius.circular(14),
                      ),
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('datePublished', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              "No posts yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) =>
                              PostCard(snap: snapshot.data!.docs[index].data()),
                        );
                      },
                    ),
                  ),
                ),
                
              ],
            ),
            // ),
          ),

          // ---- Messages Page ----
          Container(
            color: Theme.of(
              context,
            ).colorScheme.surface, // make sure background is solid
            child: const MessagesScreen(),
          ),
        ],
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/widgets/post_card.dart';
// import 'package:cscc_app/features/screens/messages_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class FeedScreen extends StatefulWidget {
//   const FeedScreen({Key? key}) : super(key: key);

//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   void _goToMessages() {
//     _pageController.animateToPage(
//       1,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: PageView(
//         controller: _pageController,
//         onPageChanged: (page) {
//           setState(() {
//             _currentPage = page;
//           });
//         },
//         children: [
//           CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 backgroundColor: primaryColor,
//                 floating: true,
//                 snap: true,
//                 elevation: 0,
//                 // title: SvgPicture.asset(
//                 //   'assets/ic_instagram.svg',
//                 //   color: primaryColor,
//                 //   height: 32,
//                 // ),
//                 title: Text(
//                   "CSCC",
//                   style: GoogleFonts.lato(
//                     textStyle: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.w900,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 actions: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.favorite_border,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {},
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.messenger_outline,
//                       color: Colors.white,
//                     ),
//                     onPressed: _goToMessages,
//                   ),
//                 ],
//               ),

//               // -------- Posts List --------
//               SliverToBoxAdapter(
//                 child: Container(
//                   padding: const EdgeInsets.only(
//                     bottom: 15,
//                     right: 10,
//                     left: 10,
//                   ),
//                   // color: Theme.of(context).colorScheme.surface,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.surface,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(14),
//                       topRight: Radius.circular(14),
//                     ),
//                   ),
//                   child: StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection('posts')
//                         .orderBy('datePublished', descending: true)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       // (
//                       //   context,
//                       //   AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                       //   snapshot,
//                       // ) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             "No posts yet",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         );
//                       }

//                       return ListView.builder(
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (ctx, index) =>
//                             PostCard(snap: snapshot.data!.docs[index].data()),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // ---- Messages Page ----
//           const MessagesScreen(),
//         ],
//       ),
//     );
//   }
// }
