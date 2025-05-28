import 'package:farmers_journal/src/presentation/controller/auth/auth_notifier.dart';
import 'package:farmers_journal/src/presentation/controller/auth/auth_notifier_state.dart';
import 'package:farmers_journal/src/presentation/pages/page_login/page_login.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/page_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../page_main/page_splash.dart';

/// {@category Presentation}
class AuthBridge extends ConsumerWidget {
  const AuthBridge({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthNotifierState authenticated = ref.watch(authNotifierProvider);
    return switch (authenticated) {
      Initial() => const PageSplash(),
      Loading() => const PageSplash(),
      Error() => const PageLogin(),
      Data(:final appUser) => () {
          if (appUser == null) {
            return const PageLogin();
          } else {
            return const PageMain();
          }
        }(),
    };
  }
}
