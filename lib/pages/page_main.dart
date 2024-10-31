import 'package:flutter/material.dart';

import 'package:farmers_journal/components/button/button_create_post.dart';
import 'package:farmers_journal/components/button/button_status.dart';
import 'package:farmers_journal/components/avatar/avatar_profile.dart';

/// TODO:
///  - 1. Apply font. Pretandard
///  - 2. Connect FireStore(?) image provider for button profile avatar component.
///  - 3. Make the page responsive.
///  - 4. Connect Database. :: _Content should change based on the user's journal status.
///  - 5. Think of the properties that should be resolved to each child components. => Needs modeling first.
///  - 6. Add onTap / onClick callback to profile image directing to the profile setting page.
class PageMain extends StatelessWidget {
  const PageMain({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              Spacer(),
              _TopNavTemp(),
              Spacer(flex: 9),
              _Content(),
              Spacer(flex: 10)
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
                const AvatarProfile(width: 70, height: 70),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.bold,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/LogoTemp.png"),
          const SizedBox(
            height: 15,
          ),
          Text("일지를 작성해보세요", style: textStyle),
        ],
      ),
    );
  }
}
