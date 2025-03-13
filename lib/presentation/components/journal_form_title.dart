import 'package:flutter/material.dart';

/// A form widget that allows users to input a title.
///
/// The [TitleForm] widget provides a text input field with validation.
/// If the [notValid] flag is set to true, an error message is displayed
/// when attempting to submit an empty input.
/// Example usage:
/// ```dart
/// TitleForm(
///   controller: TextEditingController(),
///   notValid: true,
/// )
/// ```
///
class TitleForm extends StatelessWidget {
  /// Creates a [TitleForm] widget.
  ///
  /// Requires a [controller] for managing text input and a [notValid] flag to indicate whether validation should be enforced
  const TitleForm({
    super.key,
    required this.controller,
    required this.notValid,
  });

  ///  Controls the text being edited.
  final TextEditingController controller;

  /// Whether the input is required.
  /// If true, an error message is shown when the input is empty.
  final bool notValid;

  /// The text style applied to the input field.
  TextStyle get textStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (notValid && controller.text.isEmpty) {
            return '비어 있는 일지를 만들 수 없습니다.';
          } else {
            return null;
          }
        },
        style: textStyle,
        decoration: InputDecoration(
          hintText: '제목',
          fillColor: themeData.scaffoldBackgroundColor,
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
