import 'dart:collection';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/data/firestore_providers.dart';

part 'journal_controller.g.dart';

@Riverpod(keepAlive: true)
class JournalController extends _$JournalController {
  @override
  Future<List<Journal?>> build() async {
    final repository = ref.read(userRepositoryProvider);
    try {
      List<Journal?> journals = await repository.getJournals();
      if (journals.isNotEmpty) {
        journals.sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
      }
      return journals;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<Map<DateTime, List<Journal?>>> getDayViewJournals() async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournals();
    return CustomDateUtils.groupItemsByDay(journals);
  }

  Future<List<WeeklyGroup<Journal>>> getWeekViewJournals() async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournals();
    return CustomDateUtils.groupItemsByWeek(journals);
  }

  Future<LinkedHashMap<DateTime, List<Journal?>>> getMonthlyJournals() async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournals();
    return CustomDateUtils.getMonthlyJournal(journals);
  }

  Future<LinkedHashMap<int, int>> getJournalCountByYear(
      {required int year}) async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournalsByYear(year: year);

    final monthlyJournals = CustomDateUtils.getMonthlyJournal(
        journals); // Actually its monthly view journal.
    LinkedHashMap<int, int> res = LinkedHashMap.fromIterable(
      List.generate(12, (index) => index + 1),
      key: (i) => i,
      value: (_) => 0,
    );
    for (var entry in monthlyJournals.entries) {
      res.update(entry.key.month, (v) => v + entry.value.length);
    }
    return res;
  }

  Future<Set<int>> getYearsOfJournals() async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournals();
    Set<int> res = {};
    if (journals.isNotEmpty) {
      for (var journal in journals) {
        Journal item = journal as Journal;
        res.add(item.date!.year);
      }
    }
    return res;
  }

  Future<Journal> getJournal(String id) async {
    final repository = ref.read(journalRepositoryProvider);
    return await repository.getJournal(id);
  }

  Future<void> deleteJournal({required String id}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(userRepositoryProvider).deleteJournal(id: id));
  }

  Future<void> reportJournal(
      {required String id,
      required String userId,
      required String reason}) async {
    ref.read(journalRepositoryProvider).reportJournal(id: id, userId: userId);
    ref
        .read(paginationControllerProvider.notifier)
        .updateStateOnJournalReport(id: id);
  }
}
