import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? id;
  final String? writerId;
  final String? content;
  final DateTime? createdAt;
  Comment({
    this.id,
    this.writerId,
    this.content,
    this.createdAt,
  });
  factory Comment.fromJson(Map<String, dynamic> map) {
    String? id = map['id'];
    String? writerId = map['writerId'];
    String? content = map['content'];

    Timestamp createdAt = map['createdAt'];
    DateTime createdAtDateTime = createdAt.toDate();

    return Comment(
        id: id,
        writerId: writerId,
        content: content,
        createdAt: createdAtDateTime);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? '',
      "writerId": writerId ?? '',
      "content": content ?? '',
      "createdAt": createdAt ?? DateTime.now(),
    };
  }

  Comment copyWith({
    String? id,
    String? writerId,
    String? content,
    DateTime? createdAt,
  }) {
    return Comment(
        id: id ?? this.id,
        writerId: writerId ?? this.writerId,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt);
  }
}
