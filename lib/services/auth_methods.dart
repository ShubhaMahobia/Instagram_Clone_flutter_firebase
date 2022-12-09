import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/users.dart' as model;
import 'package:instagram_clone/services/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    return model.User.fromSnap(snap);
  }

  //--Sign Up USER--
  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some Error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty) {
        //REGISTER USER To for Authentication
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethod()
            .uploadImageToStorage('ProfilePics', file, false);

        // Store Info to DATABASE
        model.User user = model.User(
          userName: userName,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //logging In user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error Occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all email/Password";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> SignOut() async {
    await _auth.signOut();
  }
}
