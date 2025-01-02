import 'package:farmers_journal/presentation/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/presentation/controller/auth/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileBanner extends ConsumerStatefulWidget {
  const ProfileBanner({super.key, this.editMode = false, this.toggleEdit});
  final bool editMode;
  final VoidCallback? toggleEdit;
  @override
  ConsumerState<ProfileBanner> createState() => _ProfileBannerState();
}

class _ProfileBannerState extends ConsumerState<ProfileBanner> {
  TextStyle get displayNameTextStyle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );
  TextStyle get emailTextStyle => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
      );
  List<Widget> get defaultProfileBanner => [
        Text("anonymous", style: displayNameTextStyle),
        Text("anonymous@anonymous.com", style: emailTextStyle),
      ];

  TextEditingController displayNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<User?> user = ref.watch(authControllerProvider);
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 90,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(174, 189, 175, 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          AvatarProfile(
            width: 60,
            height: 60,
            onNavigateTap: () => context.go('/main/settings'),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: user.maybeWhen(
              orElse: () => defaultProfileBanner,
              data: (value) => [
                widget.editMode
                    ? Row(children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width / 1.7),
                          child: TextFormField(
                            controller: displayNameController,
                            autofocus: true,
                            decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              hintText: value?.displayName,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            // Set edit mode to false
                            widget.toggleEdit!();
                            await ref
                                .read(authControllerProvider.notifier)
                                .setProfileName(
                                    name: displayNameController.text);
                          },
                          icon: const Icon(Icons.check),
                        )
                      ])
                    : Text('${value?.displayName}',
                        style: displayNameTextStyle),
                Text('${value?.email}', style: emailTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
