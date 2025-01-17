import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/plant.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

abstract class DefaultImageRepository {
  Future<DefaultImage> getDefaultImage();
}

abstract class AuthRepository {
  User? getCurrentUser();
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });
  Future<void> signInWithApple();
  Future<void> signInWithKakaoTalk();
  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<void> signOut();
  Future<void> resetPassword({
    required String email,
  });
  Future<void> deleteAccount();
  Future<void> setProfileImage({required Uint8List bytes});
  Future<void> setProfileName({required String name});
}

abstract class UserRepository {
  Future<AppUser?> getUser();
  Future<void> setProfileImage({required Uint8List bytes});
  Future<void> editProfile(
      {String? name, String? nickName, XFile? profileImage});
  Future<void> setPlant(
      {required String? id,
      required String? newPlantName,
      required String code});
  Future<void> setPlace({required String? id, required String? newPlantPlace});
  Future<void> setPlantAndPlace({required Plant plant});

  Future<List<Journal?>> getJournals();

  Future<List<Journal?>> createJournal({
    required String title,
    required String content,
    required DateTime date,
    required List<String>? images,
  });
  Future<List<Journal?>> updateJournal({
    required String id,
    required String title,
    required String content,
    required DateTime date,
    required List<String?>? images,
  });
  Future<List<Journal?>> deleteJournal({required String id});
  Future<List<Journal?>> getJournalsByYear({required int year});
}

abstract class JournalRepository {
  Future<Journal> getJournal(String id);
  Future<List<Journal>> getJournals(List<String> ids);
}
