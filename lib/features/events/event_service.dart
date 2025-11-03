import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  getEventPosts() {
    return _firestore
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .where('type', isEqualTo: 'event')
        .snapshots()
        .map((event) => event.docs)
        .toList();
  }
}
