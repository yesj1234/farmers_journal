import 'package:flutter/material.dart';

class ButtonCreatePost extends StatelessWidget {
  final VoidCallback onClick;

  const ButtonCreatePost({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primaryContainer,
      shape: const CircleBorder(),
      minimumSize: const Size(80, 80),
      maximumSize: const Size(160, 160),
    );
    return ElevatedButton(
      onPressed: onClick,
      style: buttonStyle,
      child: const Icon(
        Icons.add,
        size: 40,
        color: Colors.black,
      ),
    );
  }
}
