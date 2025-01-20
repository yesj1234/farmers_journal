import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';
import 'package:flutter/material.dart';

class LayoutImagesDetailScreen extends StatelessWidget {
  const LayoutImagesDetailScreen({
    super.key,
    required this.tags,
    required this.initialIndex,
  });
  final List<UrlImage> tags;
  final int initialIndex;
  @override
  Widget build(BuildContext context) {
    final heroWidgets = tags
        .map(
          (path) => Hero(
            tag: path.value,
            child: CachedNetworkImage(
              imageUrl: path.value,
            ),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: DetailScreenPageView(
          widgets: heroWidgets,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class DetailScreenPageView extends StatefulWidget {
  const DetailScreenPageView(
      {super.key, required this.widgets, required this.initialIndex});
  final List<Widget> widgets;
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
        length: widget.widgets.length,
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView(
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: widget.widgets),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
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
