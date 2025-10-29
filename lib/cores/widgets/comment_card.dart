import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profilePic = snap['profilePic'] ?? '';
    final name = snap['name'] ?? 'Unknown';
    final text = snap['text'] ?? '';
    final timestamp = snap['datePublished'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: profilePic.isNotEmpty
                ? NetworkImage(profilePic)
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
            radius: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                        text: name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' $text'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp != null
                      ? DateFormat.yMMMd().format(timestamp.toDate())
                      : '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 18, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
