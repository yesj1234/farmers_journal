import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';

abstract class DefaultImageRepository {
  Future<DefaultImage> getDefaultImage();
}

abstract class UserRepository {
  Future<User?> getUser();
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
