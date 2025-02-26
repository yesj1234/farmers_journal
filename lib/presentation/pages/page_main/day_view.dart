import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/journal/day_view_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/detail_dialog.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/scroll_to_top_button.dart';
import 'package:farmers_journal/presentation/pages/page_main/day_view_shimmer.dart';
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
        },
        loading: () => const Column(children: [
              DayViewShimmer(),
            ]),
        error: (e, st) => const SizedBox.shrink(),
        initial: () => const SizedBox.shrink());
  }
}

/// A wrapper widget that displays a [DayViewCard] for a given journal entry.
class _DayViewCard extends StatefulWidget {
  /// Creates a [_DayViewCard] widget.
  const _DayViewCard({super.key, required this.journal});

  /// The journal entry to display.
  final Journal journal;

  @override
  State<_DayViewCard> createState() => _DayViewCardState();
}

class _DayViewCardState extends State<_DayViewCard>
    with SingleTickerProviderStateMixin {
  double dx = 0;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, lowerBound: -400, upperBound: 400);
    _controller.value = 0.0;
    _controller.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_updateStatus);
    _controller.dispose();
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {}
  void handleDragDown(DragDownDetails details) {}
  void handleDragStart(DragStartDetails details) {}
  void handleDragUpdate(DragUpdateDetails details) {
    _controller.value += details.primaryDelta!;
  }

  void handleDragEnd(DragEndDetails details) {
    _controller.value = 0; // set to initial location
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: handleDragStart,
      onHorizontalDragUpdate: handleDragUpdate,
      onHorizontalDragEnd: handleDragEnd,
      child: AnimatedDayViewBuilder(
          animation: _controller, journal: widget.journal),
    );
  }
}

class AnimatedDayViewBuilder extends AnimatedWidget {
  const AnimatedDayViewBuilder({
    super.key,
    required this.animation,
    required this.journal,
  }) : super(listenable: animation);
  final Animation<double> animation;
  final Journal journal;
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(animation.value, 0),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Center(
          child: DayViewCard(
            verticalPadding: 0,
            journal: journal,
          ),
        ),
      ),
    );
  }
}
