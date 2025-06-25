import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:farmers_journal/src/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/src/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/pagination_state.dart'
    as pagination_state;
import 'package:farmers_journal/src/presentation/controller/user/community_view_controller.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/day_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// {@category Presentation}
/// A widget that displays a list of journal items based on pagination state.
///
/// This widget uses Riverpod to listen to the [paginationControllerProvider] and
/// renders different UI states (initial, data, loading, error) accordingly.
class ItemsList extends ConsumerWidget {
  /// Creates an [ItemsList] widget.
  const ItemsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pagination_state.PaginationState state =
        ref.watch(paginationControllerProvider);

    return switch (state) {
      pagination_state.Initial() => Center(child: DayViewShimmer()),
      pagination_state.Loading() => Center(child: DayViewShimmer()),
      pagination_state.Error(:final e, :final stk) => Center(
          child: Column(
            children: [
              Icon(Icons.info),
              SizedBox(height: 20),
              Text("Something Went Wrong!",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      pagination_state.Data(:final journals) => () {
          return journals.isEmpty
              ? Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(paginationControllerProvider.notifier)
                            .fetchFirstBatch();
                      },
                      icon: Icon(
                        Icons.replay,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Chip(
                      label: Text(
                        "일지가 더 존재 하지 않습니다!",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : ItemsListBuilder(journals: journals);
        }(),
      pagination_state.OnGoingLoading(:final journals) => () {
          return ItemsListBuilder(journals: journals);
        }(),
      pagination_state.OnGoingError(:final journals) => () {
          return ItemsListBuilder(journals: journals);
        }(),
    };
  }
}

/// A widget that builds a scrollable list of journal items.
///
/// This widget takes a list of journals and renders them as clickable cards.
/// Tapping a card opens a dialog with detailed journal and user information.
class ItemsListBuilder extends ConsumerWidget {
  /// Creates an [ItemsListBuilder] with a list of journals.
  const ItemsListBuilder({
    super.key,
    required this.journals,
  });

  /// The list of journal entries to display. Can contain null values.
  final List<Journal?> journals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(communityViewControllerProvider);
    final children = journals
        .map((journal) => GestureDetector(
              onTap: () => context.pushNamed(
                'journal-detail',
                pathParameters: {"journalId": journal.id!},
                extra: journal,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: _DayViewCard(journal: journal!),
              ),
            ))
        .toList();
    return Column(children: children);
  }
}

/// A widget that displays a single journal entry in a card format.
///
/// This is an internal helper widget used by [ItemsListBuilder] to render
/// individual journal cards.
class _DayViewCard extends StatelessWidget {
  /// Creates a [_DayViewCard] with a required journal.
  const _DayViewCard({required this.journal});

  /// The journal entry to display in the card.
  final Journal journal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Center(
        child: DayViewCard(
          verticalPadding: 0,
          journal: journal,
          editable: false,
          doEnlarge: false,
        ),
      ),
    );
  }
}
