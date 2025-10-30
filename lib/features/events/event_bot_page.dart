import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventBotPage extends StatefulWidget {
  const EventBotPage({super.key});

  @override
  State<EventBotPage> createState() => _EventBotPageState();
}

class _EventBotPageState extends State<EventBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // {"sender": "user/bot", "text": ""}
  Map<String, dynamic>? eventData;

  @override
  void initState() {
    super.initState();
    _loadLatestEvent();
  }

  /// 🧩 Load the latest event from Firestore
  Future<void> _loadLatestEvent() async {
    final events = await FirebaseFirestore.instance
        .collection('events')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (events.docs.isNotEmpty) {
      setState(() {
        eventData = events.docs.first.data();
      });
    }
  }

  /// 🤖 Bot logic
  Future<void> _handleUserMessage(String text) async {
    setState(() {
      _messages.add({"sender": "user", "text": text});
    });

    final response = await _getBotResponse(text);

    setState(() {
      _messages.add({"sender": "bot", "text": response});
    });
  }

  /// 💬 Generate a bot response
  Future<String> _getBotResponse(String text) async {
    if (eventData == null) {
      return "I don’t have any event info yet. Please wait for a Chef Event to create one.";
    }

    final lower = text.toLowerCase();
    final name = eventData!["name"];
    final time = eventData!["time"];
    final place = eventData!["place"];
    final info = eventData!["info"];
    final roles = eventData!["roles"] as Map<String, dynamic>;

    // --- Answer basic questions ---
    if (lower.contains("event") && lower.contains("name")) return "📛 The event name is '$name'.";
    if (lower.contains("when") || lower.contains("time")) return "🕒 The event is scheduled for $time.";
    if (lower.contains("where") || lower.contains("place")) return "📍 The event will be held at $place.";
    if (lower.contains("info") || lower.contains("about")) return "ℹ️ $info";

    // --- List roles ---
    if (lower.contains("roles") || lower.contains("positions")) {
      String list = roles.entries.map((e) => "• ${e.key}: ${e.value}").join("\n");
      return "Here are the available roles:\n$list";
    }

    // --- Assign user to a role ---
    for (final role in roles.keys) {
      if (lower.contains(role.toLowerCase())) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return "You need to sign in first.";

        await _assignUserToRole(user.uid, user.email ?? "unknown", role);

        return "✅ You’ve been added as a '$role' for '$name'.";
      }
    }

    return "🤖 Sorry, I didn’t understand. You can ask things like:\n• When is the event?\n• Where is it?\n• What roles are available?\n• I’m a designer";
  }

  /// 🧑‍🤝‍🧑 Assign the user to a role
  Future<void> _assignUserToRole(String uid, String email, String role) async {
    final eventsRef = FirebaseFirestore.instance.collection('events');
    final eventIdQuery = await eventsRef.orderBy('createdAt', descending: true).limit(1).get();

    if (eventIdQuery.docs.isEmpty) return;

    final eventId = eventIdQuery.docs.first.id;

    await eventsRef.doc(eventId).collection('members').doc(uid).set({
      "email": email,
      "role": role,
      "joinedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🧠 UI rendering
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Assistant 🤖"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["sender"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Ask the bot something...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () {
                    if (_controller.text.trim().isEmpty) return;
                    _handleUserMessage(_controller.text.trim());
                    _controller.clear();
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
