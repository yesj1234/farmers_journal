import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';
import 'package:farmers_journal/presentation/components/layout_images_detail_screen.dart';

/// A stateless widget that creates beautiful grid-like layouts for displaying images.
///
/// The layout adapts automatically based on the number of images, creating visually appealing arrangements.
class CustomImageWidgetLayout extends StatelessWidget {
  const CustomImageWidgetLayout({
    super.key,
    required this.images,
    this.isEditMode = false,
    this.onDelete,
  });

  /// Optional. Whether  gallery is in edit mode, which shows delete buttons. Default is false.
  final bool isEditMode;

  /// Optional. Callback function that is triggered when an image is deleted.
  final void Function(int id)? onDelete;

  /// Required. A list of images to display. Supports both [UrlImage] and [XFileImage] types.
  final List<ImageType> images;

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
        width: width, index: 0, height: height, total: 1, context: context);
  }

  /// Side-by-side layout
  Widget _buildTwoImages(double width, double height, context) {
    return Row(
      spacing: 2,
      children: [
        Expanded(
          child: _buildImageTile(
              index: 0,
              width: width / 2,
              height: height,
              total: 2,
              context: context),
        ),
        Expanded(
          child: _buildImageTile(
              index: 1,
              width: width / 2,
              height: height,
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
              width: width / 2,
              height: height,
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
                    width: width / 2,
                    height: height / 2,
                    total: 3,
                    context: context),
              ),
              Expanded(
                child: _buildImageTile(
                    index: 2,
                    width: width / 2,
                    height: height / 2,
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
            width: width / 2,
            height: height,
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
                  width: width / 2,
                  height: height / 2,
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
                        width: width / 4,
                        height: height / 4,
                        total: 4,
                        context: context),
                  ),
                  Expanded(
                    child: _buildImageTile(
                        index: 3,
                        width: width / 4,
                        height: height / 4,
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
            width: width / 2,
            height: height,
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
                        width: width / 2,
                        height: height / 2,
                        total: 5,
                        context: context),
                  ),
                  Expanded(
                    child: _buildImageTile(
                        index: 2,
                        width: width / 2,
                        height: height / 2,
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
                        width: width / 4,
                        height: height / 2,
                        total: 5,
                        context: context),
                  ),
                  Expanded(
                    child: _buildImageTile(
                        index: 4,
                        width: width / 4,
                        height: height / 2,
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
              width: width / 2,
              height: height,
              total: 5,
              context: context,
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
                              width: width / 2,
                              height: height / 2,
                              total: 5,
                              context: context),
                        ),
                        Expanded(
                          child: _buildImageTile(
                              index: 2,
                              width: width / 2,
                              height: height / 2,
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
                              width: width / 4,
                              height: height / 2,
                              total: 5,
                              context: context),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              _buildImageTile(
                                  index: 4,
                                  total: 5,
                                  context: context,
                                  width: width / 4,
                                  height: height / 2),
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

  /// Builds an image tile based on the provided parameters.
  ///
  /// This function determines the type of image (either `UrlImage` or `XFileImage`)
  /// and returns the appropriate widget for display. If the image is a `UrlImage`,
  /// it applies a `Hero` animation and allows navigation to a detailed view when tapped.
  ///
  /// - [index]: The index of the image in the list.
  /// - [minWidth]: The minimum width of the image tile.
  /// - [maxWidth]: The maximum width of the image tile.
  /// - [minHeight]: The minimum height of the image tile.
  /// - [maxHeight]: The maximum height of the image tile.
  /// - [total]: The total number of images.
  /// - [context]: The BuildContext used for navigation.
  ///
  /// Returns a `Widget` representing the image tile.
  Widget _buildImageTile(
      {required int index,
      required double width,
      required double height,
      required int total,
      context}) {
    final image = images[index];
    BorderRadius? borderRadius =
        CustomImageWidgetLayout.calculateBorderRadius(total, index);

    /// Determines the correct widget based on the image type.
    final imageTile = switch (image) {
      UrlImage(:final value) => URLImageTile(
          url: value,
          onDelete: () => onDelete?.call(index),
          width: width,
          height: height,
          isEditMode: isEditMode,
          borderRadius: borderRadius,
          boxFit: BoxFit.fitWidth,
        ),
      XFileImage(:final value) => _XFileImageTile(
          id: index,
          image: value,
          onDelete: () => onDelete?.call(index),
          width: width,
          height: height,
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
                createRectTween: (Rect? begin, Rect? end) {
                  return MaterialRectArcTween(begin: begin, end: end);
                },
                transitionOnUserGestures: true,
                child: imageTile,
              );

        /// Wraps the image tile in a GestureDetector to handle tap interactions.
        return GestureDetector(
          onTap: isEditMode
              ? null
              : () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 2),
                      reverseTransitionDuration: const Duration(seconds: 2),
                      maintainState: true,
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
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

/// Displays network images with caching support via CachedNetworkImage. Shows delete button in edit mode.
class URLImageTile extends StatelessWidget {
  const URLImageTile({
    super.key,
    required this.url,
    required this.onDelete,
    required this.isEditMode,
    required this.width,
    required this.height,
    this.borderRadius,
    this.boxFit = BoxFit.cover,
  });

  final String url;
  final void Function()? onDelete;
  final bool isEditMode;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(children: [
        ClipRRect(
          borderRadius: borderRadius ??
              const BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: boxFit,
            errorWidget: (context, url, error) => const Icon(
              Icons.broken_image,
              size: 50,
            ),
          ),
        ),
        isEditMode
            ? Positioned(
                right: 1,
                child: IconButton(
                  alignment: Alignment.topRight,
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.white,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ]),
    );
  }
}

/// Displays local images selected from device storage. Shows delete button in edit mode.
class _XFileImageTile extends StatelessWidget {
  const _XFileImageTile({
    required this.id,
    required this.image,
    required this.isEditMode,
    required this.onDelete,
    this.width,
    this.height,
    this.borderRadius,
  });
  final int id;
  final XFile image;
  final bool isEditMode;
  final void Function()? onDelete;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    final imageRect = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.file(
          File(image.path),
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.broken_image, size: 50));
          },
        ),
      ),
    );
    final removeImageButton = Positioned(
      right: 1,
      child: IconButton(
        alignment: Alignment.topRight,
        onPressed: onDelete,
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: const Icon(
          Icons.cancel_rounded,
          color: Colors.white,
        ),
      ),
    );
    return isEditMode
        ? Stack(children: [
            imageRect,
            removeImageButton,
          ])
        : imageRect;
  }
}
