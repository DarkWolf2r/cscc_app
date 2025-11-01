import 'package:cscc_app/features/departement/departement_page.dart';
import 'package:cscc_app/features/profile/profile_page.dart';
import 'package:cscc_app/features/project/projects_page.dart';
import 'package:cscc_app/features/screens/feed_screen.dart';
import 'package:flutter/material.dart';
// import 'package:cscc_app/features/screens/add_post_screen.dart';

const List<Widget> homeScreenItems = [
  FeedScreen(),
  DepartementPage(),
  Text("Add something"),
  ProjectsPage(),
  ProfilePage(),
];
