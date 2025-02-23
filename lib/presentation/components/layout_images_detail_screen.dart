import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';

import 'package:flutter/material.dart';

/// A screen that displays images in a page view with hero animations.
///
/// It supports swipe gestures to navigate between images and to dismiss the screen.
class DetailScreenPageView extends StatefulWidget {
  /// Creates a detail screen for viewing images.
  ///
  /// [tags] is a list of `UrlImage` objects representing images to be displayed.
  /// [initialIndex] determines which image should be shown first.
  const DetailScreenPageView(
      {super.key, required this.tags, required this.initialIndex});

  final List<UrlImage> tags;
  final int initialIndex;

  @override
  State<DetailScreenPageView> createState() => _DetailScreenPageView();
}

class _DetailScreenPageView extends State<DetailScreenPageView>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: widget.initialIndex);

    _tabController = TabController(
        initialIndex: widget.initialIndex,
        length: widget.tags.length,
        vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Creates a list of widgets for the page view, each wrapped in a Hero animation.
    final heroWidgets = widget.tags.map(
      (path) {
        final tag = path.value;
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta!.abs() > 20) {
              Navigator.pop(context); // Swipe up/down to close
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Hero(
                tag: tag,
                createRectTween: (Rect? begin, Rect? end) {
                  return MaterialRectArcTween(begin: begin, end: end);
                },
                transitionOnUserGestures: true,
                child: Center(
                  child: URLImageTile(
                    url: tag,
                    onDelete: () {},
                    isEditMode: false,
                    maxWidth: MediaQuery.sizeOf(context).width,
                    minWidth: MediaQuery.sizeOf(context).width,
                    maxHeight: MediaQuery.sizeOf(context).height,
                    minHeight: MediaQuery.sizeOf(context).height,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).toList();

    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta!.abs() > 20) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).width,
              child: Stack(
                alignment: Alignment.bottomCenter,

                /// PageView for swiping between images
                children: [
                  PageView(
                      controller: _pageViewController,
                      onPageChanged: _handlePageViewChanged,
                      children: heroWidgets),

                  /// Page Indicator to show progress in the gallery
                  PageIndicator(
                    tabController: _tabController,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  /// Updates the tab indicator when the page view is swiped.
  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
  }
}

/// A widget that displays a page indicator for the `DetailScreenPageView`.
///
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TabPageSelector(
            controller: tabController,
            color: colorScheme.surface,
            selectedColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
