import 'package:farmers_journal/data/firestore_providers.dart';
import 'package:farmers_journal/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/model/journal.dart';
import 'week_view_state.dart';

part 'week_view_controller.g.dart';

@Riverpod(keepAlive: true)
class WeekViewController extends _$WeekViewController {
  List<Journal?> _journals = [];
  @override
  WeekViewState build() {
    initialFetch();
    return const WeekViewState.initial();
  }

  void initialFetch() async {
    final repository = ref.read(userRepositoryProvider);

    try {
      state = const WeekViewState.loading();
      List<Journal?> journals = await repository.getJournals();
      if (journals.isEmpty) {
        _journals = journals;
      }
      final sortedJournals = CustomDateUtils.groupItemsByWeek(journals);
      state = WeekViewState.data(sortedJournals);
    } catch (e, st) {
      state = WeekViewState.error(e, st);
    }
  }
}
