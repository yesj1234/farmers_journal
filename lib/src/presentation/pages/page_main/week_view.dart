import 'package:farmers_journal/src/presentation/components/carousel/carousel.dart';

import 'package:farmers_journal/src/presentation/controller/journal/week_view_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/week_view_state.dart'
    as week_view_state;
import 'package:farmers_journal/src/presentation/pages/page_main/community_view/scroll_to_top_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// {@category Presentation}
/// A widget displaying journals grouped by week in a scrollable list with carousels.
///
/// This widget fetches journals from the journal controller, groups them by week,
/// and presents each group with a label and a horizontal carousel.
class WeekView extends ConsumerStatefulWidget {
  /// Creates a [WeekView] widget.
  ///
  /// The [key] parameter is optional and passed to the superclass.
  const WeekView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeekViewState();
}

/// The state for [WeekView], managing journal data and scrolling.
class _WeekViewState extends ConsumerState<WeekView> {
  /// Controller for managing the scroll position of the list.
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose(); // Clean up scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journals = ref.watch(weekViewControllerProvider);
    return switch (journals) {
      week_view_state.Data(:final data) => () {
          final List<Widget> children = [];
          for (var items in data) {
            children.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      items.weekLabel, // Display week label
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200, // Fixed height for carousel
                    child: MyCarousel(journals: items.items),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              ListView(
                controller: scrollController,
                children: children,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ScrollToTopButton(
                  scrollController: scrollController,
                ),
              ),
            ],
          );
        }(),
      week_view_state.Loading() =>
        const Center(child: CircularProgressIndicator()),
      _ => const SizedBox.shrink(),
    };
  }
}
