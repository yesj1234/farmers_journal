import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

/// TODO:
/// 1. figure out how to set this emojis
/// 2. Change this to be responsive
///
class ButtonStatus extends StatelessWidget {
  final String status;
  final String statusValue;
  final String statusEmoji; // TODO: figure out how to set this emojis.

  final VoidCallback onNavigateTap;
  const ButtonStatus(
      {super.key,
      required this.status,
      required this.statusValue,
      required this.statusEmoji,
      required this.onNavigateTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    // TODO: Change this to be responsive.
    return SizedBox(
      width: 95,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                statusEmoji,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 2.0),
              Text(status),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: TextButton(
                onPressed: onNavigateTap,
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text(
                  statusValue,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
