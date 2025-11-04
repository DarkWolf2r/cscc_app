import 'package:cscc_app/features/events/event_screen.dart';
import 'package:cscc_app/features/profile/profile_page.dart';
import 'package:cscc_app/features/project/projects_screen.dart';
import 'package:cscc_app/features/screens/add_post_screen.dart';
import 'package:cscc_app/features/screens/feed_screen.dart';
import 'package:flutter/material.dart';

const List<Widget> homeScreenItems = [
  FeedScreen(),
  EventScreen(),
  AddPostScreen(),
  ProjectsScreen(),
  ProfilePage(),
];
