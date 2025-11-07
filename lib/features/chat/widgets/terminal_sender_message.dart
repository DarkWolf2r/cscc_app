// import 'package:cscc_app/features/chat/message_enum.dart';
// import 'package:cscc_app/features/chat/widgets/display_text_image_gif.dart';
// import 'package:flutter/material.dart';
// import 'package:swipe_to/swipe_to.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TerminalSenderMessage extends StatelessWidget {
//   const TerminalSenderMessage({
//     super.key,
//     required this.message,
//     required this.date,
//     required this.type,
//     required this.onRightSwipe,
//     required this.repliedText,
//     required this.username,
//     required this.repliedMessageType,
//   });

//   final String message;
//   final String date;
//   final MessageEnum type;
//   final VoidCallback onRightSwipe;
//   final String repliedText;
//   final String username;
//   final MessageEnum repliedMessageType;

//   @override
//   Widget build(BuildContext context) {
//     final isReplying = repliedText.isNotEmpty;

//     return SwipeTo(
//       onRightSwipe: (details) => onRightSwipe(),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// ===== REPLY BLOCK =====
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

//               /// ===== TERMINAL PROMPT + MESSAGE =====
//               RichText(
//                 text: TextSpan(
//                   style: GoogleFonts.robotoMono(
//                     fontSize: 14,
//                     color: Colors.grey.shade900,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: "\$ ",
//                       style: GoogleFonts.robotoMono(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.greenAccent.shade700,
//                       ),
//                     ),

//                     /// TEXT or MEDIA
//                     WidgetSpan(
//                       child: type == MessageEnum.text
//                           ? Text(
//                               message,
//                               style: GoogleFonts.robotoMono(
//                                 color: Colors.black87,
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

//               /// ===== FOOTER DATE =====
//               Padding(
//                 padding: const EdgeInsets.only(top: 3, left: 4),
//                 child: Text(
//                   date,
//                   style: GoogleFonts.robotoMono(
//                     fontSize: 11,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:cscc_app/features/chat/message_enum.dart';
// // import 'package:cscc_app/features/chat/widgets/display_text_image_gif.dart';
// // import 'package:flutter/material.dart';
// // import 'package:swipe_to/swipe_to.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class TerminalSenderMessage extends StatelessWidget {
// //   const TerminalSenderMessage({
// //     super.key,
// //     required this.message,
// //     required this.date,
// //     required this.type,
// //     required this.onRightSwipe,
// //     required this.repliedText,
// //     required this.username,
// //     required this.repliedMessageType,
// //   });

// //   final String message;
// //   final String date;
// //   final MessageEnum type;
// //   final VoidCallback onRightSwipe;
// //   final String repliedText;
// //   final String username;
// //   final MessageEnum repliedMessageType;

// //   @override
// //   Widget build(BuildContext context) {
// //     final isReplying = repliedText.isNotEmpty;

// //     return SwipeTo(
// //       onRightSwipe: onRightSwipe,
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
// //         child: Align(
// //           alignment: Alignment.centerLeft,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               /// ===== REPLY BLOCK =====
// //               if (isReplying) ...[
// //                 Text(
// //                   "↳ $username",
// //                   style: GoogleFonts.robotoMono(
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.grey.shade700,
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: const EdgeInsets.all(6),
// //                   margin: const EdgeInsets.only(bottom: 3),
// //                   decoration: BoxDecoration(
// //                     color: Colors.black.withOpacity(.06),
// //                     borderRadius: BorderRadius.circular(4),
// //                   ),
// //                   child: DisplayTextImageGIF(
// //                     message: repliedText,
// //                     type: repliedMessageType,
// //                   ),
// //                 ),
// //               ],

// //               /// ===== TERMINAL PROMPT + MESSAGE =====
// //               RichText(
// //                 text: TextSpan(
// //                   style: GoogleFonts.robotoMono(
// //                     fontSize: 14,
// //                     color: Colors.grey.shade900,
// //                   ),
// //                   children: [
// //                     TextSpan(
// //                       text: "\$ ",
// //                       style: GoogleFonts.robotoMono(
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.greenAccent.shade700,
// //                       ),
// //                     ),

// //                     /// TEXT or MEDIA
// //                     WidgetSpan(
// //                       child: type == MessageEnum.text
// //                           ? Text(
// //                               message,
// //                               style: GoogleFonts.robotoMono(
// //                                 color: Colors.black87,
// //                               ),
// //                             )
// //                           : DisplayTextImageGIF(
// //                               message: message,
// //                               type: type,
// //                             ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               /// ===== FOOTER DATE =====
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 3, left: 4),
// //                 child: Text(
// //                   date,
// //                   style: GoogleFonts.robotoMono(
// //                     fontSize: 11,
// //                     color: Colors.grey,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
