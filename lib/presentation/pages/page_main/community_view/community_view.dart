import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/item_list.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/no_more_items.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/on_going_bottom_widget.dart';
import 'package:farmers_journal/presentation/pages/page_main/community_view/scroll_to_top_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@category Presentation}
/// A stateful widget that displays a paginated list of journal entries in a community view.
///
/// This view supports infinite scrolling and refresh functionality to load more journal entries dynamically.
class CommunityView extends ConsumerStatefulWidget {
  /// Creates a [CommunityView] widget.
  const CommunityView({super.key});

  @override
  ConsumerState<CommunityView> createState() => _CommunityViewState();
}

/// The state class for [CommunityView].
class _CommunityViewState extends ConsumerState<CommunityView> {
  /// Scroll controller to track the user's scroll position.
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.sizeOf(context).width * 0.2;

      // Fetches the next batch of journal entries when nearing the bottom of the list.
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
