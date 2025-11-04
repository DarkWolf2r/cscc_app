import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/firestore_methods.dart';
import 'package:cscc_app/cores/utils.dart';
import 'package:cscc_app/features/screens/full_screen_image_viewer.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  final String postId;

  const EditPostScreen({Key? key, required this.postId}) : super(key: key);

  @override
  ConsumerState<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _titleController = TextEditingController();

  List<Uint8List> _newFiles = [];
  List<String> _oldImageUrls = [];

  bool isLoading = true;
  String? username;
  String? profilePicUrl;
  String? uid;

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  Future<void> _loadPostData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (!doc.exists) return;

      final data = doc.data()!;
      _descriptionController.text = data['description'] ?? '';
      _oldImageUrls = List<String>.from(
        data['postUrls'] ?? [data['postUrl'] ?? ''],
      );
      uid = data['uid'];
      username = data['username'];
      profilePicUrl = data['profImage'];

      setState(() => isLoading = false);
    } catch (e) {
      showSnackBar(context, 'Failed to load post: $e');
    }
  }

  Future<void> _selectImage(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return SimpleDialog(
          title: const Text('Select new images'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(ctx);
                final Uint8List file = await pickImage(ImageSource.camera);
                setState(() => _newFiles.add(file));
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.pop(ctx);
                final List<XFile> pickedFiles = await ImagePicker()
                    .pickMultiImage();
                if (pickedFiles.isNotEmpty) {
                  final List<Uint8List> fileBytes = await Future.wait(
                    pickedFiles.map((xfile) => xfile.readAsBytes()),
                  );
                  setState(() => _newFiles.addAll(fileBytes));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePost() async {
    if (_descriptionController.text.trim().isEmpty &&
        _oldImageUrls.isEmpty &&
        _newFiles.isEmpty) {
      showSnackBar(context, 'Post cannot be empty.');
      return;
    }

    setState(() => isLoading = true);

    try {
      await FireStoreMethods().updatePost(
        postId: widget.postId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        newImages: _newFiles,
        oldImageUrls: _oldImageUrls,
      );

      showSnackBar(context, 'Post updated successfully!');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _buildImageGrid() {
    final totalImages = _oldImageUrls.length + _newFiles.length;

    void openFullScreenViewer(int startIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FullScreenImageViewer(files: _newFiles, initialIndex: startIndex),
        ),
      );
    }

    if (totalImages == 0) return const SizedBox();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalImages,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        bool isOld = index < _oldImageUrls.length;
        return Stack(
          children: [
            GestureDetector(
              onTap: () => openFullScreenViewer(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: isOld
                    ? Image.network(
                        _oldImageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Image.memory(
                        _newFiles[index - _oldImageUrls.length],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isOld) {
                      _oldImageUrls.removeAt(index);
                    } else {
                      _newFiles.removeAt(index - _oldImageUrls.length);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Post",
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: _updatePost,
            child: Text(
              "Save Changes",
              style: GoogleFonts.lato(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Edit your Title",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.lato(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                  style: GoogleFonts.lato(fontSize: 16),
                ),
                const SizedBox(height: 20,) ,
                TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Edit your caption...",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.lato(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                  style: GoogleFonts.lato(fontSize: 16),
                ),
                const SizedBox(height: 10),
                _buildImageGrid(),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () => _selectImage(context),
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: primaryColor,
                  ),
                  label: Text(
                    "Add more images",
                    style: GoogleFonts.lato(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
