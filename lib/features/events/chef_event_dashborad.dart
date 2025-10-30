import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChefEventDashboard extends StatefulWidget {
  const ChefEventDashboard({super.key});

  @override
  State<ChefEventDashboard> createState() => _ChefEventDashboardState();
}

class _ChefEventDashboardState extends State<ChefEventDashboard> {
  String? eventId;
  Map<String, dynamic>? eventData;

  @override
  void initState() {
    super.initState();
    _loadLatestEvent();
  }

  /// 🧩 Load latest event
  Future<void> _loadLatestEvent() async {
    final events = await FirebaseFirestore.instance
        .collection('events')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (events.docs.isNotEmpty) {
      setState(() {
        eventId = events.docs.first.id;
        eventData = events.docs.first.data();
      });
    }
  }

  /// 🧠 Fetch members grouped by role
  Stream<Map<String, List<Map<String, dynamic>>>>
  _fetchMembersGroupedByRole() async* {
    if (eventId == null) {
      yield {};
      return;
    }

    final membersStream = FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('members')
        .snapshots();

    await for (var snapshot in membersStream) {
      Map<String, List<Map<String, dynamic>>> grouped = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final role = data['role'] ?? 'Unassigned';
        grouped.putIfAbsent(role, () => []).add(data);
      }

      yield grouped;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (eventData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chef Event Dashboard 👑"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
        stream: _fetchMembersGroupedByRole(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final groupedMembers = snapshot.data!;
          final name = eventData!['name'];
          final time = eventData!['time'];
          final place = eventData!['place'];
          final info = eventData!['info'];
          final roles = eventData!['roles'] as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷 Event info
                  Text(
                    name ?? "Unnamed Event",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("🕒 $time", style: const TextStyle(fontSize: 16)),
                  Text("📍 $place", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("ℹ️ $info", style: const TextStyle(fontSize: 16)),
                  const Divider(height: 30, thickness: 1.2),

                  // 👥 Roles and members
                  ...roles.keys.map((role) {
                    final members = groupedMembers[role] ?? [];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          role.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        subtitle: Text(
                          roles[role] ?? "",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        leading: const Icon(
                          Icons.group,
                          color: Colors.blueAccent,
                        ),
                        children: members.isEmpty
                            ? [
                                const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    "No members yet 😅",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ]
                            : members.map((member) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(member["email"] ?? "Unknown"),
                                  subtitle: Text(
                                    "Joined: ${member["joinedAt"] != null ? (member["joinedAt"] as Timestamp).toDate().toString().split('.')[0] : 'N/A'}",
                                  ),
                                );
                              }).toList(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
