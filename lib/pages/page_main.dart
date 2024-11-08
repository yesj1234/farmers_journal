import 'package:flutter/material.dart';
//Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/providers.dart';
import 'package:farmers_journal/model/user.dart';

import 'package:farmers_journal/components/button/button_create_post.dart';
import 'package:farmers_journal/components/button/button_status.dart';
import 'package:farmers_journal/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/components/card/card_single.dart';

/// TODO:
///  - 1. Apply font. Pretandard
///  - 2. Connect FireStore(?) image provider for button profile avatar component.
///  - 3. Make the page responsive.
///  - 4. Connect Database. :: _Content should change based on the user's journal status.
///  - 5. Think of the properties that should be resolved to each child components. => Needs modeling first.
///  - 6. Add onTap / onClick callback to profile image directing to the profile setting page.
class PageMain extends ConsumerWidget {
  const PageMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _TopNavTemp(),
              Expanded(child: _Content()),
            ],
          ),
        ),
      ),
      floatingActionButton: ButtonCreatePost(
        onClick: () => debugPrint("clicked"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _TopNavTemp extends StatelessWidget {
  const _TopNavTemp();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("농사 일지",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        IntrinsicHeight(
          child: SizedBox(
            height: 55,
            child: Row(
              children: [
                ButtonStatus(
                  status: "작물",
                  statusValue: "포도(캠벨얼리)",
                  statusEmoji: "assets/icons/Grapes.png",
                  onClick: () => debugPrint("Clicked"),
                ),
                const VerticalDivider(
                  thickness: 2,
                ),
                ButtonStatus(
                  status: "기록일수",
                  statusValue: "0 일",
                  statusEmoji: "assets/icons/Fire.png",
                  onClick: () => debugPrint("Clicked"),
                ),
                const Spacer(),
                const AvatarProfile(width: 55, height: 55),
              ],
            ),
          ),
        )
      ],
    );
  }
}

/// TODO
/// 1. Fetch user data from firestore => StatefulWidget.
/// 2. Based on the content status of the user show DefaultContent or the CardView and Consider the responsiveness.
/// 3. Add sorting buttons.
class _Content extends StatelessWidget {
  final bool _isEmpty = false; // To be replaced to fetching logic.

  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget child = _isEmpty ? const _DefaultContent() : _UserContent();

    return Center(child: child);
  }
}

class _DefaultContent extends StatelessWidget {
  const _DefaultContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/icons/LogoTemp.png"),
        const SizedBox(
          height: 15,
        ),
        Text("일지를 작성해보세요", style: textStyle),
      ],
    );
  }
}

class _UserContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalProvider);

    return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 4.0),
        children: switch (journals) {
          AsyncData(:final value) => [
              for (var journal in value)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Center(
                    child: CardSingle(
                        title: journal.title,
                        content: journal.content,
                        createdAt: journal.createdAt,
                        image: journal.image),
                  ),
                )
            ],
          AsyncError() => [const Text("Oops! Something went wrong")],
          _ => [const CircularProgressIndicator()]
        });
  }
}
