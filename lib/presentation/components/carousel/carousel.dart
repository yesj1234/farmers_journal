import 'package:flutter/material.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/data/firestore_service.dart';

import 'package:farmers_journal/domain/model/journal.dart';

// Should be a StatefulWidget since CarouselView can have a controller.
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
    double minimumItemSize = MediaQuery.sizeOf(context).width / 3;

    return Center(
      child: CarouselView(
        itemSnapping: true,
        itemExtent: minimumItemSize,
        shrinkExtent: minimumItemSize,
        children: [
          for (var journal in widget.journals)
            CardSingle(
                dateFontSize: 10,
                textMaxLine: 1,
                cardMaxWidth: widget.cardMaxWidth,
                includeUpperDate: false,
                horizontalPadding: 2.0,
                verticalPadding: 0.0,
                aspectRatio: 2 / 1,
                journal: journal),
        ],
      ),
    );
  }
}
