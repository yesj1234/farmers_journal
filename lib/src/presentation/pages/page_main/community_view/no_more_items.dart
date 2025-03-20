import 'package:farmers_journal/src/presentation/controller/journal/pagination_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@category Presentation}
/// A widget that displays a message when there are no more items to load in a paginated list.
///
/// This widget uses Riverpod to monitor the pagination state and shows a centered
/// message when all items have been loaded. Otherwise, it shrinks to take no space.
class NoMoreItems extends ConsumerWidget {
  /// Creates a [NoMoreItems] widget.
  ///
  /// The [key] parameter is optional and passed to the superclass.
  const NoMoreItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Watch the pagination controller state
    final state = ref.watch(paginationControllerProvider);

    return SliverToBoxAdapter(
      child: state.maybeWhen(
        // Default case: return an empty widget when state is not data
        orElse: () => const SizedBox.shrink(),
        // Handle the data state
        data: (items) {
          // Get the noMoreItems status from the pagination controller
          final noMoreItems =
              ref.read(paginationControllerProvider.notifier).noMoreItems;

          return noMoreItems
              ? Padding(
                  // Add top padding to separate from content above
                  padding: const EdgeInsets.only(top: 20),
                  child: Text.rich(
                    TextSpan(
                      // Display message in Korean indicating no more entries
                      text: "일지가 더 존재하지 않습니다.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    // Center the text horizontally
                    textAlign: TextAlign.center,
                  ),
                )
              // Return empty widget when there are more items to load
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
