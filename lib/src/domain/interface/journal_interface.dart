import 'package:farmers_journal/src/domain/model/journal.dart';

/// {@category Domain}
/// Abstract class for journal repository.md
///
abstract class JournalRepository {
  Future<Journal> getJournal(String id);
  Future<List<Journal>> getJournals(List<String> ids);

  Future<List<Journal>> fetchPaginatedJournals({Journal? lastJournal});
  Future<void> reportJournal({required String id, required String userId});
}
