import 'dart:convert';

class PostModel {
  String uid;
  String title;
  String content;
  String photoUrl;
  DateTime createdAt;
  String createdByUid;
  List<String> likedByUid;
  
  PostModel({
    required this.uid,
    required this.title,
    required this.content,
    required this.photoUrl,
    required this.createdAt,
    required this.createdByUid,
    required this.likedByUid,
  });



  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'content': content,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'createdByUid': createdByUid,
      'likedByUid': likedByUid,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      createdByUid: map['createdByUid'] ?? '',
      likedByUid: List<String>.from(map['likedByUid']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostModel(uid: $uid, title: $title, content: $content, photoUrl: $photoUrl, createdAt: $createdAt, createdByUid: $createdByUid, likedByUid: $likedByUid)';
  }
}
