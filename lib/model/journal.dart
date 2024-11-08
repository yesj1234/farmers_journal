import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  final String? title;
  final String? content;
  final String? image;
  final Timestamp? createdAt;

  Journal({this.title, this.content, this.image, this.createdAt});

  factory Journal.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Journal(
        title: data?['title'],
        content: data?['content'],
        image: data?['image'],
        createdAt: data?['createdAt']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (content != null) "content": content,
      if (image != null) "image": image,
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
