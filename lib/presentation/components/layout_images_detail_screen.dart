import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';

import 'package:flutter/material.dart';

class DetailScreenPageView extends StatefulWidget {
  const DetailScreenPageView(
      {super.key, required this.tags, required this.initialIndex});

  final List<UrlImage> tags;
  final int initialIndex;
  static const double kMinRadius = 32.0;
  static const double kMaxRadius = 128.0;

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
    final heroWidgets = widget.tags.map(
      (path) {
        final tag = path.value;
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Hero(
            tag: tag,
            createRectTween: (Rect? begin, Rect? end) {
              return RectTween(begin: begin, end: end);
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
        );
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).width,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                  controller: _pageViewController,
                  onPageChanged: _handlePageViewChanged,
                  children: heroWidgets),
              PageIndicator(
                tabController: _tabController,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
  }
}

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
