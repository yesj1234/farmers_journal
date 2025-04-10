/// {@category Domain}
/// Abstract class for report repository.md
///
abstract class ReportRepository {
  Future<void> reportJournal(
      {required String journalId,
      required String writerId,
      required String reason});
  Future<void> reportComment(
      {required String journalId,
      required String writerId,
      required String reason});
}
