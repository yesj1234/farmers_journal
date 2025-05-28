import 'package:farmers_journal/src/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/pagination_state.dart'
    as pagination_state;
import 'package:farmers_journal/src/presentation/pages/page_main/day_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@category Presentation}
/// A widget that displays loading or error states at the bottom of a paginated list.
///
/// This widget monitors the pagination state using Riverpod and shows either a
/// loading shimmer effect or an error message when appropriate. It shrinks when
/// no special state needs to be displayed.
class OnGoingBottomWidget extends StatelessWidget {
  /// Creates an [OnGoingBottomWidget].
  ///
  /// The [key] parameter is optional and passed to the superclass.
  const OnGoingBottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      // Add consistent padding around the content
      padding: const EdgeInsets.all(10),
      sliver: SliverToBoxAdapter(
        child: Consumer(
          builder: (context, ref, child) {
            // Monitor the pagination controller state
            final state = ref.watch(paginationControllerProvider);

            return switch (state) {
              pagination_state.OnGoingLoading(:final journals) =>
                const Center(child: DayViewShimmer()),
              pagination_state.OnGoingError() => Center(
                  child: Column(
                    children: [
                      const Icon(Icons.info), // Visual indicator of error
                      const SizedBox(height: 20), // Spacing between elements
                      Text(
                        "Something Went Wrong!",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
