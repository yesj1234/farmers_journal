import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  final String? id;
  final String? title;
  final String? content;
  final List<String?>? images;
  final DateTime? createdAt;
  final DateTime? date;
  final String? plant;
  final String? place;
  final String? writer;
  final int? reportCount;
  Journal({
    this.id,
    this.title,
    this.content,
    this.images,
    this.createdAt,
    this.date,
    this.plant,
    this.place,
    this.writer,
    this.reportCount,
  });

  factory Journal.fromJson(
    Map<String, dynamic> map,
  ) {
    Timestamp createdAt = map['createdAt'];
    Timestamp date = map['date'];
    DateTime createdAtDateTime = createdAt.toDate();
    DateTime dateDateTime = date.toDate();
    List<String?>? images =
        map['images'] is Iterable ? List.from(map['images']) : null;

    return Journal(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        plant: map['plant'],
        place: map['place'],
        images: images,
        date: dateDateTime,
        createdAt: createdAtDateTime,
        writer: map['writer'],
        reportCount: map['reportCount']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? '',
      "title": title ?? '',
      "content": content ?? '',
      "plant": plant ?? '',
      'place': place ?? '',
      "images": images ?? [],
      "date": date ?? DateTime.now(),
      "createdAt": createdAt ?? DateTime.now(),
      "writer": writer ?? '',
      "reportCount": reportCount ?? 0,
    };
  }

  @override
  String toString() {
    return 'Instance of "Journal"\ntitle: $title\ncontent: $content\nimage: $images\ncreatedAt: $createdAt';
  }
}
