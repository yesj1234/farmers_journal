import 'package:auto_size_text/auto_size_text.dart';
import 'package:farmers_journal/presentation/components/avatar/avatar_profile.dart';

import 'package:farmers_journal/presentation/controller/user/user_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key, this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          const Spacer(),
          AvatarProfile(
            width: 100,
            height: 100,
            onNavigateTap: () => context.go('/main/profile/edit_profile'),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 130,
            ),
            child: _UserDisplayName(
              userName: userName,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.go('/main/profile/edit_profile');
            },
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.black54,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserDisplayName extends ConsumerStatefulWidget {
  const _UserDisplayName({
    super.key,
    this.userName,
  });

  final String? userName;
  @override
  ConsumerState<_UserDisplayName> createState() => _UserDisplayNameState();
}

class _UserDisplayNameState extends ConsumerState<_UserDisplayName> {
  TextStyle get displayNameTextStyle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );
  TextStyle get subTextStyle => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
      );

  String? defaultDisplayName;
  String? defaultEmail;

  TextEditingController displayNameController = TextEditingController();

  @override
  void dispose() {
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRef = ref.watch(userControllerProvider);
    return userRef.maybeWhen(
      orElse: () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text('', style: displayNameTextStyle),
          ),
          Text('', style: subTextStyle),
        ],
      ),
      data: (value) {
        final displayName = value?.name ?? '';
        final nickName = value?.nickName ?? '';

        final place =
            value!.plants.isNotEmpty ? value.plants[0].place : '초기 설정 필요';

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(displayName, style: displayNameTextStyle),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                nickName,
                style: subTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AutoSizeText(
              place,
              style: subTextStyle,
              maxLines: 2,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}
