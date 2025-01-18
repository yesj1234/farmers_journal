import 'package:farmers_journal/presentation/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/presentation/components/button/button_status.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class TopNav extends ConsumerWidget {
  const TopNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider);
    final journal = ref.watch(journalControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicHeight(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    user.value != null
                        ? user.value!.plants.isNotEmpty
                            ? ButtonStatus(
                                status: "작물",
                                statusValue: user.value?.plants[0].name,
                                statusIcon: Icons.eco,
                                statusIconColor: Colors.green,
                                onNavigateTap: () =>
                                    context.go('/main/statistics'),
                              )
                            : ButtonStatus(
                                status: "작물",
                                statusValue: '설정 필요',
                                statusIcon: Icons.eco,
                                statusIconColor: Colors.green,
                                onNavigateTap: () =>
                                    context.go('/initial_setting'),
                              )
                        : ButtonStatus(
                            status: "작물",
                            statusValue: '설정 필요',
                            statusIcon: Icons.eco,
                            statusIconColor: Colors.green,
                            onNavigateTap: () => context.go('/initial_setting'),
                          ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    ButtonStatus(
                      status: "일지",
                      statusValue: journal.value != null
                          ? '${journal.value?.length} 개'
                          : '0 개',
                      statusIcon: Icons.local_fire_department_sharp,
                      statusIconColor: Colors.red,
                      onNavigateTap: () => context.go('/main/statistics'),
                    )
                  ],
                ),
                const Spacer(),
                AvatarProfile(
                  width: 60,
                  height: 60,
                  onNavigateTap: () => context.go('/main/profile'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
