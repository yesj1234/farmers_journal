import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/item_list.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/no_more_items.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/on_going_bottom_widget.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/scroll_to_top_button.dart';

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
      double delta = MediaQuery.sizeOf(context).width * 0.2;
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
    return Stack(
      children: [
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
      ],
    );
  }
}
