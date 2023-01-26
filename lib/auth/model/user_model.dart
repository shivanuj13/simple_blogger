import 'dart:convert';

class UserModel {
  String uid;
  String name;
  String email;
  String photoUrl;
  DateTime joinedAt;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'joinedAt': joinedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      joinedAt: DateTime.fromMillisecondsSinceEpoch(map['joinedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $uid, name: $name, email: $email, photoUrl: $photoUrl, joinedAt: $joinedAt)';
  }
}
