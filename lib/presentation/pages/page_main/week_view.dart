import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/carousel/carousel.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class WeekView extends ConsumerStatefulWidget {
  const WeekView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeekViewState();
}

class _WeekViewState extends ConsumerState<ConsumerStatefulWidget> {
  late Future<List<WeeklyGroup<Journal>>> _sortedJournals;

  @override
  void initState() {
    super.initState();
    _sortedJournals =
        ref.read(journalControllerProvider.notifier).getWeekViewJournals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _sortedJournals,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView(children: [
              for (var items in snapshot.data!)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        items.weekLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: MyCarousel(journals: items.items),
                    )
                  ],
                )
            ]);
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
