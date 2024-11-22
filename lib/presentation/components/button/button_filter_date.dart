import 'package:flutter/material.dart';
import 'package:farmers_journal/enums.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/providers.dart';

class ButtonFilterDate extends ConsumerWidget {
  const ButtonFilterDate({
    super.key,
    this.backgroundColor = Colors.white,
  });
  final Color backgroundColor;

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
    final currentDateView = ref.watch(dateFilterProvider);
    return SegmentedButton<DateView>(
      style: buttonStyle,
      segments: const <ButtonSegment<DateView>>[
        ButtonSegment<DateView>(
            value: DateView.day,
            label: Text('일간'),
            icon: Icon(Icons.calendar_view_day)),
        ButtonSegment<DateView>(
            value: DateView.week,
            label: Text('주간'),
            icon: Icon(Icons.calendar_view_week)),
        ButtonSegment<DateView>(
            value: DateView.month,
            label: Text('월간'),
            icon: Icon(Icons.calendar_view_month)),
      ],
      selected: <DateView>{currentDateView},
      onSelectionChanged: (Set<DateView> newSelection) {
        ref
            .read(dateFilterProvider.notifier)
            .changeDateFilter(newSelection.first);
      },
    );
  }
}
