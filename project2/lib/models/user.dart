import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String fullname;
  final List followers;
  final List folllowing;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.fullname,
    required this.followers,
    required this.folllowing,
  });

  Map<String,dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
    'fullname': fullname,
    'bio': "",
    'followers': [],
    'following': [],
    'photoUrl': photoUrl,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      fullname: snapshot['fullname'],
      followers: snapshot['followers'],
      folllowing: snapshot['following'],
    );
  }
}