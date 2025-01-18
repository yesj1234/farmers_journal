import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DayView extends ConsumerStatefulWidget {
  const DayView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayViewState();
}

class _DayViewState extends ConsumerState<ConsumerStatefulWidget> {
  late Future<Map<DateTime, List<Journal?>>> _sortedJournal;
  @override
  void initState() {
    super.initState();
    _sortedJournal =
        ref.read(journalControllerProvider.notifier).getDayViewJournals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _sortedJournal,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> children = [];
            for (var entry in snapshot.data!.entries) {
              children.add(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '${entry.key.month}월 ${entry.key.day}일',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              );
              for (var journal in entry.value) {
                if (journal != null) {
                  children.add(_DayViewCard(journal: journal));
                }
              }
            }
            return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 4.0),
                children: children);
          }
          return const SizedBox.shrink();
        });
  }
}

class _DayViewCard extends StatelessWidget {
  const _DayViewCard({super.key, required this.journal});
  final Journal journal;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Center(
        child: DayViewCard(
          verticalPadding: 0,
          journal: journal,
        ),
      ),
    );
  }
}
