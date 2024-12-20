import 'package:flutter/cupertino.dart';

class Journal {
  final String? id;
  final String? title;
  final String? content;
  final List<String?>? images;
  final DateTime? createdAt;

  Journal({this.id, this.title, this.content, this.images, this.createdAt});

  // model은 외부 패키지에 종속성이 생기지 않도록 dart로만 구성.
  factory Journal.fromJson(
    Map<String, dynamic> map,
  ) {
    int createdAt = map['createdAt'];
    DateTime toDateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
    List<String?>? images =
        map['images'] is Iterable ? List.from(map['images']) : null;

    return Journal(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        images: images,
        createdAt: toDateTime);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      if (title != null) "title": title,
      if (content != null) "content": content,
      if (images != null) "images": images,
      if (createdAt != null) "createdAt": createdAt?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'Instance of "Journal"\ntitle: $title\ncontent: $content\nimage: $images\ncreatedAt: $createdAt';
  }
}
