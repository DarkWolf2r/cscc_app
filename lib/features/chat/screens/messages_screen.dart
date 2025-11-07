// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/features/auth/model/user_model.dart';
// import 'package:cscc_app/features/chat/widgets/bottom_chat_field.dart';
// import 'package:cscc_app/features/chat/widgets/chat_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:whatsapp_ui/common/utils/colors.dart';
// // import 'package:whatsapp_ui/common/widgets/loader.dart';
// // import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
// // import 'package:whatsapp_ui/features/call/controller/call_controller.dart';
// // import 'package:whatsapp_ui/features/call/screens/call_pickup_screen.dart';

// class MobileChatScreen extends ConsumerWidget {
//   static const String routeName = '/mobile-chat-screen';
//   final String name;
//   final String uid;
//   final bool isGroupChat;
//   final String profilePic;
//   const MobileChatScreen({
//     Key? key,
//     required this.name,
//     required this.uid,
//     required this.isGroupChat,
//     required this.profilePic,
//   }) : super(key: key);

//   // void makeCall(WidgetRef ref, BuildContext context) {
//   //   ref.read(callControllerProvider).makeCall(
//   //         context,
//   //         name,
//   //         uid,
//   //         profilePic,
//   //         isGroupChat,
//   //       );
//   // }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // return CallPickupScreen(
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: primaryColor,
//           title: isGroupChat
//               ? Text(name)
//               : StreamBuilder<UserModel>(
//                   stream: ref.read(authControllerProvider).userDataById(uid),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       // return const Loader();
//                     }
//                     return Column(
//                       children: [
//                         Text(name),
//                         Text(
//                           snapshot.data!.isOnline ? 'online' : 'offline',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//           centerTitle: false,
//           actions: [
//             // IconButton(
//             //   onPressed: () => makeCall(ref, context),
//             //   icon: const Icon(Icons.video_call),
//             // ),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.call),
//             ),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.more_vert),
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ChatList(
//                 recieverUserId: uid,
//                 isGroupChat: isGroupChat,
//               ),
//             ),
//             BottomChatField(
//               recieverUserId: uid,
//               isGroupChat: isGroupChat,
//             ),
//           ],
//         ),
//       // ),
//     );
//   }
// }



// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/features/chat/controller/messages_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cscc_app/cores/colors.dart';
// import '../../screens/chat_screen.dart';
// import '../controller/messages_controller.dart';

// class MessagesScreen extends ConsumerWidget {
//   const MessagesScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.read(messagesControllerProvider);
//     final currentUserId = controller.currentUserId;

//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: primaryColor,
//             floating: true,
//             snap: true,
//             elevation: 0,
//             title: Text(
//               "Messages",
//               style: GoogleFonts.lato(
//                 textStyle: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w900,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           SliverFillRemaining(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surface,
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(16),
//                 ),
//               ),
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: controller.chatsStream(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final chats = snapshot.data!.docs;

//                   if (chats.isEmpty) {
//                     return const Center(child: Text("No conversations yet"));
//                   }

//                   return ListView.builder(
//                     itemCount: chats.length,
//                     itemBuilder: (context, index) {
//                       final chat = chats[index];
//                       final users = List<String>.from(chat['users']);
//                       final otherUserId =
//                           users.firstWhere((id) => id != currentUserId);

//                       return FutureBuilder<DocumentSnapshot>(
//                         future: controller.getUserData(otherUserId),
//                         builder: (context, userSnap) {
//                           if (!userSnap.hasData) {
//                             return const SizedBox.shrink();
//                           }

//                           final userData =
//                               userSnap.data!.data() as Map<String, dynamic>;
//                           final username = userData['username'] ?? 'User';
//                           final profilePic = userData['profilePic'] ?? '';

//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: profilePic.isNotEmpty
//                                   ? CachedNetworkImageProvider(profilePic)
//                                   : null,
//                               backgroundColor: Colors.grey[300],
//                               radius: 25,
//                             ),
//                             title: Text(
//                               username,
//                               style: GoogleFonts.lato(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             subtitle: Text(
//                               chat['lastMessage'] ?? '',
//                               style: TextStyle(color: Colors.grey[600]),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             trailing: Text(
//                               _formatTime(chat['lastMessageTime']),
//                               style: TextStyle(
//                                 color: Colors.grey[500],
//                                 fontSize: 12,
//                               ),
//                             ),
//                             onTap: () {
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (_) => ChatScreen(
//                               //       chatId: chat['chatId'],
//                               //       receiverId: otherUserId,
//                               //     ),
//                               //   ),
//                               // );
//                             },
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatTime(Timestamp? timestamp) {
//     if (timestamp == null) return '';
//     final date = timestamp.toDate();
//     final hours = date.hour.toString().padLeft(2, '0');
//     final minutes = date.minute.toString().padLeft(2, '0');
//     return "$hours:$minutes";
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/features/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import '../screens/chat_screen.dart';
import 'package:cscc_app/cores/colors.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
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
          SliverFillRemaining(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where('users', arrayContains: currentUserId)
                    .orderBy('lastMessageTime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final chats = snapshot.data!.docs;

                  if (chats.isEmpty) {
                    return const Center(child: Text("No conversations yet"));
                  }

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final users = List<String>.from(chat['users']);
                      final otherUserId = users.firstWhere(
                        (id) => id != currentUserId,
                      );

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(otherUserId)
                            .get(),
                        builder: (context, userSnap) {
                          if (!userSnap.hasData) {
                            return const SizedBox.shrink();
                          }
                          final userData =
                              userSnap.data!.data() as Map<String, dynamic>;
                          final username = userData['username'] ?? 'User';
                          final profilePic = userData['profilePic'] ?? '';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: profilePic.isNotEmpty
                                  ? CachedNetworkImageProvider(profilePic)
                                  : null,
                              backgroundColor: Colors.grey[300],
                              radius: 25,
                            ),
                            title: Text(
                              username,
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              chat['lastMessage'] ?? '',
                              style: TextStyle(color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              _formatTime(chat['lastMessageTime']),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  chatId: chat['chatId'],
                                  receiverId: otherUserId,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }
}
