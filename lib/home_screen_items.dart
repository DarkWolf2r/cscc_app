import 'package:cscc_app/features/auth/model/user_model.dart';
import 'package:cscc_app/features/auth/provider/providers.dart';
import 'package:cscc_app/features/events/screens/event_screen.dart';
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
