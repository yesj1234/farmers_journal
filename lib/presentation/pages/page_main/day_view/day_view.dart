import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/journal/day_view_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/detail_dialog.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/scroll_to_top_button.dart';
import 'package:farmers_journal/presentation/pages/page_main/day_view_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../controller/journal/journal_controller.dart';
import 'day_view/animated_day_view.dart';

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
                      child: AnimatedDayViewCard(journal: journal),
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
class AnimatedDayViewCard extends ConsumerStatefulWidget {
  /// Creates a [AnimatedDayViewCard] widget.
  const AnimatedDayViewCard({super.key, required this.journal});

  /// The journal entry to display.
  final Journal journal;

  @override
  ConsumerState<AnimatedDayViewCard> createState() => _DayViewCardState();
}

class _DayViewCardState extends ConsumerState<AnimatedDayViewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: -400,
        upperBound: 0);

    _controller.value = 0.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleDragDown(DragDownDetails details) {}
  void handleDragStart(DragStartDetails details) {}

  void handleDragUpdate(DragUpdateDetails details) {
    _controller.value += details.primaryDelta!;
    if (_controller.value.abs() > deleteOnDragThreshold && !didVibrate) {
      HapticFeedback.heavyImpact();
      didVibrate = true;
    }
    if (_controller.value.abs() < deleteOnDragThreshold && didVibrate) {
      didVibrate = false;
    }
  }

  void handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) {
      return;
    }
    if (didVibrate) {
      _handleOnDelete(context);
      _controller.forward();
      return;
    }
    didVibrate = false;

    const velocityThreshold = 2.0;

    if (details.primaryVelocity! >= velocityThreshold) {
      _controller.fling();
      return;
    }

    if (_controller.value.abs() < deleteIconStartFrom) {
      _controller.forward(); // Set to initial location.
      return;
    }

    if (_controller.value.abs() >= deleteIconStartFrom ||
        details.primaryVelocity! >= velocityThreshold) {
      _controller.animateTo(-dragEndsAt,
          curve: Curves.easeOutCirc,
          duration: const Duration(milliseconds: 500));
      return;
    }

    if (details.primaryVelocity! > velocityThreshold) {
      _controller.animateTo(-dragEndsAt);
      return;
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: handleDragStart,
      onHorizontalDragUpdate: handleDragUpdate,
      onHorizontalDragEnd: handleDragEnd,
      child: AnimatedDayViewBuilder(
        animation: _controller,
        journal: widget.journal,
        iconSize: iconSize,
        opacityDistance: opacityDistance,
        deleteIconOpacity: deleteIconOpacity,
        editIconOpacity: editIconOpacity,
        onEditCallback: _resetAnimation,
        onDeleteCallback: _handleOnDelete,
        onTapCallback: _resetAnimation,
        deleteIconStartFrom: deleteIconStartFrom,
        editIconStartFrom: editIconStartFrom,
        deleteOnDragThreshold: deleteOnDragThreshold,
      ),
    );
  }

  /// Whether the user dragged the journal over [deleteOnDragThreshold] offset value.
  bool didVibrate = false;

  /// Distance of which the icon
  double opacityDistance = 25;

  double get iconSize => 45;

  /// delete icon will start appearing from this offset to the right
  /// Since 8 is the default padding applied to the IconButton, adjust the logical
  /// pixels based on this value.
  double get deleteIconStartFrom => iconSize - 24;

  /// delete icon will start appearing from this offset to the right
  /// Since 8 is the default padding applied to the IconButton, adjust the logical
  /// pixels based on this value.
  double get editIconStartFrom => iconSize * 2;

  /// Position of which the drag will end up on user drag gesture to open edit and delete icon buttons.
  double get dragEndsAt => editIconStartFrom + opacityDistance + 10;

  /// Threshold of which the drag gesture fires the on delete callback.
  double get deleteOnDragThreshold => 2 * (iconSize + (opacityDistance)) + 40;

  /// Returns delete icon opacity based on the user drag position.
  double deleteIconOpacity(value) {
    final offset = _controller.value.abs();
    if (offset < deleteIconStartFrom) {
      return 0;
    } else if (offset >= deleteIconStartFrom &&
        offset <= deleteIconStartFrom + opacityDistance) {
      // 25 logical pixels will change the opacity from 0 to 1.
      return (offset - deleteIconStartFrom) * (1 / opacityDistance);
    } else {
      return 1;
    }
  }

  /// Returns edit icon opacity based on the user drag position.
  double editIconOpacity(value) {
    final offset = _controller.value.abs();
    if (offset < editIconStartFrom) {
      return 0;
    } else if (offset >= editIconStartFrom &&
        offset <= editIconStartFrom + opacityDistance) {
      return (offset - editIconStartFrom) * (1 / opacityDistance);
    } else {
      return 1;
    }
  }

  void _resetAnimation() {
    _controller.forward();
  }

  void _handleOnDelete(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoPopupSurface(
            isSurfacePainted: true,
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 4,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: CupertinoTheme.of(context)
                              .scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: FittedBox(
                                child: Text(
                                  "이 입력 항목을 삭제하겠습니까? 이 동작은 취소할 수 없습니다.",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                ref
                                    .read(journalControllerProvider.notifier)
                                    .deleteJournal(
                                        id: widget.journal.id as String);
                                Navigator.of(context).pop();
                              },
                              child: const SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    '입력 항목 삭제',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
