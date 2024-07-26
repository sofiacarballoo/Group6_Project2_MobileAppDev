import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/screens/add_post_screen.dart';
import 'package:project2/screens/feed_screen.dart';
import 'package:project2/screens/pet_profile_screen.dart';
import 'package:project2/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  PetProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),

];