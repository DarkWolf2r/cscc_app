class ProjectModel {
  final String? id;
  final String title;
  final String description;
  final String department;
  final List<String> imageUrls; // multiple images
  final List<String> videoUrls; // multiple videos
  final String? link; // e.g. GitHub or project link
  final String senderName;
  final String senderImage;

  ProjectModel({
    this.id,
    required this.title,
    required this.description,
    required this.department,
    this.imageUrls = const [],
    this.videoUrls = const [],
    this.link,
    required this.senderName,
    required this.senderImage,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      department: map['department'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      videoUrls: List<String>.from(map['videoUrls'] ?? []),
      link: map['link'],
      senderName: map['senderName'] ?? '',
      senderImage: map['senderImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'department': department,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'link': link,
      'senderName': senderName,
      'senderImage': senderImage,
    };
  }
}
