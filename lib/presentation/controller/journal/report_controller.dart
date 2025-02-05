import 'package:farmers_journal/data/firestore_providers.dart';
import 'package:farmers_journal/presentation/controller/journal/report_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_controller.g.dart';

@riverpod
class ReportController extends _$ReportController {
  @override
  ReportState build() {
    return const ReportState.initial();
  }

  void createReport({
    required String journalId,
    required String writerId,
    required String reason,
  }) {
    state = const ReportState.loading();
    try {
      ref.read(reportRepositoryProvider).reportJournal(
          journalId: journalId, writerId: writerId, reason: reason);
      state = const ReportState.done();
    } catch (error, st) {
      state = ReportState.error(error, st);
    }
  }
}
