import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/firestore_methods.dart';
import 'package:cscc_app/cores/widgets/terminal_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverId;

  const ChatScreen({super.key, required this.chatId, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String? receiverName;

  @override
  void initState() {
    super.initState();
    _loadReceiverData();
  }

  void _loadReceiverData() async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.receiverId)
        .get();
    if (snap.exists) {
      setState(() {
        receiverName = snap['username'];
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await FireStoreMethods().sendMessage(
      chatId: widget.chatId,
      senderId: currentUserId,
      text: text,
    );

    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color.fromRGBO(24, 27, 46, 1);
    final inputColor = const Color.fromARGB(255, 39, 43, 56);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 31, 57, 1),
        elevation: 0,
        title: Text(
          receiverName != null
              ? "Connected to ${receiverName!}@cscc_terminal"
              : "Connecting...",
          style: GoogleFonts.robotoMono(color: primaryColor, fontSize: 14),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: StreamBuilder<QuerySnapshot>(
          //     stream: FireStoreMethods().getChatMessages(widget.chatId),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return const Center(
          //           child: CircularProgressIndicator(color: primaryColor),
          //         );
          //       }

          //       final messages = snapshot.data!.docs;

          //       WidgetsBinding.instance.addPostFrameCallback((_) {
          //         _scrollToBottom();
          //       });

          //       if (messages.isEmpty) {
          //         final now = DateTime.now();
          //         final formattedDate =
          //             "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
          //             "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

          //         return SingleChildScrollView(
          //           padding: const EdgeInsets.symmetric(
          //             horizontal: 10,
          //             vertical: 12,
          //           ),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 "CSCC Team [Version 11.0.22631.xxxx]",
          //                 style: GoogleFonts.robotoMono(
          //                   fontSize: 14,
          //                   color: Colors.grey.shade400,
          //                 ),
          //               ),
          //               Text(
          //                 "(c) CSCC Corporation. All rights reserved.",
          //                 style: GoogleFonts.robotoMono(
          //                   fontSize: 14,
          //                   color: Colors.grey.shade400,
          //                 ),
          //               ),
          //               const SizedBox(height: 16),
          //               Text(
          //                 "System booted on $formattedDate",
          //                 style: GoogleFonts.robotoMono(
          //                   fontSize: 13,
          //                   color: Colors.grey.shade500,
          //                 ),
          //               ),
          //               const SizedBox(height: 12),
          //               Text(
          //                 receiverName != null
          //                     ? "Connecting to ${receiverName!}@cscc_terminal..."
          //                     : "Connecting to remote terminal...",
          //                 style: GoogleFonts.robotoMono(
          //                   fontSize: 13,
          //                   color: primaryColor,
          //                 ),
          //               ),
          //               const SizedBox(height: 12),
          //               Text(
          //                 "C:\\Users\\You>",
          //                 style: GoogleFonts.robotoMono(
          //                   fontSize: 14,
          //                   color: primaryColor,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       }

          //       return ListView.builder(
          //         controller: _scrollController,
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 10,
          //           vertical: 12,
          //         ),
          //         itemCount: messages.length,
          //         itemBuilder: (context, index) {
          //           final msg = messages[index];
          //           final isMe = msg['senderId'] == currentUserId;
          //           return TerminalMessage(
          //             username: isMe ? "You" : (receiverName ?? "User"),
          //             message: msg['text'],
          //             isMe: isMe,
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FireStoreMethods().getChatMessages(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                final messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUserId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          "${isMe ? 'You' : (receiverName ?? 'User')}: ${msg['text']}",
                          style: GoogleFonts.robotoMono(
                            fontSize: 14,
                            color: isMe ? primaryColor : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const Divider(color: primaryColor, height: 1),
          SafeArea(
            child: Container(
              color: inputColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      cursorColor: primaryColor,
                      style: GoogleFonts.robotoMono(
                        color: primaryColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: "C:\\Users\\You>",
                        hintStyle: GoogleFonts.robotoMono(
                          color: primaryColor.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded),
                    color: primaryColor,
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/firestore_methods.dart';
// import 'package:cscc_app/cores/widgets/terminal_message.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final String receiverId;

//   const ChatScreen({super.key, required this.chatId, required this.receiverId});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   String? receiverName;

//   @override
//   void initState() {
//     super.initState();
//     _loadReceiverData();
//   }

//   void _loadReceiverData() async {
//     final snap = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.receiverId)
//         .get();
//     if (snap.exists) {
//       setState(() {
//         receiverName = snap['username'];
//       });
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;

//     await FireStoreMethods().sendMessage(
//       chatId: widget.chatId,
//       senderId: currentUserId,
//       text: text,
//     );
//     // await firestore.collection('chats').doc(chatId).update({
//     //   'lastMessage': text,
//     //   'lastMessageTime': FieldValue.serverTimestamp(),
//     // });

//     _messageController.clear();
//     _scrollToBottom();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final bgColor = Theme.of(context).colorScheme.surface;
//     final bgColor = Color.fromRGBO(24, 27, 46, 1);
//     final inputColor = const Color.fromARGB(255, 39, 43, 56);

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(28, 31, 57, 1),
//         elevation: 0,
//         title: Text(
//           receiverName != null
//               ? "Connected to ${receiverName!}@cscc_terminal"
//               : "Connecting...",
//           style: GoogleFonts.robotoMono(color: primaryColor, fontSize: 14),
//         ),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           // Expanded(
//           //   child: StreamBuilder<QuerySnapshot>(
//           //     stream: FireStoreMethods().getChatMessages(widget.chatId),
//           //     builder: (context, snapshot) {
//           //       if (!snapshot.hasData) {
//           //         return const Center(
//           //           child: CircularProgressIndicator(color: primaryColor),
//           //         );
//           //       }

//           //       final messages = snapshot.data!.docs;

//           //       WidgetsBinding.instance.addPostFrameCallback((_) {
//           //         _scrollToBottom();
//           //       });

//           //       return ListView.builder(
//           //         controller: _scrollController,
//           //         padding: const EdgeInsets.symmetric(
//           //           horizontal: 10,
//           //           vertical: 12,
//           //         ),
//           //         itemCount: messages.length,
//           //         itemBuilder: (context, index) {
//           //           final msg = messages[index];
//           //           final isMe = msg['senderId'] == currentUserId;

//           //           return TerminalMessage(
//           //             username: isMe ? "You" : (receiverName ?? "User"),
//           //             message: msg['text'],
//           //             isMe: isMe,
//           //           );
//           //         },
//           //       );
//           //     },
//           //   ),
//           // ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FireStoreMethods().getChatMessages(widget.chatId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(color: primaryColor),
//                   );
//                 }

//                 final messages = snapshot.data!.docs;

//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _scrollToBottom();
//                 });

//                 if (messages.isEmpty) {
//                   final now = DateTime.now();
//                   final formattedDate =
//                       "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
//                       "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

//                   return SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 12,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "CSCC Team [Version 11.0.22631.xxxx]",
//                           style: GoogleFonts.robotoMono(
//                             fontSize: 14,
//                             color: Colors.grey.shade400,
//                           ),
//                         ),
//                         Text(
//                           "(c) CSCC Corporation. All rights reserved.",
//                           style: GoogleFonts.robotoMono(
//                             fontSize: 14,
//                             color: Colors.grey.shade400,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "System booted on $formattedDate",
//                           style: GoogleFonts.robotoMono(
//                             fontSize: 13,
//                             color: Colors.grey.shade500,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           receiverName != null
//                               ? "Connecting to ${receiverName!}@cscc_terminal..."
//                               : "Connecting to remote terminal...",
//                           style: GoogleFonts.robotoMono(
//                             fontSize: 13,
//                             color: primaryColor,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           "C:\\Users\\You>",
//                           style: GoogleFonts.robotoMono(
//                             fontSize: 14,
//                             color: primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 12,
//                   ),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];
//                     final isMe = msg['senderId'] == currentUserId;
//                     return TerminalMessage(
//                       username: isMe ? "You" : (receiverName ?? "User"),
//                       message: msg['text'],
//                       isMe: isMe,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           const Divider(color: primaryColor, height: 1),
//           SafeArea(
//             child: Container(
//               color: inputColor,
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12.0,
//                 vertical: 8.0,
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       cursorColor: primaryColor,
//                       style: GoogleFonts.robotoMono(
//                         color: primaryColor,
//                         fontSize: 14,
//                       ),
//                       decoration: InputDecoration(
//                         hintText: "C:\\Users\\You>",
//                         hintStyle: GoogleFonts.robotoMono(
//                           color: primaryColor.withOpacity(0.5),
//                         ),
//                         border: InputBorder.none,
//                       ),
//                       onSubmitted: (_) => sendMessage(),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.send_rounded),
//                     color: primaryColor,
//                     onPressed: sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/firestore_methods.dart';
// import 'package:cscc_app/cores/widgets/terminal_message.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final String receiverId;
//   const ChatScreen({super.key, required this.chatId, required this.receiverId});
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   final ScrollController _scrollController = ScrollController();
//   String? receiverName;
//   String? receiverPic;
//   @override
//   void initState() {
//     super.initState();
//     _loadReceiverData();
//   }
//   void _loadReceiverData() async {
//     final snap = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.receiverId)
//         .get();
//     if (snap.exists) {
//       setState(() {
//         receiverName = snap['username'];
//         receiverPic = snap['profilePic'];
//       });
//     }
//   }
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//   void sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;
//     await FireStoreMethods().sendMessage(
//       chatId: widget.chatId,
//       senderId: currentUserId,
//       text: text,
//     );
//     _messageController.clear();
//     _scrollToBottom();
//   }
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         elevation: 0,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundImage: receiverPic != null && receiverPic!.isNotEmpty
//                   ? NetworkImage(receiverPic!)
//                   : null,
//               backgroundColor: Colors.grey[300],
//             ),
//             const SizedBox(width: 10),
//             Text(
//               receiverName ?? "Chat",
//               style: GoogleFonts.lato(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // --- Messages ---
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FireStoreMethods().getChatMessages(widget.chatId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final messages = snapshot.data!.docs;
//                 // scroll to latest message when new arrives
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _scrollToBottom();
//                 });
//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 12,
//                   ),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];
//                     final isMe = msg['senderId'] == currentUserId;
//                     final Timestamp time = msg['timestamp'];
//                     final timeStr = TimeOfDay.fromDateTime(
//                       time.toDate(),
//                     ).format(context);
//                     // return GestureDetector(
//                     //   onLongPress: () {
//                     //     Clipboard.setData(ClipboardData(text: msg['text']));
//                     //     ScaffoldMessenger.of(context).showSnackBar(
//                     //       const SnackBar(
//                     //         content: Text("Message copied"),
//                     //         duration: Duration(seconds: 1),
//                     //       ),
//                     //     );
//                     //   },
//                     //   child: Align(
//                     //     alignment: isMe
//                     //         ? Alignment.centerRight
//                     //         : Alignment.centerLeft,
//                     //     child: Container(
//                     //       margin: const EdgeInsets.symmetric(vertical: 4),
//                     //       padding: const EdgeInsets.symmetric(
//                     //         horizontal: 14,
//                     //         vertical: 10,
//                     //       ),
//                     //       constraints: BoxConstraints(
//                     //         maxWidth: MediaQuery.of(context).size.width * 0.75,
//                     //       ),
//                     //       decoration: BoxDecoration(
//                     //         color: isMe
//                     //             ? primaryColor
//                     //             : Colors.grey.withOpacity(0.2),
//                     //         borderRadius: BorderRadius.only(
//                     //           topLeft: const Radius.circular(14),
//                     //           topRight: const Radius.circular(14),
//                     //           bottomLeft: Radius.circular(isMe ? 14 : 0),
//                     //           bottomRight: Radius.circular(isMe ? 0 : 14),
//                     //         ),
//                     //       ),
//                     //       child: Column(
//                     //         crossAxisAlignment: CrossAxisAlignment.end,
//                     //         children: [
//                     //           Text(
//                     //             msg['text'],
//                     //             style: GoogleFonts.lato(
//                     //               color: isMe ? Colors.white : Colors.black87,
//                     //               fontSize: 15,
//                     //             ),
//                     //           ),
//                     //           const SizedBox(height: 4),
//                     //           Text(
//                     //             timeStr,
//                     //             style: GoogleFonts.lato(
//                     //               fontSize: 10,
//                     //               color: isMe
//                     //                   ? Colors.white70
//                     //                   : Colors.grey.shade600,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // );
//                     return TerminalMessage(
//                       username: isMe ? "You" : receiverName ?? "User",
//                       message: msg['text'],
//                       isMe: isMe,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           // --- Message Input ---
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 10.0,
//                 vertical: 8.0,
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       style: GoogleFonts.lato(fontSize: 16),
//                       decoration: InputDecoration(
//                         hintText: "Message...",
//                         filled: true,
//                         // fillColor: primaryColor.withOpacity(3),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 12,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(24),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       minLines: 1,
//                       maxLines: 5,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: sendMessage,
//                     child: CircleAvatar(
//                       radius: 24,
//                       backgroundColor: primaryColor,
//                       child: const Icon(
//                         Icons.send_rounded,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   // IconButton(
//                   //   icon: const Icon(Icons.emoji_emotions_outlined),
//                   //   onPressed: () {},
//                   //   color: Colors.grey[600],
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
