import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/carousel/carousel.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/scroll_to_top_button.dart';
import 'package:farmers_journal/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

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
class _WeekViewState extends ConsumerState<ConsumerStatefulWidget> {
  /// Future holding the sorted journal data grouped by week.
  late Future<List<WeeklyGroup<Journal>>> _sortedJournals;

  /// Controller for managing the scroll position of the list.
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch weekly grouped journals from the controller
    _sortedJournals =
        ref.read(journalControllerProvider.notifier).getWeekViewJournals();
  }

  @override
  void dispose() {
    scrollController.dispose(); // Clean up scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _sortedJournals,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Stack(
            children: [
              ListView(
                controller: scrollController,
                children: [
                  for (var items in snapshot.data!)
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
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ScrollToTopButton(
                    scrollController: scrollController), // Scroll-to-top button
              ),
            ],
          );
        } else {
          return const SizedBox.shrink(); // Hide if no data
        }
      },
    );
  }
}
