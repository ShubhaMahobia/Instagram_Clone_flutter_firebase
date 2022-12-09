import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.userName,
    required this.bio,
    required this.followers,
    required this.following,
  });
  Map<String, dynamic> toJson() => {
        "userName": userName,
        "uid": uid,
        "email": email,
        "userName": userName,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      userName: snapshot['userName'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
