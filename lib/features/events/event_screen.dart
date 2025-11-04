import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/widgets/post_card.dart';
import 'package:cscc_app/features/events/event_service.dart';
import 'package:cscc_app/features/project/project_model.dart';
import 'package:cscc_app/features/project/projects_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventScreen extends ConsumerStatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {

  
  @override
  Widget build(BuildContext context) {
    final eventPostsAsync = ref.watch(eventPostsProvider);
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
        
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: primaryColor,
      ),
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          Expanded(
            child: eventPostsAsync.when(
              loading: () {
                return Skeletonizer(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      ProjectCard(
                        project: ProjectModel(
                          title: "title",
                          description: "description",
                          department: "department",
                          senderName: "senderName",
                          senderImage: "senderImage",
                        ),
                      ),
                      
                      ProjectCard(
                        project: ProjectModel(
                          title: "title",
                          description: "description",
                          department: "department",
                          senderName: "senderName",
                          senderImage: "senderImage",
                        ),
                      ),
                      ProjectCard(
                        project: ProjectModel(
                          title: "title",
                          description: "description",
                          department: "department",
                          senderName: "senderName",
                          senderImage: "senderImage",
                        ),
                      ),
                    ],
                  ),
                );
              },
              data: (data) {
                if (data.isEmpty) {
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
                   itemCount: data.length,
                  itemBuilder: (ctx, index) =>
                      PostCard(snap: data[index]),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text("Error : ${error.toString()}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
