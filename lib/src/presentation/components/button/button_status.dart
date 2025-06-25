import 'package:flutter/material.dart';

/// {@category Presentation}
/// {@subCategory Component}
/// A reusable button widget displaying a status label, icon, and value.
///
/// This button is designed to be tappable, triggering a navigation or action
/// when pressed. It visually represents a status with an icon and text.
class ButtonStatus extends StatelessWidget {
  /// Creates a [ButtonStatus] widget.
  ///
  /// * [status] - The main status text.
  /// * [statusValue] - The value associated with the status.
  /// * [statusIcon] - The icon representing the status.
  /// * [onNavigateTap] - The function executed on tap.
  /// * [statusIconColor] (optional) - Defaults to black.
  const ButtonStatus({
    super.key,
    required this.status,
    required this.statusIcon,
    required this.statusValue,
    required this.onNavigateTap,
    this.statusIconColor = Colors.black,
  });

  /// The label describing the status (e.g., "Active", "Pending").
  final String status;

  /// The value associated with the status (e.g., "Online", "3 tasks").
  final String statusValue;

  /// The icon representing the status.
  final IconData statusIcon;

  /// The color of the status icon. Defaults to black.
  final Color statusIconColor;

  /// The callback function triggered when the button is tapped.
  final VoidCallback onNavigateTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNavigateTap,
      child: SizedBox(
        width: 80,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  statusIcon,
                  color: statusIconColor,
                ),
                const SizedBox(width: 2.0),
                Text(
                  status,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),

                  // TextStyle(
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 18,
                  // ),
                ),
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  statusValue,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600),

                  // TextStyle(
                  //   color: Theme.of(context).primaryColorDark,
                  //   fontWeight: FontWeight.w600,
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
