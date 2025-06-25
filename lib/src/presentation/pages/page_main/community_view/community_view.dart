import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item_list.dart';
import 'no_more_items.dart';
import 'on_going_bottom_widget.dart';
import '../../../controller/journal/pagination_controller.dart';

/// {@category Presentation}
/// A stateful widget that displays a paginated list of journal entries in a community view.
///
/// This view supports infinite scrolling and refresh functionality to load more journal entries dynamically.
class CommunityView extends ConsumerStatefulWidget {
  /// Creates a [CommunityView] widget.
  const CommunityView({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  ConsumerState<CommunityView> createState() => _CommunityViewState();
}

/// The state class for [CommunityView].
class _CommunityViewState extends ConsumerState<CommunityView> {
  void onScroll() {
    double maxScroll = widget.scrollController.position.maxScrollExtent;
    double currentScroll = widget.scrollController.position.pixels;
    double delta = MediaQuery.sizeOf(context).width * 0.2;

    // Fetches the next batch of journal entries when nearing the bottom of the list.
    if (maxScroll - currentScroll <= delta) {
      ref.read(paginationControllerProvider.notifier).fetchNextBatch();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(onScroll);
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
          child: Column(
            children: const [
              ItemsList(),
              NoMoreItems(),
              OnGoingBottomWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
