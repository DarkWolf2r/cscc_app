import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/features/project/add_project_screen.dart';
import 'package:cscc_app/features/project/project_model.dart';
import 'package:cscc_app/features/project/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

final projectServiceProvider = Provider((ref) => ProjectService());
final projectsProvider = StreamProvider<List<ProjectModel>>(
  (ref) => ref.read(projectServiceProvider).getProjects(),
);

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  String selectedDepartment = 'All';
  final departments = ['All', 'Dev', 'Security', 'Robotics', 'Communication'];

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Projects",
          style: GoogleFonts.lato(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // Department filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: departments.map((dep) {
                final isSelected = selectedDepartment == dep;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
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

          // Projects list
          Expanded(
            child: projectsAsync.when(
              data: (projects) {
                final filtered = selectedDepartment == 'All'
                    ? projects
                    : projects
                          .where((p) => p.department == selectedDepartment)
                          .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No projects yet.'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) =>
                      ProjectCard(project: filtered[i]),
                );
              },
              loading: () => Skeletonizer(
                child: Column(
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
              ), //const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProjectScreen()),
          ),
          icon: const Icon(Iconsax.add),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Department & Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(project.department)),
                Text(
                  project.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(project.description),

            const SizedBox(height: 10),

            // Images
            if (project.imageUrls.isNotEmpty)
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: project.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          project.imageUrls[index],
                          width: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            final isLoading = loadingProgress != null;

                            if (isLoading) {
                              return Skeletonizer(
                                enabled: true,
                                child: Container(
                                  width: 200,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            } else {
                              // ✅ When image is done loading
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: child,
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 200,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.redAccent,
                                ),
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Videos (just thumbnails or links for now)
            if (project.videoUrls.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: project.videoUrls.map((v) {
                    return TextButton.icon(
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(v))) {
                          await launchUrl(
                            Uri.parse(v),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text("Watch video"),
                    );
                  }).toList(),
                ),
              ),

            // GitHub link
            if (project.link != null)
              TextButton.icon(
                onPressed: () async {
                  final url = Uri.parse(project.link!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.link),
                label: const Text("View Project"),
              ),

            // const Divider(),
            const SizedBox(height: 10),

            // Sender info
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(project.senderImage),
                  radius: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  project.senderName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
