// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/widgets/container_tile.dart';
// import 'package:cscc_app/cores/widgets/my_text_field.dart';
// import 'package:cscc_app/cores/widgets/post_card.dart';
// import 'package:cscc_app/features/auth/provider/providers.dart';
// import 'package:cscc_app/features/events/event_details_screen.dart';
// import 'package:cscc_app/features/events/event_service.dart';
// import 'package:cscc_app/features/project/project_model.dart';
// import 'package:cscc_app/features/project/projects_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class EventScreen extends ConsumerStatefulWidget {
//   const EventScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<EventScreen> createState() => _EventScreenState();
// }

// class _EventScreenState extends ConsumerState<EventScreen> {
//   final dateController = TextEditingController();
//   final placeController = TextEditingController();
//   String place = "Local";
//   String date = "DD/MM/YYYY";

//   @override
//   Widget build(BuildContext context) {
//     final eventPostsAsync = ref.watch(eventPostsProvider);
//     final user = ref.watch(currentUserProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Events",
//           style: GoogleFonts.lato(
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),

//         foregroundColor: Theme.of(context).colorScheme.surface,
//         backgroundColor: primaryColor,
//       ),
//       extendBodyBehindAppBar: false,
//       body: Column(
//         children: [
//           Expanded(
//             child: eventPostsAsync.when(
//               loading: () {
//                 return Skeletonizer(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ProjectCard(
//                         project: ProjectModel(
//                           title: "title",
//                           description: "description",
//                           department: "department",
//                           senderName: "senderName",
//                           senderImage: "senderImage",
//                         ),
//                       ),
//                       ProjectCard(
//                         project: ProjectModel(
//                           title: "title",
//                           description: "description",
//                           department: "department",
//                           senderName: "senderName",
//                           senderImage: "senderImage",
//                         ),
//                       ),

//                       ProjectCard(
//                         project: ProjectModel(
//                           title: "title",
//                           description: "description",
//                           department: "department",
//                           senderName: "senderName",
//                           senderImage: "senderImage",
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               data: (data) {
//                 if (data.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No posts yet",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   );
//                 }
//                 return ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: data.length,
//                   itemBuilder: (ctx, index) {
//                     final event = data[index];
//                     return EventInfoExpansion(
//                       title: event['title'],
//                       description: event['description'],
//                       place: place,
//                       date: date,
//                       teams: [
//                         {
//                           'name': 'Logistics',
//                           'members': [
//                             'Ali Bensalem',
//                             'Sara Amiri',
//                             'Omar Lounis',
//                           ],
//                         },
//                         {
//                           'name': 'Communication',
//                           'members': ['Fatima Karim', 'Ahmed Fethi'],
//                         },
//                         {
//                           'name': 'Development',
//                           'members': ['Yacine Brahimi', 'Meriem Taha'],
//                         },
//                       ],
//                     );
//                     // return ExpansionTile(
//                     //   leading: Icon(Icons.event_available),
//                     //   title: Text(
//                     //     event['title'],
//                     //     style: TextStyle(
//                     //       fontSize: 30,
//                     //       fontWeight: FontWeight.bold,
//                     //       color: primaryColor,
//                     //     ),
//                     //   ),
//                     //   children: [
//                     //     Text(event['description']),
//                     //     IconButton(
//                     //       onPressed: () {
//                     //         showBottomSheet(
//                     //           context: context,
//                     //           builder: (context) => Container(
//                     //             height: 100,
//                     //             width: double.infinity,
//                     //             color: Colors.red,
//                     //           ),
//                     //         );
//                     //       },
//                     //       icon: Icon(Iconsax.info_circle),
//                     //     ),
//                     //     //   MyTextField(prefixIcon: , labelText: "labelText", contoller: , hintText: "" , obscureText: false)
//                     //   ],
//                     // );
//                   },
//                 );
//               },
//               error: (error, stackTrace) =>
//                   Center(child: Text("Error : ${error.toString()}")),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class EventInfoExpansion extends StatelessWidget {
//   final String title;
//   final String description;
//   final String place;
//   final String date;
//   final List<Map<String, dynamic>>
//   teams; // e.g. [{'name': 'Logistics', 'members': ['Ali', 'Sara']}]

//   const EventInfoExpansion({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.place,
//     required this.date,
//     required this.teams,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           dividerColor: Colors.transparent,
//           splashColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//         ),
//         child: ExpansionTile(
//           tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           childrenPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 10,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           collapsedShape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           leading: CircleAvatar(
//             radius: 20,
//             backgroundColor: Colors.blue.withOpacity(0.1),
//             child: const Icon(Icons.event, color: Colors.blueAccent),
//           ),
//           title: Text(
//             title,
//             style: GoogleFonts.lato(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.blueAccent,
//             ),
//           ),
//           subtitle: Text(
//             description,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600]),
//           ),
//           children: [
//             const Divider(thickness: 1),
//             ListTile(
//               leading: const Icon(Icons.place, color: Colors.blueAccent),
//               title: const Text("Place"),
//               subtitle: Text(place, style: GoogleFonts.lato(fontSize: 14)),
//             ),
//             ListTile(
//               leading: const Icon(
//                 Icons.calendar_today,
//                 color: Colors.blueAccent,
//               ),
//               title: const Text("Date"),
//               subtitle: Text(date, style: GoogleFonts.lato(fontSize: 14)),
//             ),
//             ExpansionTile(
//               tilePadding: const EdgeInsets.symmetric(horizontal: 8),
//               leading: const Icon(Icons.groups, color: Colors.blueAccent),
//               title: const Text(
//                 "Teams",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               children: teams.isEmpty
//                   ? [
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text(
//                           "No teams added yet",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ]
//                   : teams
//                         .map(
//                           (team) => ExpansionTile(
//                             leading: const Icon(
//                               Icons.group_work_outlined,
//                               color: Colors.green,
//                             ),
//                             title: Text(
//                               team['name'],
//                               style: GoogleFonts.lato(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             children: (team['members'] as List<dynamic>)
//                                 .map(
//                                   (member) => ListTile(
//                                     leading: const Icon(Icons.person_outline),
//                                     title: Text(member.toString()),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         )
//                         .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/features/auth/provider/providers.dart';
import 'package:cscc_app/features/events/screens/edit_event_screen.dart';
import 'package:cscc_app/features/events/screens/event_chat_screen.dart';
import 'package:cscc_app/features/events/repo/event_service.dart';
import 'package:cscc_app/features/events/screens/events_teams_screen.dart';
import 'package:cscc_app/features/project/project_model.dart';
import 'package:cscc_app/features/project/projects_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// --- EVENT CARD WIDGET ---
class EventCard extends StatelessWidget {
  final String eventId;
  final String title;
  final String description;
  final String? place;
  final String? date;
  final String userId;
  final String userName;
  final String profilePic;
  final String userType;

  const EventCard({
    super.key,
    required this.eventId,
    required this.title,
    required this.description,
    this.place,
    this.date,
    required this.userId,
    required this.userName,
    required this.profilePic,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.lato(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            if (place != null)
              Text(
                "📍 Place: $place",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            if (date != null)
              Text(
                "📅  Date: $date",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventChatScreen(
                        eventId: eventId,
                        userId: userId,
                        userName: userName,
                        profilePic: profilePic,
                        userType: userType,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                label: Text(
                  "Open Chat",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- EVENT SCREEN ---
class EventScreen extends ConsumerWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventPostsAsync = ref.watch(eventPostsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: GoogleFonts.lato(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: eventPostsAsync.when(
        loading: () {
          return Skeletonizer(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (_, __) => ProjectCard(
                project: ProjectModel(
                  title: "Loading...",
                  description: "Loading...",
                  department: "",
                  senderName: "",
                  senderImage: "",
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) =>
            Center(child: Text("Error: ${error.toString()}")),
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text(
                "No events yet",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              final post = data[index];
              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventTeamsScreen(
                        eventId: post['id'] ?? post['postId'] ?? '', // Firestore doc ID
                        userType: currentUser.value!.type, // from user model
                      ),
                    ),
                  ),
                child: EventCard(
                  eventId: post['id'] ?? post['postId'] ?? '',
                  title: post['title'] ?? 'Untitled',
                  description: post['description'] ?? '',
                  place: post['place'],
                  date: post['date'],
                  userId: currentUser.value!.userId,
                  userName: currentUser.value!.username,
                  profilePic: currentUser.value!.profilePic!,
                  userType: currentUser.value!.type,
                ),
              );
            },
          );
        },
      ),
    );
  }
}


                  //    Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditEventScreen(
                  //       eventId: post['id'] ?? post['postId'] ?? '',
                  //       eventData: post,
                  //     ),
                  //   ),
                  // ) ;