import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventChatScreen extends StatefulWidget {
  final String eventId;
  final String userId;
  final String userName;
  final String profilePic;
  final String userType;

  const EventChatScreen({
    super.key,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.profilePic,
    required this.userType,
  });

  @override
  State<EventChatScreen> createState() => _EventChatScreenState();
}

class _EventChatScreenState extends State<EventChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> chat = [];
  Map<String, dynamic>? eventData;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    final doc = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .get();

    if (doc.exists) {
      setState(() {
        eventData = doc.data();
      });
      _introMessage();
    } else {
      setState(() {
        chat.add({'sender': 'bot', 'text': "⚠️ Event not found in database."});
      });
    }
  }

  void _introMessage() {
    if (eventData == null) return;
    final teams = (eventData!['teams'] ?? []) as List<dynamic>;
    final place = eventData!['place'] ?? 'Not set';
    final date = eventData!['date'] ?? 'Not set';

    chat.add({
      'sender': 'bot',
      'text':
          "👋 Welcome ${widget.userName}!\nYou're chatting about *${eventData!['title']}*.\n\n📍 Place: $place\n📅 Date: $date",
    });

    if (teams.isNotEmpty) {
      chat.add({
        'sender': 'bot',
        'text':
            "Here are the teams:\n" +
            teams.map((t) => "• ${t['name']}: ${t['description']}").join("\n"),
      });
    } else {
      chat.add({
        'sender': 'bot',
        'text': "There are no teams yet. Wait for your Chef to add some!",
      });
    }

    setState(() {});
  }

  Future<void> _refreshEvent() async {
    final doc = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .get();
    if (doc.exists) {
      setState(() {
        eventData = doc.data();
      });
    }
  }

  Future<void> _joinTeam(String teamName) async {
    await _refreshEvent();
    final eventRef = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId);
    final teams = (eventData!['teams'] as List).cast<Map<String, dynamic>>();

    final teamIndex = teams.indexWhere(
      (t) => t['name'].toString().toLowerCase() == teamName.toLowerCase(),
    );

    if (teamIndex == -1) {
      _botMessage("❌ No team found with name '$teamName'.");
      return;
    }

    final members = List<Map<String, dynamic>>.from(
      teams[teamIndex]['members'] ?? [],
    );
    if (members.any((m) => m['uid'] == widget.userId)) {
      _botMessage("You're already in the *$teamName* team!");
      return;
    }

    members.add({
      'uid': widget.userId,
      'name': widget.userName,
      'profilePic': widget.profilePic,
    });
    teams[teamIndex]['members'] = members;
    await eventRef.update({'teams': teams});

    _botMessage("✅ You joined the *$teamName* team!");
  }

  Future<void> _addTeam(String content) async {
    if (widget.userType != "Chef Events" &&
        widget.userType != "Chef Logistic") {
      _botMessage("❌ Only Chefs can add teams.");
      return;
    }

    if (!content.contains(":")) {
      _botMessage("⚠️ Use format: add team [name]:[description]");
      return;
    }

    final parts = content.split(":");
    final name = parts[0].trim();
    final desc = parts[1].trim();

    await _refreshEvent();
    final teams = (eventData!['teams'] ?? []).cast<Map<String, dynamic>>();
    teams.add({'name': name, 'description': desc, 'members': []});
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .update({'teams': teams});

    _botMessage("✅ Team '$name' added successfully!");
  }

  void _botMessage(String text) {
    setState(() {
      chat.add({'sender': 'bot', 'text': text});
    });
  }

  Future<void> _handleMessage(String message) async {
    setState(() {
      chat.add({'sender': 'user', 'text': message});
    });

    final lower = message.toLowerCase();

    // --- Commands ---
    if (lower.startsWith("join ")) {
      final teamName = message.substring(5).trim();
      _joinTeam(teamName);
      return;
    }

    if (lower.startsWith("add team ")) {
      final content = message.substring(9).trim();
      _addTeam(content);
      return;
    }

    if (lower.contains("where") || lower.contains("place")) {
      final place = eventData?['place'] ?? "not set yet";
      _botMessage("📍 The event will take place at: *$place*");
      return;
    }

    if (lower.contains("when") || lower.contains("date")) {
      final date = eventData?['date'] ?? "not set yet";
      _botMessage("📅 The event date is: *$date*");
      return;
    }

    if (lower.contains("teams")) {
      final teams = (eventData?['teams'] ?? []) as List<dynamic>;
      if (teams.isEmpty) {
        _botMessage("No teams available yet.");
      } else {
        _botMessage(
          "Here are the teams:\n" +
              teams
                  .map((t) => "• ${t['name']}: ${t['description']}")
                  .join("\n"),
        );
      }
      return;
    }

    if (lower.startsWith("who's in ") || lower.startsWith("who is in ")) {
      final teamName = message.replaceAll(RegExp(r"who('?s)? in "), "").trim();
      final teams = (eventData?['teams'] ?? []) as List<dynamic>;
      final team = teams.firstWhere(
        (t) => t['name'].toString().toLowerCase() == teamName.toLowerCase(),
        orElse: () => {},
      );
      if (team.isEmpty) {
        _botMessage("❌ No team found named '$teamName'.");
      } else {
        final members = team['members'] as List<dynamic>? ?? [];
        if (members.isEmpty) {
          _botMessage("👥 No members yet in *$teamName* team.");
        } else {
          _botMessage(
            "👥 Members of *$teamName*:\n" +
                members.map((m) => "• ${m['name']}").join("\n"),
          );
        }
      }
      return;
    }

    if (lower.contains("help") || lower.contains("what can i do")) {
      _botMessage(
        "🧠 You can ask:\n• 'Where is the event?'\n• 'When is the event?'\n• 'What are the teams?'\n• 'Who’s in [team name]?'\n• 'join [team name]'\n\nChefs can also use:\n• 'add team [name]:[description]'",
      );
      return;
    }

    _botMessage("🤖 I didn’t understand that. Type 'help' for commands.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(eventData?['title'] ?? 'Event Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chat.length,
              itemBuilder: (context, index) {
                final msg = chat[index];
                final isBot = msg['sender'] == 'bot';
                return Align(
                  alignment: isBot
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isBot
                          ? Colors.grey.shade500
                          : Colors.blueAccent.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _handleMessage(_messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
