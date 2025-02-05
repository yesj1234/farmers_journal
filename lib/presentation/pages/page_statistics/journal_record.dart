import 'dart:collection';
import 'package:farmers_journal/presentation/pages/page_statistics/chart.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JournalRecord extends ConsumerStatefulWidget {
  const JournalRecord({super.key});

  @override
  ConsumerState<JournalRecord> createState() => _JournalRecordState();
}

class _JournalRecordState extends ConsumerState<JournalRecord> {
  TextStyle get titleTextStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.black,
      );

  BoxDecoration get journalRecordContainerDecoration => const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(20),
          right: Radius.circular(20),
        ),
      );
  late final Future<Set<int>> _years;
  int year = DateTime.now().year;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _years = ref.read(journalControllerProvider.notifier).getYearsOfJournals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _years,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    label: const Text(
                      '기록',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    icon:
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 38),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: isVisible ? 50 : 0,
                  padding: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      children: snapshot.data!.isEmpty
                          ? const [Text("일지를 작성해보세요")]
                          : List.from(snapshot.data!)
                              .map(
                                (e) => TextButton(
                                  onPressed: () {
                                    setState(() {
                                      year = e;
                                    });
                                  },
                                  child: Text('$e'),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
                Container(
                  decoration: journalRecordContainerDecoration,
                  constraints:
                      const BoxConstraints(maxWidth: 340, maxHeight: 140),
                  child: _JournalYearlyRecordBarChart(year: year),
                )
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class _JournalYearlyRecordBarChart extends ConsumerStatefulWidget {
  const _JournalYearlyRecordBarChart({super.key, required this.year});
  final int year;

  @override
  ConsumerState<_JournalYearlyRecordBarChart> createState() =>
      _JournalYearlyRecordBarChartState();
}

class _JournalYearlyRecordBarChartState
    extends ConsumerState<_JournalYearlyRecordBarChart> {
  late Future<LinkedHashMap<int, int>> _journalCount;
  @override
  void initState() {
    super.initState();
    _journalCount = ref
        .read(journalControllerProvider.notifier)
        .getJournalCountByYear(year: widget.year);
  }

  @override
  void didUpdateWidget(covariant _JournalYearlyRecordBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year) {
      _fetchJournalCount();
    }
  }

  void _fetchJournalCount() {
    _journalCount = ref
        .read(journalControllerProvider.notifier)
        .getJournalCountByYear(year: widget.year);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _journalCount,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _FireIcon(journalCount: snapshot.data!),
                SizedBox(
                  width: 250,
                  height: 125,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RecordBarChart(journalCount: snapshot.data!),
                  ),
                )
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class _FireIcon extends StatelessWidget {
  const _FireIcon({super.key, required this.journalCount});
  final LinkedHashMap<int, int> journalCount;
  TextStyle get daysTextStyle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      );

  TextStyle get subtitleTextStyle => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/svgs/fire-svgrepo-com.svg';

    final Widget svg = SvgPicture.asset(
      assetName,
      colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
      width: 45,
      height: 45,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        svg,
        Text(
          "${journalCount.values.fold(0, (prev, next) => prev + next)} 개",
          style: daysTextStyle,
        ),
        Text(
          "입력항목",
          style: subtitleTextStyle,
        )
      ],
    );
  }
}
