import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:flutter/material.dart';

import '../../../components/layout_images/layout_images_detail_screen.dart';
import '../../page_journal/image_type.dart';

class ImagePageView extends StatefulWidget {
  const ImagePageView({super.key, required this.journal});
  final Journal journal;

  @override
  State<ImagePageView> createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView>
    with SingleTickerProviderStateMixin {
  late final PageController _pageViewController;
  late final TabController _tabController;

  /// Opacity transition curve for hero animations.
  static const opacityCurve = Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 0);
    _tabController = TabController(
        initialIndex: 0, length: widget.journal.images!.length, vsync: this);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageView = PageView(
      controller: _pageViewController,
      onPageChanged: _handlePageViewChanged,
      children: widget.journal.images!
          .map(
            (url) => GestureDetector(
              onTap: () async {
                final currentIndex = _tabController.index;
                final newIndex = await Navigator.of(context).push<int>(
                  PageRouteBuilder(
                    maintainState: true,
                    opaque: false,
                    transitionsBuilder: (context, animation, _, child) =>
                        Opacity(
                            opacity: opacityCurve.transform(animation.value),
                            child: child),
                    pageBuilder: (
                      context,
                      _,
                      __,
                    ) =>
                        DetailScreenPageView(
                      tags: widget.journal.images!
                          .map((url) => UrlImage(url!))
                          .toList(),
                      initialIndex: _tabController.index,
                    ),
                  ),
                );
                if (newIndex != currentIndex && newIndex != null) {
                  _pageViewController.jumpToPage(newIndex);
                  _tabController.index = newIndex;
                }
              },
              child: Hero(
                tag: url!,
                transitionOnUserGestures: true,
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
          .toList(),
    );

    return Stack(
      children: [
        pageView,
        Align(
          alignment: Alignment.bottomCenter,
          child: PageIndicator(
            tabController: _tabController,
          ),
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
  }
}
