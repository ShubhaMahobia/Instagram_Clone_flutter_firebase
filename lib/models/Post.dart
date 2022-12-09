import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String userName;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.caption,
    required this.uid,
    required this.userName,
    required this.datePublished,
    required this.postId,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });
  Map<String, dynamic> toJson() => {
        "userName": userName,
        "uid": uid,
        "postId": postId,
        "userName": userName,
        "profImage": profImage,
        "postUrl": postUrl,
        "datePublished": datePublished,
        "likes": likes,
        "caption": caption
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      userName: snapshot['userName'],
      uid: snapshot['uid'],
      caption: snapshot['caption'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      likes: snapshot['likes'],
      profImage: snapshot['profImage'],
    );
  }
}
