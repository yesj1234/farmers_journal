import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class ButtonStatus extends StatelessWidget {
  final String status;
  final String statusValue;
  final IconData statusIcon;
  final Color statusIconColor;
  final VoidCallback onNavigateTap;

  const ButtonStatus({
    super.key,
    required this.status,
    required this.statusIcon,
    required this.statusValue,
    required this.onNavigateTap,
    this.statusIconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;

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
              Icon(
                statusIcon,
                color: statusIconColor,
              ),
              const SizedBox(width: 2.0),
              Text(
                status,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
