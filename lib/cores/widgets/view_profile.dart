import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewProfilePage extends StatelessWidget {
  final String userId;
  const ViewProfilePage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text("User not found"));
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 0.9,
              child: Stack(
                children: [
                  Positioned(
                    top: 60,
                    left: 10,
                    child: Text(
                      "PROFILE",
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: CachedNetworkImageProvider(
                                data['profilePic'],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data['username'],
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              data['type'].toUpperCase(),
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (data['departement'] != null)
                              for (var dept in data['departement'])
                                Text(
                                  dept,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            const SizedBox(height: 20),
                            Text(
                              "About Me",
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data['description'] ??
                                  "This member has no description yet.",
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ViewProfilePage extends StatelessWidget {
//   final String userId;
//   const ViewProfilePage({required this.userId, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Profile")),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           return Column(
//             children: [
//               CircleAvatar(
//                 radius: 70,
//                 backgroundImage: NetworkImage(data['profilePic']),
//               ),
//               const SizedBox(height: 10),
//               Text(data['username'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//               Text(data['type']),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
