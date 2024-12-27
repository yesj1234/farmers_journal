import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/plant.dart';
import 'package:farmers_journal/domain/model/user.dart';

abstract class DefaultImageRepository {
  Future<DefaultImage> getDefaultImage();
}

abstract class AuthRepository {
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });
  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<void> signOut();
  Future<void> resetPassword({
    required String email,
  });
  Future<void> deleteAccount();
}

abstract class UserRepository {
  Future<AppUser?> getUser();
  Future<void> setPlant({required String? id, required String? newPlantName});
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
}

abstract class JournalRepository {
  Future<Journal> getJournal(String id);
  Future<List<Journal>> getJournals(List<String> ids);
}
