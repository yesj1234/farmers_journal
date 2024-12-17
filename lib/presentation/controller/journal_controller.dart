import 'dart:collection';

import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/data/firestore_service.dart';

part 'journal_controller.g.dart';

@riverpod
class JournalController extends _$JournalController {
  @override
  Future<List<Journal?>> build() async {
    // 1. Fetch the current user's repo.
    // 2. get the journals of that user.
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

  Future<void> createJournal(
      {required String title,
      required String content,
      required DateTime date,
      required String? image}) async {
    // 0. Define the Database structure.
    // 1. Call the userRepository API that create a new journal
    ref.read(userRepositoryProvider).createJournal(
        title: title, content: content, date: date, image: image);
    ref.invalidateSelf();
    await future;
  }
}
