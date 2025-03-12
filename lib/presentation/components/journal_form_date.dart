import 'package:flutter/material.dart';

/// A form widget that displays a selectable date.
///
/// The [DateForm] widget allows users to select a date, displaying the chosen date in the center
/// and an interactive calendar icon to the left. When tapped, it triggers a date picker dialog.
///
/// Example usage:
/// ```dart
/// DateForm(
///   datePicked: DateTime.now(),
///   onDatePicked: (date) {
///     print("Selected date: \$date");
///   },
/// )
/// ```
///

class DateForm extends StatelessWidget {
  /// Creates a [DateForm] widget.
  ///
  /// Requires [datePicked] to display the currently selected date and [onDatePicked]
  ///
  const DateForm({
    super.key,
    required this.datePicked,
    required this.onDatePicked,
    required this.initialDate,
  });

  final DateTime initialDate;

  /// The currently selected date. Can be null if no date has been chosen.
  final DateTime? datePicked;

  /// A callback function triggered when a new date is selected
  final ValueChanged<DateTime> onDatePicked;

  /// The text style applied to the displayed date.
  TextStyle get textStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.2,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.transparent,
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DatePickerWrapper(
                onDatePicked: onDatePicked,
                initialDate: initialDate,
                child: const Icon(
                  Icons.calendar_month,
                  size: 25,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: DatePickerWrapper(
              onDatePicked: onDatePicked,
              initialDate: initialDate,
              child: Text(
                '${datePicked?.year}. ${datePicked?.month}. ${datePicked?.day}.',
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A wrapper for handling date selection via a tap gesture.
///
/// The [DatePickerWrapper] widget wraps any child widget and makes it interactive,
/// opening a date picker dialog when tapped. The selected date is then passed to the provided [onDatePicked] callback.

class DatePickerWrapper extends StatelessWidget {
  /// Creates a [DatePickerWrapper] widget.
  ///
  /// Requires a [child] widget and an [onDatePicked] callback.
  const DatePickerWrapper({
    super.key,
    required this.child,
    required this.onDatePicked,
    required this.initialDate,
  });
  final DateTime initialDate;

  /// The callback function that is triggered when a date is selected.
  final ValueChanged<DateTime> onDatePicked;

  /// The widget that is wrapped with date selection functionality.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1980),
          lastDate: DateTime(2050),
        );
        if (pickedDate != null) {
          onDatePicked(pickedDate);
        }
      },
      child: child,
    );
  }
}
