import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../controller.dart';

/// {@category Presentation}
/// {@subCategory Component}
class ButtonCreatePost extends ConsumerWidget {
  const ButtonCreatePost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final userRef = ref.watch(userControllerProvider(null));
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary.withAlpha(255),
      shape: const CircleBorder(),
      minimumSize: const Size(60, 60),
      maximumSize: const Size(80, 80),
    );
    return ElevatedButton(
      onPressed: () {
        // 초기 설정 없으면 초기 설정 페이지로 이동
        if (userRef.value!.isInitialSettingRequired) {
          context.go('/initial_setting');
        } else {
          context.push('/create');
        }
      },
      style: buttonStyle,
      child: Icon(
        Icons.add,
        size: 30,
        color: colorScheme.surface,
      ),
    );
  }
}
