// packages
import 'dart:collection';
import 'dart:developer';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/day_view.dart';
import 'package:farmers_journal/presentation/pages/page_main/month_view.dart';
import 'package:farmers_journal/presentation/pages/page_main/week_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:table_calendar/table_calendar.dart';

//Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/data/providers.dart';

// custom components
import 'package:farmers_journal/presentation/components/button/button_create_post.dart';
import 'package:farmers_journal/presentation/components/button/button_status.dart';
import 'package:farmers_journal/presentation/components/button/button_filter_date.dart';
import 'package:farmers_journal/presentation/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/presentation/components/carousel/carousel.dart';

// enums
import 'package:farmers_journal/enums.dart';

// models
import 'package:farmers_journal/domain/model/journal.dart';

// utils
import 'package:farmers_journal/utils.dart';

class PageMain extends ConsumerWidget {
  const PageMain({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalRef = ref.watch(journalControllerProvider);
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
              const _TopNavTemp(),
              Divider(
                thickness: 0.5,
                indent: 10,
                endIndent: 10,
                color: Theme.of(context).primaryColor,
              ),
              journalRef.hasValue && journalRef.value!.isNotEmpty
                  ? const Align(
                      alignment: Alignment.centerLeft,
                      child: ButtonFilterDate(),
                    )
                  : const SizedBox.shrink(),
              const Expanded(child: _Content()),
            ],
          ),
        ),
      ),
      floatingActionButton: ButtonCreatePost(
        onClick: () => context.go('/create'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _TopNavTemp extends ConsumerWidget {
  const _TopNavTemp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider);
    final journal = ref.watch(journalControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicHeight(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    user.value != null
                        ? user.value!.plants.isNotEmpty
                            ? ButtonStatus(
                                status: "작물",
                                statusValue: user.value?.plants[0].name,
                                statusIcon: Icons.eco,
                                statusIconColor: Colors.green,
                                onNavigateTap: () =>
                                    context.go('/main/statistics'),
                              )
                            : ButtonStatus(
                                status: "작물",
                                statusValue: '설정 필요',
                                statusIcon: Icons.eco,
                                statusIconColor: Colors.green,
                                onNavigateTap: () =>
                                    context.go('/initial_setting'),
                              )
                        : ButtonStatus(
                            status: "작물",
                            statusValue: '설정 필요',
                            statusIcon: Icons.eco,
                            statusIconColor: Colors.green,
                            onNavigateTap: () => context.go('/initial_setting'),
                          ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    ButtonStatus(
                      status: "일지",
                      statusValue: journal.value != null
                          ? '${journal.value?.length} 개'
                          : '0 개',
                      statusIcon: Icons.local_fire_department_sharp,
                      statusIconColor: Colors.red,
                      onNavigateTap: () => context.go('/main/statistics'),
                    )
                  ],
                ),
                const Spacer(),
                AvatarProfile(
                  width: 60,
                  height: 60,
                  onNavigateTap: () => context.go('/main/profile'),
                ),
              ],
            ),
          ),
        )
      ],
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
        MainView.community => const Placeholder(),
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
