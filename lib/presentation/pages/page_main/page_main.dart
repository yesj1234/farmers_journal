// packages
import 'dart:developer';

import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/community_view.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/scroll_to_top_button.dart';
import 'package:farmers_journal/presentation/pages/page_main/day_view.dart';
import 'package:farmers_journal/presentation/pages/page_main/month_view.dart';
import 'package:farmers_journal/presentation/pages/page_main/top_nav.dart';
import 'package:farmers_journal/presentation/pages/page_main/week_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/data/providers.dart';
// custom components
import 'package:farmers_journal/presentation/components/button/button_create_post.dart';
import 'package:farmers_journal/presentation/components/button/button_filter_date.dart';
// enums
import 'package:farmers_journal/enums.dart';
// models
import 'package:farmers_journal/domain/model/journal.dart';

class PageMain extends ConsumerWidget {
  const PageMain({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalRef = ref.watch(journalControllerProvider);
    final userRef = ref.watch(userControllerProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          title: Text(
            '농업 일지',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10),
              const TopNav(),
              Divider(
                thickness: 0.5,
                indent: 10,
                endIndent: 10,
                color: Theme.of(context).primaryColor,
              ),
              journalRef.hasValue && journalRef.value!.isNotEmpty
                  ? const Align(
                      alignment: Alignment.centerLeft,
                      child: ButtonMainViewFilter(),
                    )
                  : const SizedBox.shrink(),
              const Expanded(child: _Content()),
            ],
          ),
        ),
      ),
      floatingActionButton: ButtonCreatePost(
        onClick: () {
          // 초기 설정 없으면 초기 설정 페이지로 이동
          if (userRef.value!.isInitialSettingRequired) {
            log('..');
            context.go('/initial_setting');
          } else {
            context.go('/create');
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalControllerProvider);

    return journals.when(
      data: (data) {
        return _UserContent(journals: data);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) {
        return Center(
          child: Text(
            e.toString(),
          ),
        );
      },
    );
  }
}

class _UserContent extends ConsumerWidget {
  const _UserContent({super.key, required this.journals});
  final List<Journal?> journals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainViewFilter = ref.watch(mainViewFilterProvider);
    if (journals.isNotEmpty) {
      return switch (mainViewFilter) {
        MainView.day => const DayView(),
        MainView.week => const WeekView(),
        MainView.month => const MonthView(),
        MainView.community => const CommunityView(),
      };
    } else {
      return const _DefaultContent();
    }
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
      children: [
        const Spacer(flex: 2),
        Image.asset("assets/icons/LogoTemp.png"),
        const SizedBox(
          height: 15,
        ),
        Text("일지를 작성해보세요", style: textStyle),
        const Spacer(flex: 3),
      ],
    );
  }
}
