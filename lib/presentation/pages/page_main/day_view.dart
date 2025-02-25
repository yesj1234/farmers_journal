import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/detail_dialog.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/scroll_to_top_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays a daily view of journal entries, organized by date.
///
/// This page retrieves and displays journal entries grouped by day, allowing users to view and interact with each entry.
/// A stateful widget that displays journal entries grouped by day.
class DayView extends ConsumerStatefulWidget {
  /// Creates a [DayView] widget.
  const DayView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayViewState();
}

/// The state class for [DayView].
class _DayViewState extends ConsumerState<ConsumerStatefulWidget> {
  /// A future that retrieves sorted journal entries grouped by date.
  late Future<Map<DateTime, List<Journal?>>> _sortedJournal;

  /// Scroll controller for the list view.
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _sortedJournal =
        ref.read(journalControllerProvider.notifier).getDayViewJournals();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
                  children.add(
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Consumer(builder: (context, ref, child) {
                                final userInfo =
                                    ref.watch(userControllerProvider);
                                return userInfo.when(
                                  data: (info) => DataStateDialog(
                                      info: info!, journalInfo: journal),
                                  loading: () =>
                                      const ShimmerLoadingStateDialog(),
                                  error: (e, st) => const ErrorStateDialog(),
                                );
                              });
                            });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: _DayViewCard(journal: journal),
                      ),
                    ),
                  );
                }
              }
            }
            return Stack(
              children: [
                ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 4.0),
                    children: children),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ScrollToTopButton(scrollController: scrollController),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        });
  }
}

/// A wrapper widget that displays a [DayViewCard] for a given journal entry.
class _DayViewCard extends StatelessWidget {
  /// Creates a [_DayViewCard] widget.
  const _DayViewCard({super.key, required this.journal});

  /// The journal entry to display.
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
