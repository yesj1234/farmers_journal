import 'package:flutter/material.dart';
import 'package:farmers_journal/enums.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/data/providers.dart';

/// {@category Presentation}
/// A segmented button widget that allows users to filter the main view
/// by day, week, month, or community.
///
/// This widget uses Riverpod's state management to watch and update the
/// currently selected view filter.
///
class ButtonMainViewFilter extends ConsumerWidget {
  /// Creates a `ButtonMainViewFilter` with an optional background color.
  const ButtonMainViewFilter({
    super.key,
    this.backgroundColor = Colors.white,
  });

  /// Background color of the button.
  final Color backgroundColor;

  /// Defines the button's style properties, including shape, size, padding,
  /// and text styling.
  ButtonStyle get buttonStyle => ButtonStyle(
        shape: WidgetStateProperty.all(const BeveledRectangleBorder()),
        minimumSize: WidgetStateProperty.all(const Size(0, 48)),
        fixedSize: WidgetStateProperty.all(const Size(120, 48)),
        padding:
            WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8)),
        visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
        splashFactory: NoSplash.splashFactory,
        side: const WidgetStatePropertyAll(BorderSide.none),
        textStyle: WidgetStateProperty.resolveWith((Set<WidgetState> state) {
          return TextStyle(
              fontSize: 15,
              fontWeight: state.contains(WidgetState.selected)
                  ? FontWeight.bold
                  : FontWeight.normal,
              height: 1.2,
              wordSpacing: 0,
              decorationThickness: 2.5);
        }),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMainView = ref.watch(mainViewFilterProvider);
    return SegmentedButton<MainView>(
      style: buttonStyle,
      segments: const <ButtonSegment<MainView>>[
        ButtonSegment<MainView>(
            value: MainView.day,
            label: Text('일간'),
            icon: Icon(Icons.calendar_view_day)),
        ButtonSegment<MainView>(
            value: MainView.week,
            label: Text('주간'),
            icon: Icon(Icons.calendar_view_week)),
        ButtonSegment<MainView>(
            value: MainView.month,
            label: Text('월간'),
            icon: Icon(Icons.calendar_view_month)),
        ButtonSegment<MainView>(
            value: MainView.community,
            label: Text(
              '커뮤니티',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            icon: Icon(Icons.people)),
      ],
      selected: <MainView>{currentMainView},
      onSelectionChanged: (Set<MainView> newSelection) {
        ref
            .read(mainViewFilterProvider.notifier)
            .changeDateFilter(newSelection.first);
      },
    );
  }
}
