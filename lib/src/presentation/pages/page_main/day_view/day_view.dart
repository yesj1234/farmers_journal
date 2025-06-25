import 'animated_day_view.dart';
import '../../../controller/journal/day_view_controller.dart';
import '../../../controller/journal/day_view_state.dart' as day_view_state;
import '../../../pages/page_main/day_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    return switch (dayViewJournals) {
      day_view_state.Data(:final data) => () {
          List<Widget> children = [];
          for (var entry in data.entries) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '${entry.key.month}월 ${entry.key.day}일',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        }(),
      day_view_state.Loading() => const Column(children: [
          DayViewShimmer(),
        ]),
      _ => const SizedBox.shrink(),
    };
  }
}
