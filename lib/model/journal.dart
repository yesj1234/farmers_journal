import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  final String? title;
  final String? content;
  final String? image;
  final Timestamp? createdAt;

  Journal({this.title, this.content, this.image, this.createdAt});

  // model은 외부 패키지에 종속성이 생기지 않도록 dart로만 구성.
  factory Journal.fromMap(
    Map<String, dynamic> map,
    SnapshotOptions? options,
  ) {
    return Journal(
        title: map['title'],
        content: map['content'],
        image: map['image'],
        createdAt: map['createdAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      if (title != null) "title": title,
      if (content != null) "content": content,
      if (image != null) "image": image,
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
