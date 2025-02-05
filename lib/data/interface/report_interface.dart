abstract class ReportRepository {
  Future<void> reportJournal(
      {required String journalId,
      required String writerId,
      required String reason});
}
