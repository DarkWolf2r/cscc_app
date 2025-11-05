  

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final eventPostsProvider =
//     StreamProvider<List<Map<String, dynamic>>>((ref) {
//   return FirebaseFirestore.instance
//       .collection("posts")
//       .where("type", isEqualTo: "Event")
//       .snapshots()
//       .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
// });
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/event_model.dart';

// final eventPostsProvider = StreamProvider<List<EventModel>>((ref) {
//   return FirebaseFirestore.instance
//       .collection('posts')
//       .where('type', isEqualTo: 'Event')
//     //  .orderBy('datePublished', descending: true)
//       .snapshots()
//       .map((snapshot) {
//     return snapshot.docs.map((doc) => EventModel.fromDoc(doc)).toList();
//   });
// });
final eventPostsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('events')
      .orderBy('date', descending: false)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
});
