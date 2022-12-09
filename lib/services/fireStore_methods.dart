import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/Post.dart';
import 'package:instagram_clone/services/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Upload Post
  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String userName, String profImage) async {
    String res = "Some Error Occurred";
    try {
      String photoUrl =
          await StorageMethod().uploadImageToStorage('Posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        caption: caption,
        uid: uid,
        userName: userName,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firebaseFirestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String userName,
      String profilePic, String uid) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'userName': userName,
          'text': text,
          'uid': uid,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print('Text is field is Empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
