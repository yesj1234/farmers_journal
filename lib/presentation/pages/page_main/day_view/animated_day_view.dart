import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/model/journal.dart';
import '../../../components/card/day_view_card.dart';
import '../../../components/handle_journal_delete.dart';

/// {@category Presentation}
/// A wrapper widget that displays a [DayViewCard] for a given journal entry.
class AnimatedDayViewCard extends ConsumerStatefulWidget {
  /// Creates a [AnimatedDayViewCard] widget.
  const AnimatedDayViewCard({super.key, required this.journal});

  /// The journal entry to display.
  final Journal journal;

  @override
  ConsumerState<AnimatedDayViewCard> createState() =>
      _AnimatedDayViewCardState();
}

class _AnimatedDayViewCardState extends ConsumerState<AnimatedDayViewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// Whether the user dragged the journal over [deleteOnDragThreshold] offset value.
  bool didVibrate = false;

  /// Distance of which the icon
  double opacityDistance = 25;

  double get iconSize => 40;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        onDeleteCallback: handleJournalDelete,
        onTapCallback: _resetAnimation,
        deleteIconStartFrom: deleteIconStartFrom,
        editIconStartFrom: editIconStartFrom,
        deleteOnDragThreshold: deleteOnDragThreshold,
        ref: ref,
      ),
    );
  }

  void _resetAnimation() {
    _controller.forward();
  }

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
      handleJournalDelete(context, ref, widget.journal.id!);
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
}

/// Widget that animates the DayView journal's drag gestures.
class AnimatedDayViewBuilder extends AnimatedWidget {
  /// Creates [AnimateDayViewBuilder] widget.
  ///
  /// The [animation] is passed from outside to control the user gesture.
  /// The [journal] is the data that holds the information of journal.
  /// The [iconSize] specifies the size of edit and delete icon.
  /// The [deleteIconOpacity] and [editIconOpacity] handles the opacity of each icons respectively.
  /// Its passed as the opacity parameter of the AnimatedOpacity, combined with animation.value as a parameter.
  /// The [deleteIconStartFrom] and [editIconStartFrom] decides the position of which each icon will start
  /// appearing.
  /// The [deleteOnDragThreshold] decides the position of which the [onDeleteCallback] will fire.
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
    this.ref,
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
  final void Function(BuildContext, WidgetRef, String)? onDeleteCallback;
  final void Function()? onTapCallback;
  final bool? isOverThreshold;
  final WidgetRef? ref;
  @override
  Widget build(BuildContext context) {
    final Widget deleteIconButton = IconButton(
      onPressed: () => onDeleteCallback?.call(context, ref!, journal.id!),
      iconSize: iconSize,
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        alignment: Alignment.center,
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
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
              child: AnimatedOpacity(
                  opacity: deleteIconOpacity(animation.value),
                  duration: const Duration(milliseconds: 100),
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
              child: AnimatedOpacity(
                opacity: editIconOpacity(animation.value),
                duration: const Duration(milliseconds: 100),
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
