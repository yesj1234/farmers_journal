import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/src/data/repositories/comment_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/interface/comment_interface.dart';
import 'providers.dart';
import 'repositories/auth_repository.dart';
import 'repositories/default_image_repository.dart';
import 'repositories/journal_repository.dart';
import 'repositories/report_repository.dart';
import 'repositories/user_repository.dart';
import '../domain/interface/auth_interface.dart';
import '../domain/interface/default_image_interface.dart';
import '../domain/interface/journal_interface.dart';
import '../domain/interface/report_interface.dart';
import '../domain/interface/user_interface.dart';

part 'firestore_providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository.setLanguage(
      instance: FirebaseAuth.instance, logger: ref.read(loggerProvider));
}

@riverpod
UserRepository userRepository(Ref ref) {
  return FireStoreUserRepository(
    ref,
    instance: FirebaseFirestore.instance,
  );
}

@riverpod
ReportRepository reportRepository(Ref ref) {
  return FireStoreReportRepository(instance: FirebaseFirestore.instance);
}

@riverpod
JournalRepository journalRepository(Ref ref) {
  return FireStoreJournalRepository(instance: FirebaseFirestore.instance);
}

@riverpod
CommentRepository commentRepository(Ref ref) {
  return FireStoreCommentRepository(instance: FirebaseFirestore.instance);
}

@riverpod
DefaultImageRepository defaultImageRepository(Ref ref) {
  return FireStoreDefaultImageRepository(instance: FirebaseFirestore.instance);
}
