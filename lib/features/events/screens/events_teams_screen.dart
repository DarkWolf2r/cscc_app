import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventTeamsScreen extends StatefulWidget {
  final String eventId;
  final String userType;

  const EventTeamsScreen({
    super.key,
    required this.eventId,
    required this.userType,
  });

  @override
  State<EventTeamsScreen> createState() => _EventTeamsScreenState();
}

class _EventTeamsScreenState extends State<EventTeamsScreen> {
  late final eventRef =
      FirebaseFirestore.instance.collection('events').doc(widget.eventId);

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
              final teams =
                  (data['teams'] ?? []).cast<Map<String, dynamic>>();

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

  Future<void> _removeMember(String teamName, String userId) async {
    final doc = await eventRef.get();
    final data = doc.data()!;
    final teams = (data['teams'] as List).cast<Map<String, dynamic>>();

    final teamIndex =
        teams.indexWhere((t) => t['name'].toString() == teamName);
    if (teamIndex == -1) return;

    final members =
        List<Map<String, dynamic>>.from(teams[teamIndex]['members'] ?? []);
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
    final isChef = widget.userType == "Chef Events" ||
        widget.userType == "Chef Logistic";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Teams",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          if (isChef)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTeamDialog,
            ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: eventRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          if (data == null || data['teams'] == null) {
            return const Center(child: Text("No teams found."));
          }

          final teams = (data['teams'] as List).cast<Map<String, dynamic>>();

          return ListView.builder(
            itemCount: teams.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final team = teams[index];
              final members = (team['members'] ?? []) as List<dynamic>;

              return ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                backgroundColor: Colors.grey.shade100,
                title: Text(
                  team['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(team['description'] ?? ''),
                trailing: isChef
                    ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTeam(team['name']),
                      )
                    : null,
                children: [
                  if (members.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("No members yet.",
                          style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ...members.map((m) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(m['profilePic']),
                        ),
                        title: Text(m['name']),
                        trailing: isChef
                            ? IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.redAccent),
                                onPressed: () =>
                                    _removeMember(team['name'], m['uid']),
                              )
                            : null,
                      );
                    }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
