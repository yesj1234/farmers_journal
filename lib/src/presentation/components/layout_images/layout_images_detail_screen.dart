import 'dart:ui';
import 'package:farmers_journal/src/presentation/components/image_tile.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/image_type.dart';

import 'package:flutter/material.dart';

/// {@category Presentation}
/// A screen that displays images in a page view with hero animations.
///
/// It supports swipe gestures to navigate between images and to dismiss the screen.
class DetailScreenPageView extends StatefulWidget {
  /// Creates a detail screen for viewing images.
  ///
  /// [tags] is a list of `UrlImage` objects representing images to be displayed.
  /// [initialIndex] determines which image should be shown first.
  const DetailScreenPageView({
    super.key,
    required this.tags,
    required this.initialIndex,
  });

  final List<UrlImage> tags;
  final int initialIndex;

  @override
  State<DetailScreenPageView> createState() => _DetailScreenPageView();
}

class _DetailScreenPageView extends State<DetailScreenPageView>
    with TickerProviderStateMixin {
  late final PageController _pageViewController;
  late final TabController _tabController;
  late final AnimationController _animationController;
  late final Animation<Offset> _offsetAnimation;
  late final List<GlobalKey<_CustomInteractiveViewerState>> _viewerKeys;
  @override
  void initState() {
    super.initState();
    _viewerKeys = List.generate(
        widget.tags.length, (_) => GlobalKey<_CustomInteractiveViewerState>());
    _pageViewController = PageController(initialPage: widget.initialIndex);
    _tabController = TabController(
        initialIndex: widget.initialIndex,
        length: widget.tags.length,
        vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: offset,
      end: const Offset(50, 50),
    ).animate(_animationController);
  }

  Offset offset = Offset.zero;
  double backgroundOpacity = 1.0;

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final double dragThreshold = 2.0;

  void handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      offset += details.delta;
      double dragAmount = offset.dy.abs() / 150;
      backgroundOpacity = (1.0 - dragAmount).clamp(0, 1);
    });
  }

  void handlePanEnd(DragEndDetails details) async {
    if (offset.dy.abs() > 20 ||
        details.primaryVelocity!.abs() > dragThreshold) {
      final currentIndex = _tabController.index;
      final viewerKey = _viewerKeys[currentIndex];
      final viewerState = viewerKey.currentState;

      if (viewerState != null) {
        await viewerState.resetZoom(duration: Duration(milliseconds: 100));
      }
      Navigator.of(context).pop(_tabController.index);
      return;
    }

    setState(() {
      offset = Offset.zero;
      backgroundOpacity = 1.0;
    });
  }

  /// Needs refactor, since this callback assumes that the image is a square with width and height being the same(MediaQuery.sizeOf(context).width))
  void handleTapUp(TapUpDetails details) async {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double imageTop = (screenHeight - screenWidth) / 2;
    final double imageBottom = (imageTop + screenWidth);

    final tappedY = details.globalPosition.dy;

    if (tappedY < imageTop || tappedY > imageBottom) {
      final currentIndex = _tabController.index;
      final viewerKey = _viewerKeys[currentIndex];
      final viewerState = viewerKey.currentState;

      if (viewerState != null) {
        await viewerState.resetZoom(duration: Duration(milliseconds: 100));
      }
      Navigator.of(context).pop(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Creates a list of widgets for the page view, each wrapped in a Hero animation.

    final heroWidgets = List.generate(widget.tags.length, (index) {
      final tag = widget.tags[index].value;
      return Hero(
        tag: tag,
        transitionOnUserGestures: true,
        child: Center(
          child: CustomInteractiveViewer(
            key: _viewerKeys[index],
            tag: tag,
            onPanEnd: handlePanEnd,
            onPanUpdate: handlePanUpdate,
          ),
        ),
      );
    });

    return GestureDetector(
      onTapUp: handleTapUp,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Opacity(
              opacity: backgroundOpacity,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10 * backgroundOpacity,
                    sigmaY: 10 * backgroundOpacity),
                child: Container(
                  color: Colors.black.withAlpha(
                    (125 * backgroundOpacity).toInt(),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).width,
                child: Stack(
                  alignment: Alignment.bottomCenter,

                  /// PageView for swiping between images
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: offset,
                        child: PageView(
                            controller: _pageViewController,
                            onPageChanged: _handlePageViewChanged,
                            children: heroWidgets),
                      ),
                    ),

                    /// Page Indicator to show progress in the gallery
                    Opacity(
                      opacity: (backgroundOpacity),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: PageIndicator(
                          tabController: _tabController,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Updates the tab indicator when the page view is swiped.
  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
  }
}

class CustomInteractiveViewer extends StatefulWidget {
  /// By default, InteractiveViewer clips its child using Clip.hardEdge.
  /// To prevent this behavior, consider setting clipBehavior to Clip.none.
  /// When clipBehavior is Clip.none, InteractiveViewer may draw outside of its original area of the screen,
  /// such as when a child is zoomed in and increases in size.
  /// However, it will not receive gestures outside of its original area.
  /// To prevent dead areas where InteractiveViewer does not receive gestures, don't set clipBehavior
  /// or be sure that the InteractiveViewer widget is the size of the area that should be interactive.

  const CustomInteractiveViewer(
      {super.key, required this.tag, this.onPanUpdate, this.onPanEnd});
  final String tag;
  final void Function(DragUpdateDetails)? onPanUpdate;
  final void Function(DragEndDetails)? onPanEnd;

  @override
  State<StatefulWidget> createState() => _CustomInteractiveViewerState();
}

class _CustomInteractiveViewerState extends State<CustomInteractiveViewer>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late final AnimationController _animationController;
  late Animation<Matrix4> _animation;
  TapDownDetails _doubleTapDetails = TapDownDetails();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _transformationController.value = _animation.value;
      });
  }

  void handleDoubleTap() {
    Matrix4 endMatrix;
    Offset position = _doubleTapDetails.localPosition;

    if (_transformationController.value != Matrix4.identity()) {
      endMatrix = Matrix4.identity();
    } else {
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController),
    );
    _animationController.forward(from: 0);
  }

  Future<void> resetZoom(
      {Duration duration = const Duration(milliseconds: 300)}) async {
    if (_transformationController.value != Matrix4.identity()) {
      Matrix4 endMatrix = Matrix4.identity();
      _animationController.duration = duration;
      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: endMatrix,
      ).animate(
        CurveTween(curve: Curves.easeOut).animate(_animationController),
      );

      await _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 1.0,
      maxScale: 3.0,
      clipBehavior: Clip.none,
      child: GestureDetector(
        onDoubleTapDown: (details) => _doubleTapDetails = details,
        onDoubleTap: handleDoubleTap,
        onPanUpdate: widget.onPanUpdate,
        onPanEnd: widget.onPanEnd,
        child: URLImageTile(
            url: widget.tag,
            onDelete: () {},
            isEditMode: false,
            maxWidth: MediaQuery.sizeOf(context).width,
            minWidth: MediaQuery.sizeOf(context).width,
            maxHeight: MediaQuery.sizeOf(context).height,
            minHeight: MediaQuery.sizeOf(context).height,
            borderRadius: BorderRadius.circular(10),
            boxFit: BoxFit.cover),
      ),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
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
