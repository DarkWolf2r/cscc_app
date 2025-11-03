import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/features/screens/add_post_screen.dart';
import 'package:cscc_app/features/screens/animated_list_wrapper.dart';
import 'package:cscc_app/features/screens/filter_bottom_sheet.dart';
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

  List<String> selectedDepartments = [];
  List<String> selectedPostTypes = [];
  String selectedVisibility = "Everyone";

  bool _matchesFilter(Map<String, dynamic> post) {
    bool deptOk =
        selectedDepartments.isEmpty ||
        selectedDepartments.contains(post['department']);
    bool typeOk =
        selectedPostTypes.isEmpty || selectedPostTypes.contains(post['type']);
    bool visOk =
        selectedVisibility == "Everyone" ||
        post['visibility']?.toLowerCase() == "bureau";

    return deptOk && typeOk && visOk;
  }

  void _goToMessages() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Query postsQuery = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true);

    if (selectedDepartments.isNotEmpty) {
      postsQuery = postsQuery.where('department', whereIn: selectedDepartments);
    }

    if (selectedPostTypes.isNotEmpty) {
      postsQuery = postsQuery.where('type', whereIn: selectedPostTypes);
    }

    if (selectedVisibility == "Bureau Members Only") {
      postsQuery = postsQuery.where('visibility', isEqualTo: 'bureau');
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: false,
      body: Container(
        height: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            // ---- Feed Page ----
            Container(
              color: primaryColor,
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
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          final result = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const FilterBottomSheet(),
                          );

                          if (result != null) {
                            setState(() {
                              selectedDepartments = List<String>.from(
                                result['departments'],
                              );
                              selectedPostTypes = List<String>.from(
                                result['types'],
                              );
                              selectedVisibility = result['visibility'];
                            });
                          }
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        tooltip: "Reset filters",
                        onPressed: () {
                          setState(() {
                            selectedDepartments.clear();
                            selectedPostTypes.clear();
                            selectedVisibility = "Everyone";
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Filters reset to default"),
                              duration: Duration(seconds: 1),
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
                        ),
                      ),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .orderBy('datePublished', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          // IMPORTANT
                          // if (snapshot.connectionState ==
                          //         ConnectionState.waiting &&
                          //     (snapshot.data == null ||
                          //         snapshot.data!.docs.isEmpty)) {
                          //   return const SizedBox(
                          //     height: 300,
                          //     child: Center(
                          //       child: CircularProgressIndicator(
                          //         strokeWidth: 2,
                          //       ),
                          //     ),
                          //   );
                          // }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              color: Theme.of(context).colorScheme.surface,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          }

                          final docs = (snapshot.data?.docs ?? [])
                              .map((d) => d.data() as Map<String, dynamic>)
                              .toList();

                          if (docs.isEmpty) {
                            return const Center(
                              child: Text(
                                "No posts yet",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          // docs.sort((a, b) {
                          //   bool aMatch = _matchesFilter(a);
                          //   bool bMatch = _matchesFilter(b);

                          //   if (aMatch && !bMatch) return -1;
                          //   if (!aMatch && bMatch) return 1;
                          //   return 0;
                          // });
                          final sortedDocs = [...docs];
                          sortedDocs.sort((a, b) {
                            bool aMatch = _matchesFilter(a);
                            bool bMatch = _matchesFilter(b);
                            if (aMatch && !bMatch) return -1;
                            if (!aMatch && bMatch) return 1;
                            return 0;
                          });
                          return AnimatedListWrapper(
                            key: ValueKey(
                              selectedDepartments.join(',') +
                                  selectedPostTypes.join(',') +
                                  selectedVisibility,
                            ),
                            docs: sortedDocs,
                          );

                          // return ListView.builder(
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   shrinkWrap: true,
                          //   itemCount: docs.length,
                          //   itemBuilder: (ctx, index) =>
                          //       PostCard(snap: docs[index]),
                          // );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---- Messages Page ----
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: const MessagesScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
