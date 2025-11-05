// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class EditEventScreen extends StatefulWidget {
//   final String eventId;
//   final Map<String, dynamic> eventData;

//   const EditEventScreen({
//     super.key,
//     required this.eventId,
//     required this.eventData,
//   });

//   @override
//   State<EditEventScreen> createState() => _EditEventScreenState();
// }

// class _EditEventScreenState extends State<EditEventScreen> {
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _placeController;
//   DateTime? _selectedDate;
//   bool _isSaving = false;

//   // List of teams (each team: {'name': '', 'description': ''})
//   List<Map<String, dynamic>> _teams = [];

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.eventData['title']);
//     _descriptionController = TextEditingController(text: widget.eventData['description']);
//     _placeController = TextEditingController(text: widget.eventData['place']);
//     _selectedDate = (widget.eventData['date'] != null)
//         ? DateTime.tryParse(widget.eventData['date'])
//         : null;

//     final List<dynamic>? teamsData = widget.eventData['teams'];
//     _teams = (teamsData != null)
//         ? List<Map<String, dynamic>>.from(teamsData)
//         : [];
//   }

//   Future<void> _saveChanges() async {
//     setState(() => _isSaving = true);
//     try {
//       await FirebaseFirestore.instance
//           .collection('events')
//           .doc(widget.eventId)
//           .update({
//         'title': _titleController.text.trim(),
//         'description': _descriptionController.text.trim(),
//         'place': _placeController.text.trim(),
//         'date': _selectedDate?.toIso8601String(),
//         'teams': _teams,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Event updated successfully!')),
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Failed to update event: $e')),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   void _addTeamDialog() {
//     final nameController = TextEditingController();
//     final descController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Add New Team"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Team Name"),
//             ),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: "Team Description"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final name = nameController.text.trim();
//               final desc = descController.text.trim();
//               if (name.isNotEmpty && desc.isNotEmpty) {
//                 setState(() {
//                   _teams.add({
//                     'name': name,
//                     'description': desc,
//                     'members': [],
//                   });
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _editTeamDialog(int index) {
//     final nameController = TextEditingController(text: _teams[index]['name']);
//     final descController =
//         TextEditingController(text: _teams[index]['description']);

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Edit Team"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Team Name"),
//             ),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: "Team Description"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final name = nameController.text.trim();
//               final desc = descController.text.trim();
//               if (name.isNotEmpty && desc.isNotEmpty) {
//                 setState(() {
//                   _teams[index]['name'] = name;
//                   _teams[index]['description'] = desc;
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _deleteTeam(int index) {
//     setState(() {
//       _teams.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Event')),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blueAccent,
//         onPressed: _addTeamDialog,
//         child: const Icon(Icons.add),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // TITLE
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(labelText: 'Title'),
//             ),
//             const SizedBox(height: 10),

//             // DESCRIPTION
//             TextField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 10),

//             // PLACE
//             TextField(
//               controller: _placeController,
//               decoration: const InputDecoration(labelText: 'Place'),
//             ),
//             const SizedBox(height: 10),

//             // DATE PICKER
//             Row(
//               children: [
//                 Text(
//                   _selectedDate == null
//                       ? '📅 No date selected'
//                       : '📅 Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const Spacer(),
//                 ElevatedButton.icon(
//                   onPressed: () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: _selectedDate ?? DateTime.now(),
//                       firstDate: DateTime(2023),
//                       lastDate: DateTime(2035),
//                     );
//                     if (picked != null) {
//                       setState(() => _selectedDate = picked);
//                     }
//                   },
//                   icon: const Icon(Icons.calendar_today),
//                   label: const Text("Select Date"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // TEAMS SECTION
//             const Text(
//               "Teams",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const Divider(),

//             if (_teams.isEmpty)
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text("No teams added yet."),
//               ),

//             for (int i = 0; i < _teams.length; i++)
//               Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 margin: const EdgeInsets.symmetric(vertical: 6),
//                 child: ListTile(
//                   title: Text(_teams[i]['name']),
//                   subtitle: Text(_teams[i]['description']),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit, color: Colors.blueAccent),
//                         onPressed: () => _editTeamDialog(i),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.redAccent),
//                         onPressed: () => _deleteTeam(i),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 20),

//             // SAVE BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isSaving ? null : _saveChanges,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 child: _isSaving
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                         '💾 Save Changes',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
