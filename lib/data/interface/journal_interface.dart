import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/domain/model/journal.dart';

abstract class JournalRepository {
  Future<Journal> getJournal(String id);
  Future<List<Journal>> getJournals(List<String> ids);
  Future<List<Journal>> getPaginatedJournals(
      {required int pageSize, required DocumentSnapshot? lastDocument});
}
