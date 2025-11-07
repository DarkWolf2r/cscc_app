import 'package:cscc_app/cores/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TerminalMessage extends StatelessWidget {
  final String username;
  final String message;
  final bool isMe;

  const TerminalMessage({
    super.key,
    required this.username,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "C:\\Users\\$username> $message",
          style: GoogleFonts.robotoMono(
            fontSize: 14,
            color: isMe ? primaryColor : Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}

// import 'package:cscc_app/cores/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TerminalMessage extends StatelessWidget {
//   final String username;
//   final String message;
//   final bool isMe;

//   const TerminalMessage({
//     super.key,
//     required this.username,
//     required this.message,
//     required this.isMe,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           "C:\\Users\\$username> $message",
//           style: GoogleFonts.robotoMono(
//             fontSize: 14,
//             color: isMe ? primaryColor : Colors.white.withOpacity(0.9),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TerminalMessage extends StatelessWidget {
//   final String username;
//   final String message;
//   final bool isMe;

//   const TerminalMessage({
//     super.key,
//     required this.username,
//     required this.message,
//     required this.isMe,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//       child: Align(
//         alignment: Alignment.centerLeft, // all left-aligned (like terminal)
//         child: RichText(
//           text: TextSpan(
//             style: GoogleFonts.robotoMono(
//               fontSize: 14,
//               color: Colors.grey.shade900,
//             ),
//             children: [
//               TextSpan(
//                 text: "C:\\Users\\$username> ",
//                 style: GoogleFonts.robotoMono(
//                   fontWeight: FontWeight.w600,
//                   color: isMe
//                       ? Theme.of(context).colorScheme.primary
//                       : Colors.greenAccent.shade700,
//                 ),
//               ),
//               TextSpan(
//                 text: message,
//                 style: GoogleFonts.robotoMono(
//                   color: isMe
//                       ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
//                       : Colors.grey.shade800,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TerminalMessage extends StatelessWidget {
//   final String username;
//   final String message;
//   final bool isMe;

//   const TerminalMessage({
//     super.key,
//     required this.username,
//     required this.message,
//     required this.isMe,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//         child: Text(
//           "$username> $message",
//           style: GoogleFonts.robotoMono(
//             // Monospace font for "terminal" vibe
//             fontSize: 14,
//             color: isMe
//                 ? Theme.of(context).colorScheme.primary
//                 : Colors.grey.shade900,
//           ),
//         ),
//       ),
//     );
//   }
// }
