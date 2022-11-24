import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instgram_clone/model/storage_methode.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
    //required Uint8List file,
  }) async {
    String res = "Some error has occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("ProfilePics", file, false);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          "email": email,
          "password": password,
          "username": username,
          "uid": cred.user!.uid,
          "bio": bio,
          "followers": [],
          "following": [],
          "photoUrl": photoUrl
        });
        res = "success";
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}
