import 'package:flutter/material.dart';

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
    return SizedBox(
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: TextButton(
                onPressed: onNavigateTap,
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  statusValue,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
