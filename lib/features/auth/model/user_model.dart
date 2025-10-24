
// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  
  final String username;
  final String email;
  final String? profilePic;
  final List<String> departement;
  final String userId;
  final String? description;
  final String type;

  UserModel(
      {
      required this.username,
      required this.email,
      this.profilePic,
      required this.departement,
      required this.userId,
      this.description,
      required this.type});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      
      'username': username,
      'email': email,
      'profilePic': profilePic,
      'departement': departement,
      'userId': userId,
      'description': description,
      'type': type,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      
      username: map['username'] as String,
      email: map['email'] as String,
      profilePic: map['profilePic'] as String,
      departement: List<String>.from(map['departement'] ?? []),
      userId: map['userId'] as String,
      description: map['description'] as String,
      type: map['type'] as String,
    );
  }
}
