import 'package:farmers_journal/data/firestore_providers.dart';
import 'package:farmers_journal/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/model/journal.dart';
import 'month_view_state.dart';

part 'month_view_controller.g.dart';

@Riverpod(keepAlive: true)
class MonthViewController extends _$MonthViewController {
  List<Journal?> _journals = [];
  @override
  MonthViewState build() {
    initialFetch();
    return const MonthViewState.initial();
  }

  void initialFetch() async {
    final repository = ref.read(userRepositoryProvider);

    try {
      state = const MonthViewState.loading();
      List<Journal?> journals = await repository.getJournals();
      if (journals.isEmpty) {
        _journals = journals;
      }
      final sortedJournals = CustomDateUtils.getMonthlyJournal(journals);
      state = MonthViewState.data(sortedJournals);
    } catch (e, st) {
      state = MonthViewState.error(e, st);
    }
  }
}
