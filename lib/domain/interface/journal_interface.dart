import 'package:farmers_journal/domain/model/journal.dart';

/// Abstract class for journal repository
///
abstract class JournalRepository {
  Future<Journal> getJournal(String id);
  Future<List<Journal>> getJournals(List<String> ids);

  Future<List<Journal>> fetchPaginatedJournals({Journal? lastJournal});
  Future<void> reportJournal({required String id, required String userId});
}
