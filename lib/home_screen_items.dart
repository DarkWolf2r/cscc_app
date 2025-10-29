import 'package:cscc_app/features/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:cscc_app/features/screens/add_post_screen.dart';

const List<Widget> homeScreenItems = [
  Text("Home Page"),
  Text("Search Page"),
  AddPostScreen(),
  Text("Favorites Page"),
  // Text("Profile Page"),
  ProfilePage(),
];
