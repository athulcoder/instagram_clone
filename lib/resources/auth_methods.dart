import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _fireStore.collection("Users").doc(currentUser.uid).get();

    return model.User(
        username: snapshot.get('username'),
        posts: snapshot.get("posts"),
        email: snapshot.get('email'),
        name: snapshot.get('name'),
        uid: snapshot.get('uid'),
        avatarUrl: snapshot.get('avatarUrl'),
        followers: snapshot.get('followers'),
        bio: snapshot.get('bio'),
        following: snapshot.get('following'));
  }
  //  Sign up the user

  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String name,
    required Uint8List file,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          name.isNotEmpty) {
        // Register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePic", file, false);
        // add user to database

        model.User user = model.User(
            email: email,
            uid: credential.user!.uid,
            avatarUrl: photoUrl,
            name: name,
            followers: [],
            following: [],
            bio: '',
            posts: [],
            username: username);

        await _fireStore
            .collection("Users")
            .doc(credential.user!.uid)
            .set(user.toJson());

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "Invalid email !";
      } else if (err.code == "weak-password") {
        res = "Weak password !";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

// Logging user

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter the details";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "User not found ! please check the details and try again.";
      } else if (e.code == 'wrong-password') {
        res = "Wrong password! try again with correct ";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> saveEditedChanges() async {}
}
