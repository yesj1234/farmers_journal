import 'package:farmers_journal/presentation/controller/auth/auth_controller.dart';
import 'package:farmers_journal/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PageSettings extends ConsumerWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              _Section1(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section1 extends ConsumerWidget {
  const _Section1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.sizeOf(context).width - 100,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton.icon(
                onPressed: () async {
                  bool confirm = await showAlertDialog(context,
                      title: "로그아웃",
                      message: "로그아웃 하시겠습니까?",
                      onCancel: MyButtonType(
                          onPressed: () {}, child: const Text("취소")),
                      onConfirm: MyButtonType(
                        onPressed: () {},
                        child: const Text("확인"),
                      ));
                  if (confirm) {
                    ref.read(authControllerProvider.notifier).signOut();
                    context.go('/');
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
