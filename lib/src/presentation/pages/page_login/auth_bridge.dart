import 'package:farmers_journal/src/data/providers.dart';
import 'package:farmers_journal/src/presentation/pages/page_login/page_login.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/page_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@category Presentation}
class AuthBridge extends ConsumerWidget {
  const AuthBridge({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool authenticated = ref.watch(authNotifierProvider);
    if (authenticated) {
      return const PageMain();
    } else {
      return const PageLogin();
    }
  }
}
