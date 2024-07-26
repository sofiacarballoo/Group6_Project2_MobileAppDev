import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project2/models/user.dart' as model;
import 'package:project2/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser( {
    required String email,
    required String fullname,
    required String username,
    required String password,
    required Uint8List file,
    
  }) async {
    String res = "Some Error Occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || fullname.isNotEmpty || file != null) {
        UserCredential  cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          fullname: fullname,
          photoUrl: photoUrl,
          followers: [],
          folllowing: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);
        res = "success";
      }

    } catch(err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> loginUser({
      required String email,
      required String password,
    }) async {
      String res = "Some error Occurred";
      try {
        if (email.isNotEmpty || password.isNotEmpty) {
          await _auth.signInWithEmailAndPassword(
            email: email, 
            password: password,
            );
            res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
