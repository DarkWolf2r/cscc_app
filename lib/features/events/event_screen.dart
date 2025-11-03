// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../services/post_service.dart';
// import '../models/post_model.dart';

// final postServiceProvider = Provider((ref) => PostService());
// final eventsProvider = StreamProvider<List<PostModel>>(
//   (ref) => ref.read(postServiceProvider).getEventPosts(),
// );

// class EventsScreen extends ConsumerWidget {
//   const EventsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final eventsAsync = ref.watch(eventsProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Events")),
//       body: eventsAsync.when(
//         data: (events) {
//           if (events.isEmpty) {
//             return const Center(child: Text("No events yet."));
//           }
//           return ListView.builder(
//             itemCount: events.length,
//             itemBuilder: (context, index) {
//               final event = events[index];
//               return ListTile(
//                 title: Text(event.title),
//                 subtitle: Text(event.description),
//               );
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text("Error: $e")),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/features/screens/add_post_screen.dart';
import 'package:cscc_app/features/screens/animated_list_wrapper.dart';
import 'package:cscc_app/features/screens/filter_bottom_sheet.dart';
import 'package:cscc_app/features/screens/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final PageController _pageController = PageController();

  List<String> selectedDepartments = [];
  String selectedVisibility = "Everyone";

  bool _matchesFilter(Map<String, dynamic> post) {
    bool deptOk =
        selectedDepartments.isEmpty ||
        selectedDepartments.contains(post['department']);

    bool visOk =
        selectedVisibility == "Everyone" ||
        post['visibility']?.toLowerCase() == "bureau";

    return deptOk && visOk;
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
        .orderBy('datePublished', descending: true)
        .where('type', isEqualTo: 'Event');

    if (selectedDepartments.isNotEmpty) {
      postsQuery = postsQuery.where('department', whereIn: selectedDepartments);
    }

    if (selectedVisibility == "Bureau Members Only") {
      postsQuery = postsQuery.where('visibility', isEqualTo: 'bureau');
    }
    String selectedDepartment = 'All';
    final departments = ['All', 'Dev', 'Security', 'Robotics', 'Communication'];
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
                      "EVENTS",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          child: Row(
                            children: departments.map((dep) {
                              final isSelected = selectedDepartment == dep;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: ChoiceChip(
                                  selectedColor: primaryColor,
                                  label: Text(dep),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() => selectedDepartment = dep);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
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
                                .where('type', isEqualTo: 'Event')
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
                                  .map((d) => d.data())
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
                      ],
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
