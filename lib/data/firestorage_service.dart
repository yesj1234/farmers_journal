import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:firebase_storage/firebase_storage.dart';

part 'firestorage_service.g.dart';

@riverpod
Future<String> defaultImage(Ref ref) async {
  final storageRef = FirebaseStorage.instance.ref();
  final String url = await storageRef.child('/farmer.png').getDownloadURL();
  // URL validation - is image file
  return url;
}
