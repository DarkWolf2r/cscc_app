import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<File> pickImage() async {
  XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
  File image = File(file!.path);

  return image;
}

Future<String> putFileInStorage(file, number, fileType) async {
  final ref = FirebaseStorage.instance.ref().child("$fileType/$number");
  final uplaod = ref.putFile(file);
  final snapshot = await uplaod;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}
