import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:farmers_journal/src/domain/model/plant.dart';
import 'package:farmers_journal/src/domain/model/user.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/image_type.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// {@category Domain}
/// Abstract class for user repository.md
///
abstract class UserRepository {
  Future<AppUser?> getUser({String? userId});
  Future<void> setProfileImage({required Uint8List bytes});
  Future<void> editProfile(
      {String? name, String? nickName, XFile? profileImage});
  Future<void> setPlant(
      {required String? id,
      required String? newPlantName,
      required String code});
  Future<void> setPlace({required String? id, required String? newPlantPlace});
  Future<void> setInitial({required Plant plant, required String name});

  Future<List<Journal?>> getJournals();

  Future<List<Journal?>> createJournal({
    required String title,
    required String content,
    required DateTime date,
    required List<XFile>? images,
    void Function({int transferred, int totalBytes})? progressCallback,
  });
  Future<List<Journal?>> updateJournal({
    required String id,
    required String title,
    required String content,
    required DateTime date,
    required List<ImageType?>? images,
    void Function({int transferred, int totalBytes})? progressCallback,
  });
  Future<List<Journal?>> deleteJournal({required String id});
  Future<List<Journal?>> getJournalsByYear({required int year});
  Future<AppUser> getUserById({required String id});
  Future<void> blockUser({required String id});
}
