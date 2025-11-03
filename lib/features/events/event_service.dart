// Stream<List<PostModel>> getEventPosts() {
//   return _firestore
//       .collection('posts')
//       .where('type', isEqualTo: 'event')
//       .snapshots()
//       .map((snapshot) =>
//           snapshot.docs.map((doc) => PostModel.fromMap(doc.data(), doc.id)).toList());
// }