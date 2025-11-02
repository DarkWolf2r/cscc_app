import 'dart:io';
import 'package:cscc_app/features/project/projects_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddProjectScreen extends ConsumerStatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends ConsumerState<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _linkCtrl = TextEditingController();
  String department = 'Dev';

  List<File> images = [];
  List<File> videos = [];
  bool isLoading = false;

  final picker = ImagePicker();

  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() => images = picked.map((e) => File(e.path)).toList());
    }
  }

  Future<void> pickVideos() async {
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => videos.add(File(picked.path)));
    }
  }

  Future<void> uploadProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await ref
          .read(projectServiceProvider)
          .uploadProject(
            title: _titleCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            department: department,
            images: images,
            videos: videos,
            senderName: "Club Member",
            senderImage:
                "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
            link: _linkCtrl.text.trim().isEmpty ? null : _linkCtrl.text.trim(),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project uploaded successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Project")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: "Title"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter title" : null,
                    ),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter description" : null,
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: department,
                      items: ['Dev', 'Security', 'Robotics', 'Communication']
                          .map(
                            (d) => DropdownMenuItem(value: d, child: Text(d)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => department = val!),
                      decoration: const InputDecoration(
                        labelText: "Department",
                      ),
                    ),
                    TextFormField(
                      controller: _linkCtrl,
                      decoration: const InputDecoration(
                        labelText: "Project Link (optional)",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: pickImages,
                      icon: const Icon(Icons.image),
                      label: Text("Select Images (${images.length})"),
                    ),
                    ElevatedButton.icon(
                      onPressed: pickVideos,
                      icon: const Icon(Icons.video_library),
                      label: Text("Select Videos (${videos.length})"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: uploadProject,
                      child: const Text("Upload Project"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
