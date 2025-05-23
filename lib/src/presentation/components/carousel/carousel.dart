import 'package:farmers_journal/src/presentation/components/card/week_view_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:go_router/go_router.dart';

/// {@category Presentation}
/// A carousel widget displaying a list of journal entries.
///
/// This widget uses a `ConsumerStatefulWidget` to listen for changes in the user state
/// via Riverpod and displays journal cards in a horizontally scrollable carousel format.
class MyCarousel extends ConsumerStatefulWidget {
  /// Constructor for `MyCarousel`, accepting a list of journal entries.
  const MyCarousel({super.key, required this.journals});

  /// Maximum height of each journal card in the carousel.
  final double cardMaxHeight = 200;

  /// Maximum width of each journal card in the carousel.
  final double cardMaxWidth = 150;

  /// List of journal entries to be displayed in the carousel.
  final List<Journal> journals;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyCarouselState();
}

class _MyCarouselState extends ConsumerState<MyCarousel> {
  @override
  Widget build(BuildContext context) {
    // Determine the minimum size of each carousel item based on screen width.
    double minimumItemSize = MediaQuery.sizeOf(context).width / 2.2;

    return Center(
      child: CarouselView(
        enableSplash: false, // Disables splash effect on tap.
        itemSnapping: true, // Ensures items snap into position while scrolling.
        itemExtent: minimumItemSize, // Sets item width.
        shrinkExtent: minimumItemSize, // Defines minimum shrink size.
        children: [
          // Iterate over journal entries and create a carousel item for each.
          for (var journal in widget.journals)
            GestureDetector(
              onTap: () => context.pushNamed(
                'journal-detail',
                pathParameters: {"journalId": journal.id!},
                extra: journal,
              ),
              child: WeekViewCard(
                dateFontSize: 10,
                textMaxLine: 1,
                cardMaxHeight: 200,
                cardMinHeight: 200,
                cardMaxWidth: widget.cardMaxWidth,
                horizontalPadding: 6.0,
                verticalPadding: 0.0,
                journal: journal,
                doEnlarge: false,
              ),
            ),
        ],
      ),
    );
  }
}
