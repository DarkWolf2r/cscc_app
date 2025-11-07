import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:cscc_app/cores/storage_methods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Upload Post (with image + metadata)
  Future<String> uploadPost({
    required String title,
    required String description,
    required List<Uint8List> files,
    required String uid,
    required String username,
    required String profImage,
    required String department,
    required String type,
    required String visibility,
  }) async {
    String res = "Some error occurred";
    try {
      List<String> photoUrls = [];

      // Upload all images
      for (var file in files) {
        String photoUrl = await StorageMethods().uploadImageToStorage(
          'posts',
          file,
          true,
        );
        photoUrls.add(photoUrl);
      }

      String postId = const Uuid().v1();

      await _firestore.collection('posts').doc(postId).set({
        'postId': postId,
        'uid': uid,
        'username': username,
        'profImage': profImage,
        'description': description,
        'title': title,
        'postUrls': photoUrls,
        'likes': [],
        'datePublished': DateTime.now(),
        'department': department,
        'type': type,
        'visibility': visibility == "Bureau Members Only"
            ? "bureau"
            : "everyone",
      });
      if (type == 'Event') {
        await _firestore.collection('events').doc(postId).set({
          'postId': postId,
          'title': title,
          'place': '',
          'description':description,
          'date': '',
          'teams': [
            {'name': 'Logistics', 'description': 'Organisation', 'members': []},
         
          ],
          'createdBy':FirebaseAuth.instance.currentUser!.uid 
        });
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Upload Text-only Post (no image)
  Future<String> uploadTextPost({
    required String title,
    required String description,
    required String uid,
    required String username,
    required String profImage,
    required String department,
    required String type,
    required String visibility,
  }) async {
    String res = "Some error occurred";
    try {
      if (description.isEmpty) {
        return "Please write something before posting.";
      }

      String postId = const Uuid().v1();

      await _firestore.collection('posts').doc(postId).set({
        'postId': postId,
        'uid': uid,
        'title': title,
        'username': username,
        'profImage': profImage,
        'description': description,
        'postUrls': [],
        'likes': [],
        'datePublished': DateTime.now(),
        'department': department,
        'type': type,
        'visibility': visibility == "Bureau Members Only"
            ? "bureau"
            : "everyone",
      });
     if (type == 'Event') {
        await _firestore.collection('events').doc(postId).set({
          'postId': postId,
          'title': title,
          'desciption' :description,
          'place': '',
          'date': '',
          'teams': [
            {'name': 'Logistics', 'description': 'Organisation', 'members': []},
           
          ],
          'createdBy':FirebaseAuth.instance.currentUser!.uid 
        });
      }
      
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Like / Unlike Post
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Post Comment
  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
              'postId': postId,
              'commentId': commentId,
              'uid': uid,
              'name': name,
              'profilePic': profilePic,
              'text': text,
              'likes': [],
              'datePublished': DateTime.now(),
            });
        res = 'success';
      } else {
        res = "Comment cannot be empty";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Like / Unlike Comment
  Future<void> likeComment(
    String postId,
    String commentId,
    String uid,
    List likes,
  ) async {
    try {
      final commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId);

      if (likes.contains(uid)) {
        await commentRef.update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await commentRef.update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Delete Comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting comment: $e');
      rethrow;
    }
  }

  /// Edit Comment
  Future<void> editComment(
    String postId,
    String commentId,
    String newText,
  ) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({'text': newText, 'editedAt': DateTime.now()});
    } catch (e) {
      debugPrint('Error editing comment: $e');
      rethrow;
    }
  }

  /// Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Follow / Unfollow user
  Future<bool> followUser(String uid, String followId) async {
    try {
      final userRef = _firestore.collection('users');
      DocumentSnapshot currentUserSnap = await userRef.doc(uid).get();
      DocumentSnapshot targetUserSnap = await userRef.doc(followId).get();

      List following = List.from(currentUserSnap['following'] ?? []);
      List followers = List.from(targetUserSnap['followers'] ?? []);

      if (following.contains(followId)) {
        await userRef.doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
        await userRef.doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        return false; // unfollowed
      } else {
        await userRef.doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
        await userRef.doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        return true; // followed
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return false;
    }
  }

  /// Upload Image
  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child(childName)
          .child(const Uuid().v1());

      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  /// Update Post
  Future<void> updatePost({
    required String title,
    required String postId,
    required String description,
    required List<Uint8List> newImages,
    required List<String> oldImageUrls,
  }) async {
    try {
      List<String> uploadedUrls = [];

      if (newImages.isNotEmpty) {
        for (var img in newImages) {
          String url = await uploadImageToStorage('posts', img, true);
          uploadedUrls.add(url);
        }
      }

      List<String> finalUrls = [...oldImageUrls, ...uploadedUrls];

      await _firestore.collection('posts').doc(postId).update({
        'description': description,
        'title': title,
        'postUrls': finalUrls,
        'dateUpdated': DateTime.now(),
      });
    } catch (e) {
      throw Exception("Failed to update post: $e");
    }
  }

  // Create or get chat between two users
  Future<String> createOrGetChat(
    String currentUserId,
    String otherUserId,
    String otherUsername,
    String otherProfilePic,
  ) async {
    try {
      // Sort UIDs to generate consistent chatId
      List<String> uids = [currentUserId, otherUserId]..sort();
      String chatId = "${uids[0]}_${uids[1]}";

      final chatDoc = await _firestore.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        // create chat
        await _firestore.collection('chats').doc(chatId).set({
          'chatId': chatId,
          'userIds': uids,
          'otherUserId': otherUserId,
          'otherUsername': otherUsername,
          'otherProfilePic': otherProfilePic,
          'lastMessage': "",
          'lastMessageTime': DateTime.now(),
        });
      }

      return chatId;
    } catch (e) {
      throw Exception("Failed to create/get chat: $e");
    }
  }

  // Send message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final timestamp = DateTime.now();

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set({
            'messageId': messageId,
            'senderId': senderId,
            'text': text,
            'timestamp': timestamp,
          });

      // update last message for chat preview
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': timestamp,
      });
    } catch (e) {
      throw Exception("Failed to send message: $e");
    }
  }

  // Stream messages for a chat
  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Stream all chats for a user
  Stream<QuerySnapshot> getUserChats(String currentUserId) {
    return _firestore
        .collection('chats')
        .where('userIds', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
}
