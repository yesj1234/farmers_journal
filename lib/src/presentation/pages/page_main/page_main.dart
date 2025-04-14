// packages
import 'package:farmers_journal/src/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/community_view/community_view.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/day_view/day_view.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/month_view/month_view.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/top_nav.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/week_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/src/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/src/data/providers.dart';
// custom components
import 'package:farmers_journal/src/presentation/components/button/button_create_post.dart';

// enums
import 'package:farmers_journal/enums.dart';
// models
import 'package:farmers_journal/src/domain/model/journal.dart';

/// {@category Presentation}
/// The main page widget that consumes Riverpod providers.
///
/// Displays the navigation, content sections, and a floating action button for creating posts.
class PageMain extends ConsumerWidget {
  /// Creates a [PageMain] widget.
  const PageMain({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userControllerProvider(null));
    final currentMainView = ref.watch(mainViewFilterProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SafeArea(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: TopNav(),
              ),
              Divider(
                thickness: 0.5,
                indent: 10,
                endIndent: 10,
                color: Theme.of(context).primaryColor,
              ),
              const Expanded(child: _Content()),
            ],
          ),
        ),
      ),
      floatingActionButton: ButtonCreatePost(
        onClick: () {
          // 초기 설정 없으면 초기 설정 페이지로 이동
          if (userRef.value!.isInitialSettingRequired) {
            context.go('/initial_setting');
          } else {
            context.push('/create');
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFF2F2F2),
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(mainViewFilterProvider.notifier).changeDateFilter(
                          MainView.day,
                        ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.calendar_view_day), Text("일간")],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(mainViewFilterProvider.notifier).changeDateFilter(
                          MainView.week,
                        ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.calendar_view_week), Text("주간")],
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(mainViewFilterProvider.notifier).changeDateFilter(
                          MainView.month,
                        ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.calendar_view_week), Text("월간")],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(mainViewFilterProvider.notifier).changeDateFilter(
                          MainView.community,
                        ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.calendar_view_week), Text("커뮤니티")],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The main content section of the page, displaying journal entries.
class _Content extends ConsumerWidget {
  /// Creates a [_Content] widget.
  const _Content();

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

/// Displays journal entries based on the selected view filter.
class _UserContent extends ConsumerWidget {
  /// Creates a [_UserContent] widget.
  const _UserContent({required this.journals});

  /// The list of journal entries to display.
  final List<Journal?> journals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainViewFilter = ref.watch(mainViewFilterProvider);
    return switch (mainViewFilter) {
      MainView.day =>
        journals.isEmpty ? const _DefaultContent() : const DayView(),
      MainView.week =>
        journals.isEmpty ? const _DefaultContent() : const WeekView(),
      MainView.month =>
        journals.isEmpty ? const _DefaultContent() : const MonthView(),
      MainView.community => const CommunityView(),
    };
  }
}

/// Displays default content when no journal entries exist.
class _DefaultContent extends StatelessWidget {
  /// Creates a [_DefaultContent] widget.
  const _DefaultContent();

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
