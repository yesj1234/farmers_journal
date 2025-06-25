import '../../components/avatar/avatar_profile.dart';
import '../../components/button/button_status.dart';
import '../../controller/journal/journal_controller.dart';
import '../../controller/user/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// {@category Presentation}
class TopNav extends StatelessWidget {
  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UserPlantStatusButton(),
                const VerticalDivider(
                  thickness: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),
                UserJournalStatusButton(),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: AvatarProfile(
                width: 60,
                height: 60,
                onNavigateTap: () => context.go('/main/profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserPlantStatusButton extends ConsumerWidget {
  const UserPlantStatusButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider(null));
    return user.value != null
        ? user.value!.plants.isNotEmpty
            ? ButtonStatus(
                status: "작물",
                statusValue: user.value?.plants[0].name,
                statusIcon: Icons.eco,
                statusIconColor: Theme.of(context).primaryColor,
                onNavigateTap: () => context.go('/main/statistics'),
              )
            : ButtonStatus(
                status: "작물",
                statusValue: '설정 필요',
                statusIcon: Icons.eco,
                statusIconColor: Theme.of(context).primaryColor,
                onNavigateTap: () => context.go('/initial_setting'),
              )
        : ButtonStatus(
            status: "작물",
            statusValue: '설정 필요',
            statusIcon: Icons.eco,
            statusIconColor: Theme.of(context).primaryColor,
            onNavigateTap: () => context.go('/initial_setting'),
          );
  }
}

class UserJournalStatusButton extends ConsumerWidget {
  const UserJournalStatusButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalControllerProvider);
    return ButtonStatus(
      status: "일지",
      statusValue: journal.value != null ? '${journal.value?.length} 개' : '0 개',
      statusIcon: Icons.local_fire_department_sharp,
      statusIconColor: Colors.red,
      onNavigateTap: () => context.go('/main/statistics'),
    );
  }
}
