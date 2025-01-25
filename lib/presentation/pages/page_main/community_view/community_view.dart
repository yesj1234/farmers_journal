import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_state.dart';
import 'package:farmers_journal/presentation/controller/user/community_view_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/day_view_shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({super.key});

  @override
  ConsumerState<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.2;
      if (maxScroll - currentScroll <= delta) {
        ref.read(paginationControllerProvider.notifier).fetchNextBatch();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    ref.watch(communityViewControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final journalInfo = journals[index];
          return GestureDetector(
              onTap: () {
                ref
                    .read(communityViewControllerProvider.notifier)
                    .getUserById(id: journalInfo.writer!);
                showDialog(
                    context: context,
                    builder: (context) {
                      return Consumer(builder: (context, ref, child) {
                        final userInfo =
                            ref.watch(communityViewControllerProvider);
                        return userInfo.when(
                          data: (info) => DataStateDialog(
                              info: info, journalInfo: journals[index]),
                          loading: () => const ShimmerLoadingStateDialog(),
                          error: (e, st) => const ErrorStateDialog(),
                          initial: () => const ShimmerLoadingStateDialog(),
                        );
                      });
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

class DataStateDialog extends StatelessWidget {
  final AppUser info;
  final Journal journalInfo;

  const DataStateDialog({
    super.key,
    required this.info,
    required this.journalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(info.profileImage!),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        info.nickName!,
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${journalInfo.plant}, ',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: journalInfo.place,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  if (journalInfo.title!.isNotEmpty) Text(journalInfo.title!),
                  if (journalInfo.content!.isNotEmpty)
                    Text(journalInfo.content!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerLoadingStateDialog extends StatelessWidget {
  const ShimmerLoadingStateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer for profile row
              Row(
                children: [
                  _shimmerCircle(size: 50),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerRectangle(width: 120, height: 16),
                      const SizedBox(height: 8),
                      _shimmerRectangle(width: 80, height: 14),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Shimmer for content placeholder
              _shimmerRectangle(width: 200, height: 16),
              const SizedBox(height: 10),
              _shimmerRectangle(width: double.infinity, height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerRectangle({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _shimmerCircle({required double size}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ErrorStateDialog extends StatelessWidget {
  const ErrorStateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(height: 10),
            Text(
              "Error occurred while loading data!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
