import '../../components/carousel/carousel.dart';
import '../../controller/journal/week_view_controller.dart';
import '../../controller/journal/week_view_state.dart' as week_view_state;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// {@category Presentation}
/// A widget displaying journals grouped by week in a scrollable list with carousels.
///
/// This widget fetches journals from the journal controller, groups them by week,
/// and presents each group with a label and a horizontal carousel.
class WeekView extends ConsumerWidget {
  /// Creates a [WeekView] widget.
  ///
  /// The [key] parameter is optional and passed to the superclass.
  const WeekView({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          return Column(
            children: children,
          );
        }(),
      week_view_state.Loading() =>
        const Center(child: CircularProgressIndicator()),
      _ => const SizedBox.shrink(),
    };
  }
}
