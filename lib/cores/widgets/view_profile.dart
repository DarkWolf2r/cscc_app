import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/firestore_methods.dart';
import 'package:cscc_app/features/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cscc_app/cores/colors.dart';

class ViewProfilePage extends StatelessWidget {
  final String userId;
  const ViewProfilePage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists || snapshot.data!.data() == null) {
            return const Center(child: Text("User not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final interests = List<String>.from(data['interests'] ?? []);
          final stats = {
            "Followers": data['followersCount'] ?? 0,
            "Following": data['followingCount'] ?? 0,
            "Events": data['eventsCount'] ?? 0,
          };

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- AppBar style ---
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "Profile",
                        style: GoogleFonts.lato(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- Profile Picture ---
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(
                      data['profilePic'] ?? '',
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 12),

                  // --- Username ---
                  Text(
                    data['username'] ?? "Unknown User",
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['type']?.toUpperCase() ?? "",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- Stats Row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: stats.entries.map((entry) {
                      return Column(
                        children: [
                          Text(
                            entry.value.toString(),
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.key,
                            style: GoogleFonts.lato(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton.icon(
                    onPressed: () async {
                      final currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;

                      final chatId = await FireStoreMethods().createOrGetChat(
                        currentUserId,
                        userId,
                        data['username'] ?? "Unknown",
                        data['profilePic'] ?? '',
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChatScreen(chatId: chatId, receiverId: userId),
                        ),
                      );
                    },
                    icon: const Icon(Icons.message_rounded, size: 20),
                    label: Text(
                      "Message",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- About Me ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About Me",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data['description'] ??
                          "This user hasn't added a description yet.",
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.grey[400],
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --- Interests ---
                  if (interests.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Interests",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (interests.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: interests
                          .map(
                            (interest) => Chip(
                              label: Text(
                                interest,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              backgroundColor: primaryColor.withOpacity(0.15),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
