import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatId;
  final String userId;
  final String username;
  final String profilePic;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.chatId,
    required this.userId,
    required this.username,
    required this.profilePic,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data, String chatId) {
    return ChatModel(
      chatId: chatId,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      profilePic: data['profilePic'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime:
          (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'profilePic': profilePic,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
