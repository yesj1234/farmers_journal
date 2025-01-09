import 'package:farmers_journal/presentation/controller/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PageAccount extends ConsumerWidget {
  const PageAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
                context.go('/');
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
