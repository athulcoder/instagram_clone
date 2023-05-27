import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String res = 'Some problem occured';
  // upload post

  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String profileImage) async {
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        caption: caption,
        uid: uid,
        profileImage: profileImage,
        likes: [],
        postId: postId,
        username: username,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
      );

      _firestore.collection("Posts").doc(postId).set(
            post.toJson(),
          );
      _firestore.collection("Users").doc(uid).update({
        "posts": FieldValue.arrayUnion([postId])
      });

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // LIKE POST

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("Posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("Posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Post Comments
  Future<void> postComment(
    String postId,
    String text,
    String username,
    String profilePic,
    String uid,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('Posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'userProfile': profilePic,
          'username': username,
          'uid': uid,
          'commentId': commentId,
          'commentText': text,
          'datePublished': DateTime.now(),
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("Users").doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection("Users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid])
        });

        await _firestore.collection("Users").doc(uid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection("Users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid])
        });

        await _firestore.collection("Users").doc(uid).update({
          "following": FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
      print('---------------------------------------------------------------');
    }
  }
}
