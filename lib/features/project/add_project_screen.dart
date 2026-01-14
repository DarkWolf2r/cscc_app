import 'dart:io';

import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/widgets/my_text_field.dart';
import 'package:cscc_app/features/auth/provider/providers.dart';
import 'package:cscc_app/features/project/projects_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
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
            senderName: ref.read(currentUserProvider).value!.username,
            senderImage: ref.read(currentUserProvider).value!.profilePic!,

            link: _linkCtrl.text.trim().isEmpty ? null : _linkCtrl.text.trim(),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Project uploaded successfully"),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("Add Project")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hintText: 'Title',
                      labelText: "Title",
                      obscureText: false,
                      prefixIcon: Icons.text_fields,
                      contoller: _titleCtrl,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter title" : null,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      contoller: _descCtrl,
                      hintText: "Decription",
                      labelText: "Description",
                      obscureText: false,
                      prefixIcon: Icons.description,
                      maxLines: 5,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter description" : null,
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      borderRadius: BorderRadius.circular(30),
                      initialValue: department,
                      items: ['Dev', 'Security', 'Robotics', 'Communication']
                          .map(
                            (d) => DropdownMenuItem(value: d, child: Text(d)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => department = val!),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: primaryColor),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primaryColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        labelText: "Department",
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      labelText: "Project Link",
                      obscureText: false,
                      prefixIcon: Iconsax.link,
                      hintText: "Project Link (Optional)",
                      contoller: _linkCtrl,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Note : Please Select all Images and Videos in one Time !",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.inverseSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: pickImages,
                      icon: const Icon(Icons.image),
                      label: Text("Select Images (${images.length})"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: pickVideos,
                      icon: const Icon(Icons.video_library),
                      label: Text("Select Videos (${videos.length})"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        minimumSize: const Size(double.infinity, 50),
                      ),
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
