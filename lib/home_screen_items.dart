import 'package:cscc_app/features/departement/departement_page.dart';
import 'package:cscc_app/features/events/chef_event_dashborad.dart';
import 'package:cscc_app/features/events/event_bot_page.dart';
import 'package:cscc_app/features/events/event_creation_page.dart';
import 'package:cscc_app/features/profile/profile_page.dart';
import 'package:cscc_app/features/screens/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:cscc_app/features/screens/add_post_screen.dart';

const List<Widget> homeScreenItems = [
  ChefEventDashboard(),
  EventCreationPage(),
  AddPostScreen(),
  Text("Favorites Page"),
  EventBotPage(),
];
