import 'package:farmers_journal/presentation/components/selection_item_with_callback.dart';
import 'package:farmers_journal/presentation/controller/auth/auth_controller.dart';
import 'package:farmers_journal/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              ToggleThemeButton(),
              TermsAndPolicy(),
              Account(),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleThemeButton extends StatefulWidget {
  const ToggleThemeButton({super.key});

  @override
  State<ToggleThemeButton> createState() => _ToggleThemeButtonState();
}

class _ToggleThemeButtonState extends State<ToggleThemeButton> {
  /// Text style for the selection name.
  TextStyle get selectionNameTextStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );
  double? iconSize = 26;
  int _selectedTheme = 0;
  List<bool> get _isSelected =>
      [0, 1, 2].map((index) => _selectedTheme == index).toList();

  Icon get _currentIcon => _selectedTheme == 0
      ? Icon(Icons.sunny, key: ValueKey<int>(_selectedTheme), size: iconSize)
      : _selectedTheme == 1
          ? Icon(
              Icons.mode_night_outlined,
              key: ValueKey<int>(_selectedTheme),
              size: iconSize,
            )
          : Icon(
              Icons.settings,
              key: ValueKey<int>(_selectedTheme),
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
            ToggleButtons(
              onPressed: (index) {
                setState(() {
                  _selectedTheme = index;
                });
              },
              isSelected: _isSelected,
              children: const [
                Icon(Icons.sunny),
                Icon(Icons.mode_night_outlined),
                Icon(Icons.settings)
              ],
            ),
          ],
        )
      ],
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
              context.go('/');
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
              context.go('/');
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("URL을 열 수 없습니다.")));
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
