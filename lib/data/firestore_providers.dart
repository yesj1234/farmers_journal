import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository.setLanguage(
      instance: FirebaseAuth.instance, logger: ref.read(loggerProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FireStoreUserRepository(
    ref,
    instance: FirebaseFirestore.instance,
  );
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return FireStoreReportRepository(instance: FirebaseFirestore.instance);
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return FireStoreJournalRepository(instance: FirebaseFirestore.instance);
});

final defaultImageRepositoryProvider = Provider<DefaultImageRepository>((ref) {
  return FireStoreDefaultImageRepository(instance: FirebaseFirestore.instance);
});
