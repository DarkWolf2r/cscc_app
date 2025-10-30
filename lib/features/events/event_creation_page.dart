import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  DateTime? selectedDate;

  List<Map<String, String>> roles = []; // {name: "Designer", desc: "Creates posters"}

  void addRole() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController roleName = TextEditingController();
        final TextEditingController roleDesc = TextEditingController();

        return AlertDialog(
          title: const Text("Add Role"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: roleName,
                decoration: const InputDecoration(labelText: "Role Name"),
              ),
              TextField(
                controller: roleDesc,
                decoration: const InputDecoration(labelText: "Role Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (roleName.text.isNotEmpty && roleDesc.text.isNotEmpty) {
                  setState(() {
                    roles.add({
                      "name": roleName.text.trim(),
                      "desc": roleDesc.text.trim(),
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final eventId = FirebaseFirestore.instance.collection('events').doc().id;

      await FirebaseFirestore.instance.collection('events').doc(eventId).set({
        "name": nameController.text.trim(),
        "place": placeController.text.trim(),
        "info": infoController.text.trim(),
        "time": selectedDate?.toIso8601String() ?? "",
        "roles": {for (var r in roles) r["name"]!: r["desc"]!},
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Event Created Successfully!")),
      );

      // Clear form
      nameController.clear();
      placeController.clear();
      infoController.clear();
      setState(() {
        roles.clear();
        selectedDate = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Event"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Event Name"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter event name" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: placeController,
                  decoration: const InputDecoration(labelText: "Place"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter place" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: infoController,
                  decoration: const InputDecoration(labelText: "Event Info"),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // 🕒 Date Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "No date selected"
                          : "Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(selectedDate!)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: const Text("Select Date & Time"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🧩 Roles List
                const Text(
                  "Roles:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                ...roles.map((r) => ListTile(
                      title: Text(r["name"]!),
                      subtitle: Text(r["desc"]!),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            roles.remove(r);
                          });
                        },
                      ),
                    )),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: addRole,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Role"),
                ),

                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: createEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text(
                      "Create Event",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
