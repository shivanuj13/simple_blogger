import 'dart:convert';

class PostModel {
  String id;
  String title;
  String content;
  String photoUrl;
  DateTime createdAt;
  String createdByUid;
  String author;
  List<String> likedByUid;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.photoUrl,
    required this.createdAt,
    required this.createdByUid,
    required this.author,
    required this.likedByUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'photoUrl': photoUrl,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      createdByUid: map['createdByUid'] ?? '',
      author: map['author'] ?? '',
      likedByUid: List<String>.from(map['likedByUid']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostModel(id: $id, title: $title, content: $content, photoUrl: $photoUrl, createdAt: $createdAt, createdByUid: $createdByUid, author: $author, likedByUid: $likedByUid)';
  }
}
