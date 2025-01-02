import 'dart:collection';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/utils.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_state.dart';
part 'journal_controller.g.dart';

@riverpod
class JournalController extends _$JournalController {
  @override
  Future<List<Journal?>> build() async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournals();
    if (journals.isNotEmpty) {
      journals.sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
    }
    return journals;
  }

  Future<Map<DateTime, List<Journal?>>> getDayViewJournals() async {
    final repository = ref.read(userRepositoryProvider);
    List<Journal?> journals = await repository.getJournals();
    Map<DateTime, List<Journal?>> map = {};
    if (journals.isNotEmpty) {
      journals.sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
      for (var journal in journals) {
        int? year = journal?.createdAt?.year;
        int? month = journal?.createdAt?.month;
        int? day = journal?.createdAt?.day;
        if (year != null && month != null && day != null) {
          var createdDate = DateTime(year, month, day);
          if (map.containsKey(createdDate)) {
            map[createdDate]?.add(journal);
          } else {
            map[createdDate] = [journal];
          }
        }
      }
    }
    return map;
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

  Future<Journal> getJournal(String id) async {
    final repository = ref.read(journalRepositoryProvider);
    return await repository.getJournal(id);
  }

  Future<void> createJournal(
      {required String title,
      required String content,
      required DateTime date,
      required List<String>? images}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(userRepositoryProvider)
        .createJournal(
            title: title, content: content, date: date, images: images));
  }

  Future<void> updateJournal(
      {required String id,
      required String title,
      required String content,
      required DateTime date,
      required List<String?>? images}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(userRepositoryProvider)
        .updateJournal(
            id: id,
            title: title,
            content: content,
            date: date,
            images: images));
  }

  Future<void> deleteJournal({required String id}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(userRepositoryProvider).deleteJournal(id: id));
  }
}
