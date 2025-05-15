import 'package:farmers_journal/src/presentation/controller/journal/day_view_controller.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/community_view/scroll_to_top_button.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/day_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../journal_detail/journal_detail.dart';
import 'animated_day_view.dart';

/// {@category Presentation}
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
class _DayViewState extends ConsumerState<DayView> {
  /// Scroll controller for the list view.
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayViewJournals = ref.watch(dayViewControllerProvider);
    return dayViewJournals.when(
        data: (data) {
          List<Widget> children = [];
          for (var entry in data.entries) {
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
                    onTap: () => context.pushNamed(
                      'journal-detail',
                      pathParameters: {"journalId": journal.id!},
                      extra: journal,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: AnimatedDayViewCard(
                        journal: journal,
                        doEnlarge: false,
                      ),
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
        },
        loading: () => const Column(children: [
              DayViewShimmer(),
            ]),
        error: (e, st) => const SizedBox.shrink(),
        initial: () => const SizedBox.shrink());
  }
}
