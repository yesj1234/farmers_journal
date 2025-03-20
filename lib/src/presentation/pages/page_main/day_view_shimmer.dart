import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// {@category Presentation}
class DayViewShimmer extends StatelessWidget {
  const DayViewShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceContainer,
      highlightColor: Theme.of(context)
          .colorScheme
          .onSurface
          .withAlpha((0.3 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Center(
          child: Card.outlined(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2.0,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - 32,
              height: 170,
            ),
          ),
        ),
      ),
    );
  }
}
