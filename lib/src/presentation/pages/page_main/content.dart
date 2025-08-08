import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller.dart';
import '../../../../domain.dart';
import '../../../../enums.dart';
import '../../../data/providers.dart';
import 'community_view/community_view.dart';
import 'day_view/day_view.dart';
import 'month_view/month_view.dart';
import 'week_view.dart';

/// The main content section of the page, displaying journal entries.
class Content extends ConsumerWidget {
  /// Creates a [Content] widget.
  const Content({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalControllerProvider);

    return journals.when(
      data: (data) {
        return _UserContent(
          journals: data,
          scrollController: scrollController,
        );
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
  const _UserContent({required this.journals, required this.scrollController});
  final ScrollController scrollController;

  /// The list of journal entries to display.
  final List<Journal?> journals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainViewFilter = ref.watch(mainViewFilterProvider);
    return switch (mainViewFilter) {
      MainView.day => journals.isEmpty
          ? const _DefaultContent()
          : DayView(
              scrollController: scrollController,
            ),
      MainView.week => journals.isEmpty
          ? const _DefaultContent()
          : WeekView(
              scrollController: scrollController,
            ),
      MainView.month =>
        journals.isEmpty ? const _DefaultContent() : MonthView(),
      MainView.community => CommunityView(
          scrollController: scrollController,
        ),
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
