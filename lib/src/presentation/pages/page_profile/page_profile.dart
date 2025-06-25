import 'package:farmers_journal/src/presentation/components/selection_item_with_callback.dart';
import 'package:farmers_journal/src/presentation/controller/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/src/presentation/pages/page_profile/profile_banner.dart';

/// {@category Presentation}
class PageProfile extends ConsumerStatefulWidget {
  const PageProfile({super.key});
  @override
  ConsumerState<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends ConsumerState<PageProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "프로필",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/main/profile/setting');
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ProfileBanner(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    Center(child: _PlantSettings()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantSettings extends ConsumerWidget {
  const _PlantSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userControllerProvider(null));
    return SettingContainer(
      containerColor: Colors.transparent,
      settingTitle: "작물",
      items: [
        SelectionItemWithCallback(
          callback: () {
            if (userRef.value!.isInitialSettingRequired == false) {
              context.go('/main/profile/plant/');
            } else {
              context.go('/initial_setting');
            }
          },
          icon: Icons.apple_rounded,
          selectionName: "작물 변경",
        ),
        SelectionItemWithCallback(
          callback: () {
            if (userRef.value!.isInitialSettingRequired == false) {
              context.go('/main/profile/place/');
            } else {
              context.go('/initial_setting');
            }
          },
          icon: Icons.place_outlined,
          selectionName: "위치 변경",
        ),
      ],
    );
  }
}
