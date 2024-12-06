import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';

abstract class DefaultImageRepository {
  Future<DefaultImage> getDefaultImage();
}

abstract class UserRepository {
  Future<User?> getUsers();
}

abstract class JournalRepository {
  Future<List<Journal>> getJournals();
}
