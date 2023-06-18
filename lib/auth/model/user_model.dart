import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  String password;
  String photoUrl;
  int subscriberCount;
  List<String> subscriptionList;
  String token;
  DateTime createdAt;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.photoUrl,
    this.subscriberCount = 0,
    this.subscriptionList = const [],
    this.token = "",
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
      'subscriberCount': subscriberCount,
      'subscriptionList': subscriptionList,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      subscriberCount: map['subscriberCount'] ?? 0,
      subscriptionList: List<String>.from(map['subscriptionList'] ?? []),
      token: map['token'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, password: $password, photoUrl: $photoUrl, subscriberCount: $subscriberCount, subscriptionList: $subscriptionList, token: $token, createdAt: $createdAt)';
  }
}
