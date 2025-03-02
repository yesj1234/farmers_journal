import 'package:farmers_journal/presentation/components/image_tile.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';
import 'package:farmers_journal/presentation/components/layout_images_detail_screen.dart';

/// A stateless widget that creates beautiful grid-like layouts for displaying images.
///
/// The layout adapts automatically based on the number of images, creating visually appealing arrangements.
class CustomImageWidgetLayout extends StatelessWidget {
  /// Creates [CustomImageWidgetLayout] widget.
  const CustomImageWidgetLayout({
    super.key,
    required this.images,
    this.isEditMode = false,
    this.onDelete,
    this.onTapCallback,
  });

  /// Optional. Whether  gallery is in edit mode, which shows delete buttons. Default is false.
  final bool isEditMode;

  /// Optional. Callback function that is triggered when an image is deleted.
  final void Function(int id)? onDelete;

  /// Required. A list of images to display. Supports both [UrlImage] and [XFileImage] types.
  final List<ImageType> images;

  /// Optional. Callback function that is triggered when an image is tapped.
  final void Function()? onTapCallback;

  static const opacityCurve = Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  /// Depending on the index of the image and total count of [images], URLImageTile will get different border radius.
  static BorderRadius calculateBorderRadius(int total, int index) {
    BorderRadius? borderRadius;
    if (index == 0) {
      if (total == 1) {
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        );
      } else {
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
          topLeft: Radius.circular(10),
          topRight: Radius.zero,
        );
      }
    } else if (index == 1) {
      if (total >= 2 && total <= 4) {
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
          topLeft: Radius.zero,
          topRight: Radius.circular(10),
        );
      } else {
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
          topLeft: Radius.zero,
          topRight: Radius.zero,
        );
      }
    } else if (index == 2) {
      if (total >= 5) {
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
          topLeft: Radius.zero,
          topRight: Radius.circular(10),
        );
      } else {
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
          topLeft: Radius.zero,
          topRight: Radius.zero,
        );
      }
    } else {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
        topLeft: Radius.zero,
        topRight: Radius.zero,
      );
    }
    return borderRadius;
  }

  @override
  Widget build(BuildContext context) {
    if (images.isNotEmpty) {
      final maxWidth = MediaQuery.sizeOf(context).width;
      final maxHeight = MediaQuery.sizeOf(context).height;

      switch (images.length) {
        case 1:
          return _buildSingleImage(maxWidth, maxHeight, context);
        case 2:
          return _buildTwoImages(
            maxWidth,
            maxHeight,
            context,
          );
        case 3:
          return _buildThreeImages(
            maxWidth,
            maxHeight,
            context,
          );
        case 4:
          return _buildFourImages(
            maxWidth,
            maxHeight,
            context,
          );
        case 5:
          return _buildFiveImages(
            maxWidth,
            maxHeight,
            context,
          );
        default:
          return _buildMoreThanSixImages(
            maxWidth,
            maxHeight,
            context,
          );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Full-width display.
  Widget _buildSingleImage(
    double width,
    double height,
    context,
  ) {
    return _buildImageTile(
        minWidth: width,
        maxWidth: width,
        maxHeight: height,
        index: 0,
        minHeight: height,
        total: 1,
        context: context);
  }

  /// Side-by-side layout
  Widget _buildTwoImages(double width, double height, context) {
    return Row(
      spacing: 2,
      children: [
        Expanded(
          child: _buildImageTile(
              index: 0,
              maxWidth: width,
              maxHeight: height,
              minWidth: width / 2,
              minHeight: height,
              total: 2,
              context: context),
        ),
        Expanded(
          child: _buildImageTile(
              index: 1,
              maxWidth: width,
              maxHeight: height,
              minWidth: width / 2,
              minHeight: height,
              total: 2,
              context: context),
        ),
      ],
    );
  }

  /// One large image with two smaller images stacked
  Widget _buildThreeImages(double width, double height, context) {
    return Row(
      spacing: 2,
      children: [
        Expanded(
          child: _buildImageTile(
              index: 0,
              maxWidth: width,
              maxHeight: height,
              minWidth: width / 2,
              minHeight: height,
              total: 3,
              context: context),
        ),
        Expanded(
          child: Column(
            spacing: 2,
            children: [
              Expanded(
                child: _buildImageTile(
                    index: 1,
                    maxWidth: width,
                    maxHeight: height,
                    minWidth: width / 2,
                    minHeight: height / 2,
                    total: 3,
                    context: context),
              ),
              Expanded(
                child: _buildImageTile(
                    index: 2,
                    maxWidth: width,
                    maxHeight: height,
                    minWidth: width / 2,
                    minHeight: height / 2,
                    total: 3,
                    context: context),
              )
            ],
          ),
        )
      ],
    );
  }

  /// One large image, one medium image, and two smaller images
  Widget _buildFourImages(double width, double height, context) {
    return Row(spacing: 2, children: [
      Expanded(
        child: _buildImageTile(
            index: 0,
            maxWidth: width,
            maxHeight: height,
            minWidth: width / 2,
            minHeight: height,
            total: 4,
            context: context),
      ),
      Expanded(
        child: Column(
          spacing: 2,
          children: [
            Expanded(
              child: _buildImageTile(
                  index: 1,
                  maxWidth: width,
                  maxHeight: height,
                  minWidth: width / 2,
                  minHeight: height / 2,
                  total: 4,
                  context: context),
            ),
            Expanded(
              child: Row(
                spacing: 2,
                children: [
                  Expanded(
                    child: _buildImageTile(
                        index: 2,
                        maxWidth: width,
                        maxHeight: height,
                        minWidth: width / 4,
                        minHeight: height / 4,
                        total: 4,
                        context: context),
                  ),
                  Expanded(
                    child: _buildImageTile(
                        index: 3,
                        maxWidth: width,
                        maxHeight: height,
                        minWidth: width / 4,
                        minHeight: height / 4,
                        total: 4,
                        context: context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  /// One large image, two medium images, and two smaller images.
  Widget _buildFiveImages(double width, double height, context) {
    return Row(spacing: 2, children: [
      Expanded(
        child: _buildImageTile(
            index: 0,
            maxWidth: width,
            maxHeight: height,
            minWidth: width / 2,
            minHeight: height,
            total: 5,
            context: context),
      ),
      Expanded(
        child: Column(
          spacing: 2,
          children: [
            Expanded(
              child: Row(
                spacing: 2,
                children: [
                  Expanded(
                    child: _buildImageTile(
                        index: 1,
                        maxWidth: width,
                        maxHeight: height,
                        minWidth: width / 2,
                        minHeight: height / 2,
                        total: 5,
                        context: context),
                  ),
                  Expanded(
                    child: _buildImageTile(
                        index: 2,
                        maxWidth: width,
                        maxHeight: height,
                        minWidth: width / 2,
                        minHeight: height / 2,
                        total: 5,
                        context: context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 2,
                children: [
                  Expanded(
                    child: _buildImageTile(
                        index: 3,
                        maxWidth: width,
                        maxHeight: height,
                        minWidth: width / 4,
                        minHeight: height / 2,
                        total: 5,
                        context: context),
                  ),
                  Expanded(
                    child: _buildImageTile(
                        index: 4,
                        maxWidth: width,
                        maxHeight: height,
                        minWidth: width / 4,
                        minHeight: height / 2,
                        total: 5,
                        context: context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }

  /// First 5 images displayed with a "+X" overlay indicating additional images.
  Widget _buildMoreThanSixImages(double width, double height, context) {
    return Stack(
      children: [
        Row(
          spacing: 2,
          children: [
            Expanded(
                child: _buildImageTile(
              index: 0,
              minWidth: width / 2,
              maxWidth: width,
              minHeight: height,
              total: 5,
              context: context,
              maxHeight: height,
            )),
            Expanded(
              child: Column(
                spacing: 2,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 2,
                      children: [
                        Expanded(
                          child: _buildImageTile(
                              index: 1,
                              minWidth: width / 2,
                              maxWidth: width,
                              minHeight: height / 2,
                              maxHeight: height,
                              total: 5,
                              context: context),
                        ),
                        Expanded(
                          child: _buildImageTile(
                              index: 2,
                              minWidth: width / 2,
                              maxWidth: width,
                              minHeight: height / 2,
                              maxHeight: height,
                              total: 5,
                              context: context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 2,
                      children: [
                        Expanded(
                          child: _buildImageTile(
                              index: 3,
                              minWidth: width / 4,
                              maxWidth: width,
                              minHeight: height / 2,
                              maxHeight: height,
                              total: 5,
                              context: context),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              _buildImageTile(
                                  index: 4,
                                  maxWidth: width,
                                  maxHeight: height,
                                  minWidth: width / 4,
                                  minHeight: height / 2,
                                  total: 5,
                                  context: context),
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black54,
                                  child: Center(
                                    child: Text(
                                      "+${images.length - 4}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageTile(
      {required int index,
      required double minWidth,
      required double maxWidth,
      required double minHeight,
      required double maxHeight,
      required int total,
      context}) {
    final image = images[index];
    BorderRadius? borderRadius =
        CustomImageWidgetLayout.calculateBorderRadius(total, index);
    final imageTile = switch (image) {
      UrlImage(:final value) => URLImageTile(
          url: value,
          onDelete: () => onDelete?.call(index),
          minWidth: minWidth,
          minHeight: minHeight,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          isEditMode: isEditMode,
          borderRadius: borderRadius,
        ),
      XFileImage(:final value) => XFileImageTile(
          id: index,
          image: value,
          onDelete: () => onDelete?.call(index),
          width: minWidth,
          height: minHeight,
          isEditMode: isEditMode,
          borderRadius: borderRadius,
        ),
    };

    switch (image) {
      case UrlImage(:final value):
        final child = isEditMode
            ? imageTile
            : Hero(
                tag: value,
                transitionOnUserGestures: true,
                child: imageTile,
              );
        return GestureDetector(
          onTap: isEditMode
              ? null
              : () {
                  onTapCallback?.call();
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      maintainState: true,
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
                        tags: images as List<UrlImage>,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
          child: child,
        );
      case XFileImage():
        return imageTile;
    }
  }
}
