import 'package:farmers_journal/domain/model/user.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_initial_setting/page_initial_setting.dart';
import 'package:farmers_journal/presentation/pages/page_login/page_login.dart';
import 'package:farmers_journal/presentation/pages/page_main.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthBridge extends StatelessWidget {
  const AuthBridge({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          /// TODO: if the user has finished initial setting redirect to the main page
          /// else redirect to the initial setting page
          return const UserBridge();
        } else {
          return const PageLogin();
        }
      },
    );
  }
}

class UserBridge extends ConsumerStatefulWidget {
  const UserBridge({super.key});
  @override
  ConsumerState<UserBridge> createState() => _UserBridgeState();
}

class _UserBridgeState extends ConsumerState<UserBridge> {
  late final Future<AppUser?> _user;
  @override
  void initState() {
    super.initState();
    _user = ref.read(userControllerProvider.notifier).build();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isInitialSettingRequired) {
              return const PageInitialSetting();
            } else {
              return const PageMain();
            }
          } else {
            return const PageLogin();
          }
        });
  }
}
