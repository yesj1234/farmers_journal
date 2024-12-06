import 'package:farmers_journal/data/interfaces.dart';
import 'package:farmers_journal/data/repositories.dart';
import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Models

import 'package:farmers_journal/domain/model/journal.dart';

part 'firestore_service.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FireStoreUserRepository(instance: FirebaseFirestore.instance);
});

@riverpod
Future<User?> user(Ref ref) async {
  final repository = ref.read(userRepositoryProvider);
  return repository.getUsers();
}

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return FireStoreJournalRepository(instance: FirebaseFirestore.instance);
});

@Riverpod(keepAlive: true)
Future<List<Journal>> journal(Ref ref) async {
  final repository = ref.read(journalRepositoryProvider);
  return repository.getJournals();
}

// @riverpod
// Future<DefaultImageRepository> defaultImageRepository(Ref ref) async {
//   return FireStoreDefaultImageRepository(instance: FirebaseFirestore.instance);
// }
final defaultImageRepositoryProvider = Provider<DefaultImageRepository>((ref) {
  return FireStoreDefaultImageRepository(instance: FirebaseFirestore.instance);
});

@riverpod
Future<DefaultImage> defaultImage(Ref ref) async {
  final repository = ref.read(defaultImageRepositoryProvider);
  return repository.getDefaultImage();
}
