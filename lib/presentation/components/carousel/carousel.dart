import 'package:farmers_journal/presentation/components/card/week_view_card.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:farmers_journal/domain/model/journal.dart';

class MyCarousel extends ConsumerStatefulWidget {
  const MyCarousel({super.key, required this.journals});
  final double cardMaxHeight = 200;
  final double cardMaxWidth = 150;
  final List<Journal> journals;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyCarouselState();
}

class _MyCarouselState extends ConsumerState<MyCarousel> {
  @override
  Widget build(BuildContext context) {
    double minimumItemSize = MediaQuery.sizeOf(context).width / 2.2;

    return Center(
      child: CarouselView(
        enableSplash: false,
        itemSnapping: true,
        itemExtent: minimumItemSize,
        shrinkExtent: minimumItemSize,
        children: [
          for (var journal in widget.journals)
            WeekViewCard(
                dateFontSize: 10,
                textMaxLine: 1,
                cardMaxHeight: 200,
                cardMinHeight: 200,
                cardMaxWidth: widget.cardMaxWidth,
                horizontalPadding: 6.0,
                verticalPadding: 0.0,
                journal: journal),
        ],
      ),
    );
  }
}
