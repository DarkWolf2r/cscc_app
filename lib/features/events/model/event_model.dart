import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String? place;
  final String? date;
  final List<dynamic> teams;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.place,
    this.date,
    this.teams = const [],
  });

  factory EventModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      place: data['place'] ?? '',
      date: data['date'] ?? '',
      teams: data['teams'] ?? [],
    );
  }
}
