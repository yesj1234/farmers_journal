import 'package:farmers_journal/data/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/presentation/pages/page_settings/profile_banner.dart';

class PageSettings extends ConsumerStatefulWidget {
  const PageSettings({super.key});
  @override
  ConsumerState<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends ConsumerState<PageSettings> {
  bool editMode = false;
  void onEdit() {
    setState(() {
      editMode = !editMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings "),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
              context.go('/');
            },
            child: const Text("signOut"),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ProfileBanner(
              toggleEdit: onEdit,
              editMode: editMode,
            ),
            Expanded(
              child: ListView(
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  Center(child: _PlantSettings()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingContainer extends StatelessWidget {
  const _SettingContainer(
      {super.key, required this.settingTitle, required this.items});
  final String settingTitle;
  final List<_SelectionItemWithCallback> items;

  TextStyle get settingTitleStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  BoxDecoration get containerDecoration => const BoxDecoration(
        color: Color.fromRGBO(174, 189, 175, 0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      );

  List<Widget> get settingItems {
    List<Widget> result = [];
    for (var (index, item) in items.indexed) {
      if (index == items.length - 1) {
        result.add(item);
      } else {
        result.addAll([
          item,
          const Divider(
            indent: 50,
            endIndent: 10,
          ),
        ]);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settingTitle,
          style: settingTitleStyle,
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - 30,
          ),
          decoration: containerDecoration,
          child: Column(
            children: settingItems,
          ),
        ),
      ],
    );
  }
}

class _PlantSettings extends StatelessWidget {
  const _PlantSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingContainer(settingTitle: "작물", items: [
      _SelectionItemWithCallback(
          callback: () => context.go('/main/settings/plant/'),
          icon: Icons.apple_rounded,
          selectionName: "작물 변경"),
      _SelectionItemWithCallback(
          callback: () => context.go("/main/settings/place"),
          icon: Icons.place_outlined,
          selectionName: "위치 변경"),
    ]);
  }
}

class _SelectionItemWithCallback extends StatelessWidget {
  const _SelectionItemWithCallback({
    super.key,
    required this.callback,
    required this.icon,
    required this.selectionName,
  });
  final String selectionName;
  final IconData icon;
  final VoidCallback callback;

  TextStyle get selectionNameTextStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            child: Icon(
              icon,
              size: 50,
            ),
          ),
          const SizedBox(width: 10),
          Text(selectionName, style: selectionNameTextStyle),
          const Spacer(),
          const Opacity(
            opacity: 0.5,
            child: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
