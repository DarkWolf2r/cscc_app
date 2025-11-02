import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/features/project/project_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<ProjectModel>> getProjects() {
    return _firestore.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProjectModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<List<String>> _uploadFiles(
      List<File> files, String folderName) async {
    final urls = <String>[];

    for (var file in files) {
      final ref = _storage
          .ref()
          .child('$folderName/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  Future<void> addProject(ProjectModel project) async {
    await _firestore.collection('projects').add(project.toMap());
  }

  Future<void> uploadProject({
    required String title,
    required String description,
    required String department,
    required List<File> images,
    required List<File> videos,
    required String senderName,
    required String senderImage,
    String? link,
  }) async {
    final imageUrls = await _uploadFiles(images, 'project_images');
    final videoUrls = await _uploadFiles(videos, 'project_videos');

    final project = ProjectModel(
      id: '',
      title: title,
      description: description,
      department: department,
      imageUrls: imageUrls,
      videoUrls: videoUrls,
      senderName: senderName,
      senderImage: senderImage,
      link: link,
    );

    await addProject(project);
  }
}
