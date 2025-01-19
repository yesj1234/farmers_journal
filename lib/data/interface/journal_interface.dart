import 'package:farmers_journal/domain/model/journal.dart';

abstract class JournalRepository {
  Future<Journal> getJournal(String id);
  Future<List<Journal>> getJournals(List<String> ids);
}
