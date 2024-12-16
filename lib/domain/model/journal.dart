class Journal {
  final String? title;
  final String? content;
  final String? image;
  final DateTime? createdAt;

  Journal({this.title, this.content, this.image, this.createdAt});

  // model은 외부 패키지에 종속성이 생기지 않도록 dart로만 구성.
  factory Journal.fromJson(
    Map<String, dynamic> map,
  ) {
    int createdAt = map['createdAt'];
    DateTime toDateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return Journal(
        title: map['title'],
        content: map['content'],
        image: map['imageURL'],
        createdAt: toDateTime);
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) "title": title,
      if (content != null) "content": content,
      if (image != null) "image": image,
      if (createdAt != null) "createdAt": createdAt?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'Instance of "Journal"\ntitle: $title\ncontent: $content\nimage: $image\ncreatedAt: $createdAt';
  }
}
