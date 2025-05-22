import 'dart:collection';
import 'package:farmers_journal/controller.dart';
import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:farmers_journal/src/presentation/controller/journal/day_view_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/month_view_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/src/data/firestore_providers.dart';

part 'journal_controller.g.dart';

/// {@category Controller}
///
/// The `JournalController` is responsible for managing and fetching journal-related data.
/// It interacts with the user repository to retrieve, manipulate, and organize journal entries.
///
/// This controller supports:
/// - Fetching all journal entries
/// - Grouping journals by week
/// - Counting journal entries per month in a given year
/// - Fetching distinct years containing journal entries
/// - Retrieving a specific journal entry by ID
/// - Deleting a journal entry
/// - Reporting a journal entry
@Riverpod(keepAlive: true)
class JournalController extends _$JournalController {
  /// Fetches all journal entries and sorts them by creation date in descending order.
  ///
  /// Returns a list of [Journal] objects wrapped in a [Future].
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

  /// Groups journal entries by week and returns them as a list of [WeeklyGroup<Journal>].
  Future<List<WeeklyGroup<Journal>>> getWeekViewJournals() async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournals();
    return CustomDateUtils.groupItemsByWeek(journals);
  }

  /// Retrieves the number of journal entries for each month in a given year.
  ///
  /// - [year]: The target year.
  /// - Returns a [LinkedHashMap] where keys are month numbers (1-12) and values are entry counts.
  Future<LinkedHashMap<int, int>> getJournalCountByYear(
      {required int year}) async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournalsByYear(year: year);

    final monthlyJournals = CustomDateUtils.getMonthlyJournal(journals);
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

  /// Retrieves the distinct years that have journal entries.
  ///
  /// Returns a set of years containing journal entries.
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

  /// Retrieves a specific journal entry by its ID.
  ///
  /// - [id]: The unique identifier of the journal entry.
  /// - Returns a [Journal] object wrapped in a [Future].
  Future<Journal> getJournal(String id) async {
    final repository = ref.read(journalRepositoryProvider);
    return await repository.getJournal(id);
  }

  /// Deletes a journal entry by its ID.
  ///
  /// - [id]: The ID of the journal entry to delete.
  /// - Updates the state and invalidates related controllers.
  Future<void> deleteJournal({required String id}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
        () => ref.read(userRepositoryProvider).deleteJournal(id: id));
    ref.invalidate(dayViewControllerProvider);
    ref.invalidate(weekViewControllerProvider);
    ref.invalidate(monthViewControllerProvider);
  }

  /// Reports a journal entry for review.
  ///
  /// - [id]: The ID of the journal entry being reported.
  /// - [userId]: The ID of the user reporting the entry.
  /// - [reason]: The reason for reporting the journal entry.
  /// - Updates the pagination controller to reflect changes.
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
