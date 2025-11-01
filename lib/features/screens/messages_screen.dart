import 'package:cscc_app/cores/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(
      //   context,
      // ).colorScheme.surface, // full white background
      backgroundColor: primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            floating: true,
            snap: true,
            elevation: 0,
            title: Text(
              "Messages",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // ---- content ----
          SliverFillRemaining(
            hasScrollBody: false, // makes container fill all remaining space
            child: Container(
              // margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  // topLeft: Radius.circular(14),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Text(
                  "No messages yet",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:cscc_app/cores/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MessagesScreen extends StatelessWidget {
//   const MessagesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: primaryColor,
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               backgroundColor: primaryColor,
//               floating: true,
//               snap: true,
//               elevation: 0,
//               title: Text(
//                 "Messages",
//                 style: GoogleFonts.lato(
//                   textStyle: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 padding: const EdgeInsets.only(bottom: 15, right: 10, left: 10),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.surface,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(14),
//                     topRight: Radius.circular(14),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
