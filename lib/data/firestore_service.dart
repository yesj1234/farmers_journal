import 'package:farmers_journal/data/interfaces.dart';
import 'package:farmers_journal/data/repositories/auth_repository.dart';
import 'package:farmers_journal/data/repositories/default_image_repository.dart';
import 'package:farmers_journal/data/repositories/journal_repository.dart';
import 'package:farmers_journal/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'firestore_service.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository.setLanguage(instance: FirebaseAuth.instance);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FireStoreUserRepository(
    ref,
    instance: FirebaseFirestore.instance,
  );
});

@riverpod
Future<AppUser?> user(Ref ref) async {
  final repository = ref.read(userRepositoryProvider);
  return repository.getUser();
}

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return FireStoreJournalRepository(instance: FirebaseFirestore.instance);
});

final defaultImageRepositoryProvider = Provider<DefaultImageRepository>((ref) {
  return FireStoreDefaultImageRepository(instance: FirebaseFirestore.instance);
});
