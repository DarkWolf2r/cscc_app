// import 'package:cscc_app/features/chat/message_enum.dart';
// import 'package:cscc_app/features/chat/widgets/display_text_image_gif.dart';
// import 'package:flutter/material.dart';
// import 'package:swipe_to/swipe_to.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TerminalMessageCard extends StatelessWidget {
//   final String message;
//   final String date;
//   final MessageEnum type;
//   final VoidCallback onLeftSwipe;
//   final String repliedText;
//   final String username;
//   final MessageEnum repliedMessageType;
//   final bool isSeen;
//   final bool isMe;

//   const TerminalMessageCard({
//     super.key,
//     required this.message,
//     required this.date,
//     required this.type,
//     required this.onLeftSwipe,
//     required this.repliedText,
//     required this.username,
//     required this.repliedMessageType,
//     required this.isSeen,
//     required this.isMe,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isReplying = repliedText.isNotEmpty;

//     return SwipeTo(
//       onLeftSwipe: (details) => onLeftSwipe(),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// REPLY BLOCK
//               if (isReplying) ...[
//                 Text(
//                   "↳ $username",
//                   style: GoogleFonts.robotoMono(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   margin: const EdgeInsets.only(bottom: 3),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(.06),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: DisplayTextImageGIF(
//                     message: repliedText,
//                     type: repliedMessageType,
//                   ),
//                 ),
//               ],

//               /// TERMINAL MESSAGE
//               RichText(
//                 text: TextSpan(
//                   style: GoogleFonts.robotoMono(
//                     fontSize: 14,
//                     color: Colors.grey.shade900,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: "C:\\Users\\$username> ",
//                       style: GoogleFonts.robotoMono(
//                         fontWeight: FontWeight.w600,
//                         color: isMe
//                             ? Colors.blueAccent
//                             : Colors.greenAccent.shade700,
//                       ),
//                     ),

//                     /// TEXT / MEDIA
//                     WidgetSpan(
//                       child: type == MessageEnum.text
//                           ? Text(
//                               message,
//                               style: GoogleFonts.robotoMono(
//                                 color: isMe
//                                     ? Colors.blueAccent.withOpacity(.9)
//                                     : Colors.black87,
//                               ),
//                             )
//                           : DisplayTextImageGIF(
//                               message: message,
//                               type: type,
//                             ),
//                     ),
//                   ],
//                 ),
//               ),

//               /// FOOTER => date + seen
//               Padding(
//                 padding: const EdgeInsets.only(top: 3, left: 4),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       date,
//                       style: GoogleFonts.robotoMono(
//                         fontSize: 11,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Icon(
//                       isSeen ? Icons.done_all : Icons.done,
//                       size: 15,
//                       color: isSeen ? Colors.blue : Colors.grey,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Align(
        alignment: Alignment.centerLeft, // all left-aligned (like terminal)
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.robotoMono(
              fontSize: 14,
              color: Colors.grey.shade900,
            ),
            children: [
              TextSpan(
                text: "C:\\Users\\$username> ",
                style: GoogleFonts.robotoMono(
                  fontWeight: FontWeight.w600,
                  color: isMe
                      ? Theme.of(context).colorScheme.primary
                      : Colors.greenAccent.shade700,
                ),
              ),
              TextSpan(
                text: message,
                style: GoogleFonts.robotoMono(
                  color: isMe
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                      : Colors.grey.shade800,
                ),
              ),
            ],
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
