import 'package:farmers_journal/src/presentation/components/selection_item_with_callback.dart';
import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/src/presentation/controller/auth/auth_controller.dart';
import 'package:farmers_journal/src/presentation/controller/theme/theme_controller.dart';
import 'package:farmers_journal/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// {@category Presentation}
class PageSettings extends ConsumerWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '설정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              ToggleThemeButton(
                initialTheme: ref.read(themeControllerProvider).maybeWhen(
                    orElse: () => ThemeMode.system, data: (mode) => mode),
              ),
              const TermsAndPolicy(),
              const Account(),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleThemeButton extends ConsumerStatefulWidget {
  const ToggleThemeButton({super.key, this.initialTheme});

  final ThemeMode? initialTheme;
  @override
  ConsumerState<ToggleThemeButton> createState() => _ToggleThemeButtonState();
}

class _ToggleThemeButtonState extends ConsumerState<ToggleThemeButton> {
  /// Text style for the selection name.
  TextStyle get selectionNameTextStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );
  double? iconSize = 30;
  late ThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.initialTheme ?? ThemeMode.system;
  }

  List<bool> get _isSelected {
    if (_selectedTheme == ThemeMode.light) {
      return [true, false, false];
    } else if (_selectedTheme == ThemeMode.dark) {
      return [false, true, false];
    } else {
      return [false, false, true];
    }
  }

  Icon get _currentIcon => _selectedTheme == ThemeMode.light
      ? Icon(Icons.sunny,
          key: ValueKey<ThemeMode>(_selectedTheme), size: iconSize)
      : _selectedTheme == ThemeMode.dark
          ? Icon(
              Icons.mode_night_outlined,
              key: ValueKey<ThemeMode>(_selectedTheme),
              size: iconSize,
            )
          : Icon(
              Icons.settings,
              key: ValueKey<ThemeMode>(_selectedTheme),
              size: iconSize,
            );

  @override
  Widget build(BuildContext context) {
    return SettingContainer(
      settingTitle: '앱 설정',
      items: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: _currentIcon,
              ),
            ),
            const SizedBox(width: 10),
            Text('테마', style: selectionNameTextStyle),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ToggleButtons(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                  right: Radius.circular(10),
                ),
                onPressed: (index) {
                  setState(() {
                    if (index == 0) {
                      _selectedTheme = ThemeMode.light;
                      ref
                          .read(themeControllerProvider.notifier)
                          .setUserThemeMode(ThemeMode.light);
                    }
                    if (index == 1) {
                      _selectedTheme = ThemeMode.dark;
                      ref
                          .read(themeControllerProvider.notifier)
                          .setUserThemeMode(ThemeMode.dark);
                    }
                    if (index == 2) {
                      _selectedTheme = ThemeMode.system;
                      ref
                          .read(themeControllerProvider.notifier)
                          .setUserThemeMode(ThemeMode.system);
                    }
                  });
                },
                isSelected: _isSelected,
                children: const [
                  _ThemeModeIcon(icon: Icons.light_mode_outlined, name: '라이트'),
                  _ThemeModeIcon(icon: Icons.mode_night_outlined, name: '다크'),
                  _ThemeModeIcon(icon: Icons.settings_outlined, name: '시스템'),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _ThemeModeIcon extends StatelessWidget {
  const _ThemeModeIcon({required this.icon, required this.name});
  final IconData? icon;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(icon),
            ),
          ),
          FittedBox(
            child: Text(
              name ?? '',
            ),
          )
        ],
      ),
    );
  }
}

class Account extends ConsumerWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingContainer(
      settingTitle: '계정',
      items: [
        SelectionItemWithCallback(
          callback: () async {
            bool confirm = await showAlertDialog(context,
                title: "로그아웃",
                message: "로그아웃 하시겠습니까?",
                onCancel:
                    MyButtonType(onPressed: () {}, child: const Text("취소")),
                onConfirm: MyButtonType(
                  onPressed: () {},
                  child: const Text("확인"),
                ));
            if (confirm) {
              ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/');
              }
            }
          },
          icon: Icons.logout,
          selectionName: '로그아웃',
        ),
        SelectionItemWithCallback(
          callback: () async {
            bool confirm = await showAlertDialog(context,
                title: "회원탈퇴",
                message: "회원 탈퇴 하시겠습니까??",
                onCancel:
                    MyButtonType(onPressed: () {}, child: const Text("취소")),
                onConfirm: MyButtonType(
                  onPressed: () {},
                  child: const Text("확인"),
                ));
            if (confirm) {
              ref.read(authControllerProvider.notifier).deleteAccount();
              if (context.mounted) {
                context.go('/');
              }
            }
          },
          icon: Icons.person_remove_alt_1_outlined,
          selectionName: '회원탈퇴',
        ),
      ],
    );
  }
}

class TermsAndPolicy extends StatelessWidget {
  const TermsAndPolicy({super.key});

  Future<void> _openUrl(String? url, BuildContext context) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('URL이 설정되지 않았습니다')));
      return;
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        showSnackBar(context, "URL을 열 수 없습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingContainer(
      settingTitle: '이용약관',
      items: [
        SelectionItemWithCallback(
          callback: () => _openUrl(dotenv.env['TERMS'], context),
          icon: Icons.policy_rounded,
          selectionName: '서비스 이용약관',
        ),
        SelectionItemWithCallback(
          callback: () => _openUrl(dotenv.env['PRIVACY_POLICY'], context),
          icon: Icons.privacy_tip,
          selectionName: '개인정보 처리방침',
        ),
      ],
    );
  }
}
