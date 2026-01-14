import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final String userId;
  final String userName;
  final String profilePic;
  final String userType;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.profilePic,
    required this.userType,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late final eventRef = FirebaseFirestore.instance
      .collection('events')
      .doc(widget.eventId);

  bool get isChef =>
      widget.userType == "Chef Events" || widget.userType == "Chef Logistic";

  Future<void> _editEventDialog(Map<String, dynamic> data) async {
    final titleCtrl = TextEditingController(text: data['title']);
    final descCtrl = TextEditingController(text: data['description']);
    final placeCtrl = TextEditingController(text: data['place']);
    DateTime? selectedDate = data['date'] != null
        ? DateTime.tryParse(data['date'])
        : null;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Event"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: placeCtrl,
                decoration: const InputDecoration(labelText: "Place"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    selectedDate == null
                        ? '📅 No date selected'
                        : '📅 ${selectedDate?.toLocal().toString().split(' ')[0]}',
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await eventRef.update({
                'title': titleCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'place': placeCtrl.text.trim(),
                'date': selectedDate?.toIso8601String(),
              });
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _addTeamDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Team"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Team Name"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              final doc = await eventRef.get();
              final data = doc.data() ?? {};
              final teams = (data['teams'] ?? []).cast<Map<String, dynamic>>();

              teams.add({
                'name': nameController.text.trim(),
                'description': descController.text.trim(),
                'members': [],
              });

              await eventRef.update({'teams': teams});
              Navigator.of(context).pop();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _joinTeam(String teamName) async {
    final doc = await eventRef.get();
    final data = doc.data()!;
    final teams = (data['teams'] as List).cast<Map<String, dynamic>>();
    final teamIndex = teams.indexWhere((t) => t['name'] == teamName);
    if (teamIndex == -1) return;

    final members = List<Map<String, dynamic>>.from(
      teams[teamIndex]['members'] ?? [],
    );
    if (members.any((m) => m['uid'] == widget.userId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You're already in that team!")),
      );
      return;
    }

    members.add({
      'uid': widget.userId,
      'name': widget.userName,
      'profilePic': widget.profilePic,
    });

    teams[teamIndex]['members'] = members;
    await eventRef.update({'teams': teams});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("✅ Joined ${teamName}!")));
  }

  Future<void> _removeMember(String teamName, String userId) async {
    final doc = await eventRef.get();
    final data = doc.data()!;
    final teams = (data['teams'] as List).cast<Map<String, dynamic>>();

    final teamIndex = teams.indexWhere((t) => t['name'].toString() == teamName);
    if (teamIndex == -1) return;

    final members = List<Map<String, dynamic>>.from(
      teams[teamIndex]['members'] ?? [],
    );
    members.removeWhere((m) => m['uid'] == userId);
    teams[teamIndex]['members'] = members;

    await eventRef.update({'teams': teams});
  }

  Future<void> _deleteTeam(String teamName) async {
    final doc = await eventRef.get();
    final data = doc.data()!;
    final teams = (data['teams'] as List).cast<Map<String, dynamic>>();
    teams.removeWhere((t) => t['name'] == teamName);
    await eventRef.update({'teams': teams});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Details",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          if (isChef)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final data = (await eventRef.get()).data();
                if (data != null) _editEventDialog(data);
              },
            ),
        ],
      ),
      floatingActionButton: isChef
          ? FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: _addTeamDialog,
              child: const Icon(Icons.add),
            )
          : null,
      body: StreamBuilder<DocumentSnapshot>(
        stream: eventRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          if (data == null)
            return const Center(child: Text("Event not found."));

          final teams = (data['teams'] ?? []).cast<Map<String, dynamic>>();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Info
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data['description'] ?? "",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text("📍 ${data['place'] ?? 'Unknown place'}"),
                        Text(
                          data['date'] != null
                              ? "📅 ${DateTime.tryParse(data['date'])?.toLocal().toString().split(' ')[0]}"
                              : "📅 Date not set",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Teams",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                if (teams.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("No teams yet."),
                  ),

                ...teams.map((team) {
                  final members = (team['members'] ?? []) as List<dynamic>;
                  final userInTeam = members.any(
                    (m) => m['uid'].toString() == widget.userId,
                  );

                  return ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: primaryColor,
                    title: Text(
                      team['name'] ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(team['description'] ?? ''),
                    trailing: isChef
                        ? IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _deleteTeam(team['name']),
                          )
                        : null,
                    children: [
                      if (members.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "No members yet.",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        )
                      else
                        ...members.map(
                          (m) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                m['profilePic'] ?? '',
                              ),
                            ),
                            title: Text(m['name'] ?? ''),
                            trailing: isChef
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        _removeMember(team['name'], m['uid']),
                                  )
                                : null,
                          ),
                        ),
                      if (!isChef && !userInTeam)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.group_add),
                            label: const Text("Join Team"),
                            onPressed: () => _joinTeam(team['name']),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
