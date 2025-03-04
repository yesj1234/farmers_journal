import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/card/day_view_card.dart';

class MonthViewDetails extends ConsumerWidget {
  const MonthViewDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalRef = ref.watch(journalControllerProvider);
    final now = DateTime.now();
    const Widget emptyJournals = Center(
        child: Column(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              "입력 항목 없음",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            child: Text(
              '이 날은 현재 일기 입력 항목이 없습니다.',
              style: TextStyle(
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
        )
      ],
    ));

    final journals = journalRef.value!
        .map((journal) => Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: DayViewCard(journal: journal!),
            ))
        .toList();
    final child = journalRef.value!.isEmpty ? [emptyJournals] : journals;
    final String title = '${now.year}년 ${now.month}월 ${now.day}일';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView(
        children: child,
      ),
    );
  }
}
