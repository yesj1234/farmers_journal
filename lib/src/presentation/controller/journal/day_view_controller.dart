import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:farmers_journal/src/presentation/controller/journal/day_view_state.dart';
import 'package:farmers_journal/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/src/data/firestore_providers.dart';

part 'day_view_controller.g.dart';

/// {@category Controller}
@Riverpod(keepAlive: true)
class DayViewController extends _$DayViewController {
  List<Journal?> _journals = [];

  @override
  DayViewState build() {
    initialFetch();
    return const DayViewState.initial();
  }

  Future<void> initialFetch() async {
    final repository = ref.read(userRepositoryProvider);

    try {
      state = const DayViewState.loading();
      List<Journal?> journals = await repository.getJournals();
      if (journals.isEmpty) {
        _journals = journals;
      }
      final sortedMap = CustomDateUtils.groupItemsByDay(journals);
      state = DayViewState.data(sortedMap);
    } catch (error, st) {
      state = DayViewState.error(error, st);
    }
  }
}
