import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:cscc_app/cores/models/post.dart';
import 'package:cscc_app/cores/storage_methods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Upload Post (with image)
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        'posts',
        file,
        true,
      );

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Upload Text-only Post (no image)
  Future<String> uploadTextPost(
    String description,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occurred";
    try {
      if (description.isEmpty) {
        return "Please write something before posting.";
      }

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: "",
        profImage: profImage,
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
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
              'profilePic': profilePic,
              'name': name,
              'uid': uid,
              'text': text,
              'commentId': commentId,
              'datePublished': DateTime.now(),
            });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
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
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  /// Upload Image to Firebase Storage
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

  /// Update Post (Edit + Add New Images)
  Future<void> updatePost({
    required String postId,
    required String description,
    required List<Uint8List> newImages,
    required List<String> oldImageUrls,
  }) async {
    try {
      List<String> uploadedUrls = [];

      // Upload new images (if any)
      if (newImages.isNotEmpty) {
        for (var img in newImages) {
          String url = await uploadImageToStorage('posts', img, true);
          uploadedUrls.add(url);
        }
      }

      // Combine old + new images
      List<String> finalUrls = [...oldImageUrls, ...uploadedUrls];

      await _firestore.collection('posts').doc(postId).update({
        'description': description,
        'postUrls': finalUrls,
        'dateUpdated': DateTime.now(),
      });
    } catch (e) {
      throw Exception("Failed to update post: $e");
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/cores/models/post.dart';
// import 'package:cscc_app/cores/storage_methods.dart';
// import 'package:flutter/foundation.dart';
// import 'package:uuid/uuid.dart';

// class FireStoreMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String> uploadPost(
//     String description,
//     Uint8List file,
//     String uid,
//     String username,
//     String profImage,
//   ) async {
//     // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
//     String res = "Some error occurred";
//     try {
//       String photoUrl = await StorageMethods().uploadImageToStorage(
//         'posts',
//         file,
//         true,
//       );
//       String postId = const Uuid().v1(); // creates unique id based on time
//       Post post = Post(
//         description: description,
//         uid: uid,
//         username: username,
//         likes: [],
//         postId: postId,
//         datePublished: DateTime.now(),
//         postUrl: photoUrl,
//         profImage: profImage,
//       );
//       _firestore.collection('posts').doc(postId).set(post.toJson());
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> uploadTextPost(
//     String description,
//     String uid,
//     String username,
//     String profImage,
//   ) async {
//     String res = "Some error occurred";
//     try {
//       if (description.isEmpty) {
//         return "Please write something before posting.";
//       }

//       String postId = const Uuid().v1();

//       Post post = Post(
//         description: description,
//         uid: uid,
//         username: username,
//         likes: [],
//         postId: postId,
//         datePublished: DateTime.now(),
//         postUrl: "",
//         profImage: profImage,
//       );

//       await _firestore.collection('posts').doc(postId).set(post.toJson());

//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> likePost(String postId, String uid, List likes) async {
//     String res = "Some error occurred";
//     try {
//       if (likes.contains(uid)) {
//         // if the likes list contains the user uid, we need to remove it
//         _firestore.collection('posts').doc(postId).update({
//           'likes': FieldValue.arrayRemove([uid]),
//         });
//       } else {
//         // else we need to add uid to the likes array
//         _firestore.collection('posts').doc(postId).update({
//           'likes': FieldValue.arrayUnion([uid]),
//         });
//       }
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   // Post comment
//   Future<String> postComment(
//     String postId,
//     String text,
//     String uid,
//     String name,
//     String profilePic,
//   ) async {
//     String res = "Some error occurred";
//     try {
//       if (text.isNotEmpty) {
//         // if the likes list contains the user uid, we need to remove it
//         String commentId = const Uuid().v1();
//         await _firestore
//             .collection('posts')
//             .doc(postId)
//             .collection('comments')
//             .doc(commentId)
//             .set({
//               'profilePic': profilePic,
//               'name': name,
//               'uid': uid,
//               'text': text,
//               'commentId': commentId,
//               'datePublished': DateTime.now(),
//             });
//         res = 'success';
//       } else {
//         res = "Please enter text";
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   // Delete Post
//   Future<String> deletePost(String postId) async {
//     String res = "Some error occurred";
//     try {
//       await _firestore.collection('posts').doc(postId).delete();
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<void> followUser(String uid, String followId) async {
//     try {
//       DocumentSnapshot snap = await _firestore
//           .collection('users')
//           .doc(uid)
//           .get();
//       List following = (snap.data()! as dynamic)['following'];

//       if (following.contains(followId)) {
//         await _firestore.collection('users').doc(followId).update({
//           'followers': FieldValue.arrayRemove([uid]),
//         });

//         await _firestore.collection('users').doc(uid).update({
//           'following': FieldValue.arrayRemove([followId]),
//         });
//       } else {
//         await _firestore.collection('users').doc(followId).update({
//           'followers': FieldValue.arrayUnion([uid]),
//         });

//         await _firestore.collection('users').doc(uid).update({
//           'following': FieldValue.arrayUnion([followId]),
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) print(e.toString());
//     }
//   }

//   Future<String> uploadImageToStorage(
//       String childName, Uint8List file, bool isPost) async {
//     Reference ref = FirebaseStorage.instance
//         .ref()
//         .child(childName)
//         .child(const Uuid().v1());

//     UploadTask uploadTask = ref.putData(file);
//     TaskSnapshot snap = await uploadTask;
//     String downloadUrl = await snap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   Future<void> updatePost({
//     required String postId,
//     required String description,
//     required List<Uint8List> newImages,
//     required List<String> oldImageUrls,
//   }) async {
//     try {
//       List<String> uploadedUrls = [];

//       if (newImages.isNotEmpty) {
//         for (var img in newImages) {
//           String url = await uploadImageToStorage('posts', img, true);
//           uploadedUrls.add(url);
//         }
//       }

//       List<String> finalUrls = [...oldImageUrls, ...uploadedUrls];

//       await FirebaseFirestore.instance.collection('posts').doc(postId).update({
//         'description': description,
//         'postUrls': finalUrls,
//         'dateUpdated': DateTime.now(),
//       });
//     } catch (e) {
//       throw Exception("Failed to update post: $e");
//     }
//   }
// }
