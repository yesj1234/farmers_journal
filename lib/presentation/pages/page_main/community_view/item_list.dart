import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_state.dart';
import 'package:farmers_journal/presentation/controller/user/community_view_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/detail_dialog.dart';
import 'package:farmers_journal/presentation/pages/page_main/day_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemsList extends ConsumerWidget {
  const ItemsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PaginationState state = ref.watch(paginationControllerProvider);

    return state.when(
        initial: () =>
            const SliverToBoxAdapter(child: Center(child: DayViewShimmer())),
        data: (items) {
          return items.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref
                              .read(paginationControllerProvider.notifier)
                              .fetchFirstBatch();
                        },
                        icon: const Icon(Icons.replay),
                      ),
                      const Chip(
                        label: Text("No items found!"),
                      ),
                    ],
                  ),
                )
              : ItemsListBuilder(journals: items);
        },
        loading: () =>
            const SliverToBoxAdapter(child: Center(child: DayViewShimmer())),
        error: (e, stk) => const SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.info),
                    SizedBox(height: 20),
                    Text("Something Went Wrong!",
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
        onGoingLoading: (items) {
          return ItemsListBuilder(journals: items);
        },
        onGoingError: (items, e, st) {
          return ItemsListBuilder(journals: items);
        });
  }
}

class ItemsListBuilder extends ConsumerWidget {
  const ItemsListBuilder({
    super.key,
    required this.journals,
  });
  final List<Journal?> journals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(communityViewControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final journalInfo = journals[index];
          return GestureDetector(
              onTap: () {
                ref
                    .read(communityViewControllerProvider.notifier)
                    .getUserById(id: journalInfo!.writer!);
                showDialog(
                    context: context,
                    builder: (context) {
                      return Consumer(builder: (context, ref, child) {
                        final userInfo =
                            ref.watch(communityViewControllerProvider);
                        return userInfo.when(
                          data: (info) => DataStateDialog(
                              info: info, journalInfo: journals[index]!),
                          loading: () => const ShimmerLoadingStateDialog(),
                          error: (e, st) => const ErrorStateDialog(),
                          initial: () => const ShimmerLoadingStateDialog(),
                        );
                      });
                    });
              },
              child: _DayViewCard(journal: journals[index]!));
        },
        childCount: journals.length,
      ),
    );
  }
}

class _DayViewCard extends StatelessWidget {
  const _DayViewCard({super.key, required this.journal});
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
        ),
      ),
    );
  }
}
