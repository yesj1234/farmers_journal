import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';

abstract class DefaultImageRepository {
  Future<DefaultImage> getDefaultImage();
}

abstract class UserRepository {
  Future<User?> getUsers();
  Future<List<Journal?>> getJournals();
  Future<void> createJournal({
    required String title,
    required String content,
    required DateTime date,
    required String? image,
  });
}

abstract class JournalRepository {
  Future<List<Journal>> getJournals();
}
