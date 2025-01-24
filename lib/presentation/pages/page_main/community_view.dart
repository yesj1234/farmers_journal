import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_state.dart';
import 'package:farmers_journal/presentation/controller/user/community_view_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/day_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityView extends ConsumerWidget {
  CommunityView({super.key});
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.2;
      if (maxScroll - currentScroll <= delta) {
        ref.read(paginationControllerProvider.notifier).fetchNextBatch();
      }
    });

    return Stack(children: [
      RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(paginationControllerProvider);
        },
        child: CustomScrollView(
          controller: scrollController,
          restorationId: "journals List",
          slivers: const [
            ItemsList(),
            NoMoreItems(),
            OnGoingBottomWidget(),
          ],
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: ScrollToTopButton(scrollController: scrollController),
      ),
    ]);
  }
}

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
  final List<Journal> journals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(communityViewControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return GestureDetector(
              onTap: () {
                ref
                    .read(communityViewControllerProvider.notifier)
                    .getUserById(id: journals[index].id!);
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          height: MediaQuery.sizeOf(context).height * 0.5,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 5,
                              color: Colors.black,
                            ),
                          ),
                          child: userInfo.when(
                            data: (info) {},
                            loading: () {},
                            error: (e, st) {},
                            initial: () {},
                          ),
                        ),
                      );
                    });
              },
              child: _DayViewCard(journal: journals[index]));
        },
        childCount: journals.length,
      ),
    );
  }
}

class NoMoreItems extends ConsumerWidget {
  const NoMoreItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginationControllerProvider);
    return SliverToBoxAdapter(
      child: state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          data: (items) {
            final noMoreItems =
                ref.read(paginationControllerProvider.notifier).noMoreItems;
            return noMoreItems
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text.rich(
                      TextSpan(
                        text: "일지가 더 존재하지 않습니다.",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink();
          }),
    );
  }
}

class OnGoingBottomWidget extends StatelessWidget {
  const OnGoingBottomWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverToBoxAdapter(
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(paginationControllerProvider);
            return state.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              onGoingLoading: (items) => const Center(child: DayViewShimmer()),
              onGoingError: (items, e, st) => const Center(
                child: Column(
                  children: [
                    Icon(Icons.info),
                    SizedBox(height: 20),
                    Text(
                      "Something Went Wrong!",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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

class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: scrollController,
        builder: (context, child) {
          double scrollOffset = scrollController.offset;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: scrollOffset > MediaQuery.of(context).size.height * 0.5
                ? IconButton(
                    icon: Icon(
                      Icons.keyboard_double_arrow_up_outlined,
                      size: 35,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async {
                      scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    })
                : const SizedBox.shrink(),
          );
        });
  }
}
