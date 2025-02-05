import 'package:flutter/material.dart';

class ButtonCreatePost extends StatelessWidget {
  final VoidCallback onClick;

  const ButtonCreatePost({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary.withAlpha(255),
      shape: const CircleBorder(),
      minimumSize: const Size(60, 60),
      maximumSize: const Size(80, 80),
    );
    return ElevatedButton(
      onPressed: onClick,
      style: buttonStyle,
      child: const Icon(
        Icons.add,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
