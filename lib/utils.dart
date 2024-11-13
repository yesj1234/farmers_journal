import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/model/journal.dart';

class WeeklyGroup<T> {
  final String weekLabel;
  final List<T> items;

  const WeeklyGroup({required this.weekLabel, required this.items});
}

class CustomDateUtils {
  static int _getWeekOfMonth(DateTime date) {
    final DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    final int dayDifference = date.day + (firstDayOfMonth.weekday - 1) - 1;

    return (dayDifference ~/ 7) + 1;
  }

  static String _getWeekOfMonthOrdinal(DateTime date) {
    int weekNum = _getWeekOfMonth(date);
    return '$weekNum 째주';
  }

  static DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static String _getWeekLabel(DateTime date, DateTime now) {
    DateTime startOfWeek = _getStartOfWeek(date);
    DateTime currentStartOfWeek = _getStartOfWeek(now);

    int weekDiff = currentStartOfWeek.difference(startOfWeek).inDays ~/ 7;

    if (weekDiff == 0) {
      return '이번 주';
    } else if (weekDiff == 1) {
      return '저번 주';
    } else {
      return '${date.month}월 ${_getWeekOfMonthOrdinal(date)}';
    }
  }

  static List<WeeklyGroup<Journal>> groupItemsByWeek(List<Journal> items) {
    items.sort((a, b) {
      DateTime timeA = a.createdAt as DateTime;
      DateTime timeB = b.createdAt as DateTime;
      return timeB.compareTo(timeA);
    });

    Map<String, List<Journal>> weeklyGroups = {};
    DateTime now = DateTime.now();
    for (var item in items) {
      DateTime dateTime = item.createdAt as DateTime;

      String weekLabel = _getWeekLabel(dateTime, now);

      weeklyGroups.putIfAbsent(weekLabel, () => []);
      weeklyGroups[weekLabel]!.add(item);
    }
    List<WeeklyGroup<Journal>> result = weeklyGroups.entries
        .map((entry) => WeeklyGroup(weekLabel: entry.key, items: entry.value))
        .toList();
    return result;
  }

  static formatDate(DateTime date) {
    var formatter = DateFormat('yyyy-MM-dd');
    return DateTime.parse(formatter.format(date));
  }

  static LinkedHashMap<DateTime, List<Journal>> getMonthlyJournal(
      List<Journal> journals) {
    Map<DateTime, List<Journal>> temp = {};

    for (Journal journal in journals) {
      if (journal.createdAt != null) {
        DateTime formattedDateTime = formatDate(journal.createdAt as DateTime);

        if (temp.containsKey(formattedDateTime)) {
          temp[formattedDateTime]?.add(journal);
        } else {
          temp.putIfAbsent(formattedDateTime, () => [journal]);
        }
      }
    }
    return LinkedHashMap.from(temp);
  }
}
