import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/features/auth/model/user_model.dart';
import 'package:cscc_app/features/auth/provider/providers.dart';
import 'package:cscc_app/features/events/screens/event_chat_screen.dart';
import 'package:cscc_app/features/events/repo/event_service.dart';
import 'package:cscc_app/features/events/screens/event_details_screen.dart';
import 'package:cscc_app/features/project/project_model.dart';
import 'package:cscc_app/features/project/projects_screen.dart';
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
    final UserModel? currentUser = ref.watch(currentUserProvider).value;

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
                      builder: (_) => EventDetailsScreen(
                        eventId: post['id'] ?? post['postId'] ?? '', // Firestore doc ID
                        userName: currentUser.username,
                        userId: currentUser.userId,
                        profilePic:currentUser.profilePic! ,
                        userType: currentUser.type, // from user model
                      ),
                    ),
                  ),
                child: EventCard(
                  eventId: post['id'] ?? post['postId'] ?? '',
                  title: post['title'] ?? 'Untitled',
                  description: post['description'] ?? '',
                  place: post['place'],
                  date: post['date'],
                  userId: currentUser!.userId,
                  userName: currentUser.username,
                  profilePic: currentUser.profilePic!,
                  userType: currentUser.type,
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