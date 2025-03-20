/// {@category Domain}
/// Abstract class for report repository
///
abstract class ReportRepository {
  Future<void> reportJournal(
      {required String journalId,
      required String writerId,
      required String reason});
}
