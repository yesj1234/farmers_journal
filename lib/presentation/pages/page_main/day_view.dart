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
import '../../components/show_alert_dialog.dart';
import '../../controller/journal/journal_controller.dart';

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
class _DayViewCard extends ConsumerStatefulWidget {
  /// Creates a [_DayViewCard] widget.
  const _DayViewCard({super.key, required this.journal});

  /// The journal entry to display.
  final Journal journal;

  @override
  ConsumerState<_DayViewCard> createState() => _DayViewCardState();
}

class _DayViewCardState extends ConsumerState<_DayViewCard>
    with SingleTickerProviderStateMixin {
  double dx = 0;
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
    _controller.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_updateStatus);
    _controller.dispose();
    super.dispose();
  }

  bool didVibrate = false;

  void _updateStatus(AnimationStatus status) {}
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

    if (_controller.value.abs() < deleteIconStartFrom) {
      _controller.forward(); // Set to initial location.
      return;
    }
    if (details.primaryVelocity! >= velocityThreshold) {
      _controller.fling();
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

  double get dragEndsAt => editIconStartFrom + opacityDistance + 10;

  double get deleteOnDragThreshold => 2 * (iconSize + (opacityDistance)) + 40;

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
                          const Divider(),
                          Expanded(
                            child: TextButton(
                              onPressed: () => ref
                                  .read(journalControllerProvider.notifier)
                                  .deleteJournal(
                                      id: widget.journal.id as String),
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

class AnimatedOpacityBuilder extends AnimatedWidget {
  const AnimatedOpacityBuilder({
    super.key,
    required this.animation,
    required this.rules,
    required this.child,
  }) : super(listenable: animation);
  final Animation<double> animation;
  final Function(double value) rules;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: rules(animation.value),
      child: child,
    );
  }
}

class AnimatedDayViewBuilder extends AnimatedWidget {
  const AnimatedDayViewBuilder({
    super.key,
    required this.animation,
    required this.journal,
    required this.iconSize,
    required this.deleteIconOpacity,
    required this.editIconOpacity,
    required this.deleteIconStartFrom,
    required this.editIconStartFrom,
    required this.deleteOnDragThreshold,
    this.opacityDistance,
    this.onEditCallback,
    this.onDeleteCallback,
    this.onTapCallback,
    this.isOverThreshold,
  }) : super(listenable: animation);
  final Animation<double> animation;
  final Journal journal;
  final double iconSize;
  final double Function(double value) deleteIconOpacity;
  final double Function(double value) editIconOpacity;
  final double deleteIconStartFrom;
  final double editIconStartFrom;
  final double deleteOnDragThreshold;
  final double? opacityDistance;
  final void Function()? onEditCallback;
  final void Function(BuildContext)? onDeleteCallback;
  final void Function()? onTapCallback;
  final bool? isOverThreshold;

  @override
  Widget build(BuildContext context) {
    final Widget deleteIconButton = IconButton(
      onPressed: () => onDeleteCallback?.call(context),
      iconSize: iconSize,
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.redAccent,
        foregroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      icon: const Icon(Icons.delete_forever),
    );
    final Widget deleteIcon = animation.value < -deleteIconStartFrom
        ? AnimatedPositioned(
            top: 0,
            bottom: 0,
            right: animation.value < -deleteOnDragThreshold
                ? -(animation.value + 72)
                : 0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Center(
              child: AnimatedOpacityBuilder(
                  animation: animation,
                  rules: deleteIconOpacity,
                  child: deleteIconButton),
            ),
          )
        : const SizedBox.shrink();

    final editIconButton = IconButton(
      onPressed: () {
        onEditCallback?.call();
        context.push('/update/${journal.id}');
      },
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      iconSize: iconSize,
      icon: const Icon(Icons.edit),
    );
    final Widget editIcon = animation.value < -editIconStartFrom &&
            animation.value > -deleteOnDragThreshold
        ? Positioned(
            top: 0,
            bottom: 0,
            right: iconSize + 24,
            child: Center(
              child: AnimatedOpacityBuilder(
                animation: animation,
                rules: editIconOpacity,
                child: editIconButton,
              ),
            ),
          )
        : const SizedBox.shrink();
    return Stack(
      children: [
        deleteIcon,
        editIcon,
        Transform.translate(
          offset: Offset(animation.value, 0),
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Center(
              child: DayViewCard(
                verticalPadding: 0,
                journal: journal,
                onTapCallback: onTapCallback,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
