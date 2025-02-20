import 'package:farmers_journal/data/repositories/auth_repository.dart';
import 'package:farmers_journal/data/repositories/default_image_repository.dart';
import 'package:farmers_journal/data/repositories/journal_repository.dart';
import 'package:farmers_journal/data/repositories/report_repository.dart';
import 'package:farmers_journal/data/repositories/user_repository.dart';
import 'package:farmers_journal/domain/interface/auth_interface.dart';
import 'package:farmers_journal/domain/interface/default_image_interface.dart';
import 'package:farmers_journal/domain/interface/journal_interface.dart';
import 'package:farmers_journal/domain/interface/report_interface.dart';
import 'package:farmers_journal/domain/interface/user_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository.setLanguage(instance: FirebaseAuth.instance);
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
