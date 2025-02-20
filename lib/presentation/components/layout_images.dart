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

  RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  static const opacityCurve = Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  @override
  Widget build(BuildContext context) {
    if (images.isNotEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          double maxHeight = constraints.maxHeight;

          Widget buildLayout() {
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
          }

          return buildLayout();
        },
      );
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
    return _buildImageTile(0, width, height, 1, context);
  }

  /// Side-by-side layout
  Widget _buildTwoImages(double width, double height, context) {
    return Row(
      spacing: 2,
      children: [
        Expanded(
          child: _buildImageTile(0, width / 2, height, 2, context),
        ),
        Expanded(
          child: _buildImageTile(1, width / 2, height, 2, context),
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
          child: _buildImageTile(0, width / 2, height, 3, context),
        ),
        Column(
          spacing: 2,
          children: [
            Expanded(
              child: _buildImageTile(1, width / 2, height / 2, 3, context),
            ),
            Expanded(
              child: _buildImageTile(2, width / 2, height / 2, 3, context),
            )
          ],
        )
      ],
    );
  }

  /// One large image, one medium image, and two smaller images
  Widget _buildFourImages(double width, double height, context) {
    return Row(spacing: 2, children: [
      Expanded(
        child: _buildImageTile(0, width / 2, height, 4, context),
      ),
      Expanded(
        child: Column(
          spacing: 2,
          children: [
            Expanded(
              child: _buildImageTile(1, width / 2, height / 2, 4, context),
            ),
            Row(spacing: 2, children: [
              Expanded(
                child: _buildImageTile(2, width / 4, height / 2, 4, context),
              ),
              Expanded(
                child: _buildImageTile(3, width / 4, height / 2, 4, context),
              ),
            ]),
          ],
        ),
      ),
    ]);
  }

  /// One large image, two medium images, and two smaller images.
  Widget _buildFiveImages(double width, double height, context) {
    return Row(spacing: 2, children: [
      Expanded(
        child: _buildImageTile(0, width / 2, height, 5, context),
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
                    child:
                        _buildImageTile(1, width / 2, height / 2, 5, context),
                  ),
                  Expanded(
                    child:
                        _buildImageTile(2, width / 2, height / 2, 5, context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(spacing: 2, children: [
                Expanded(
                  child: _buildImageTile(3, width / 4, height / 2, 5, context),
                ),
                Expanded(
                  child: _buildImageTile(4, width / 4, height / 2, 5, context),
                ),
              ]),
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
              child: _buildImageTile(0, width / 2, height, 5, context),
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
                              1, width / 2, height / 2, 5, context),
                        ),
                        Expanded(
                          child: _buildImageTile(
                              2, width / 2, height / 2, 5, context),
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
                              3, width / 4, height / 2, 5, context),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              _buildImageTile(
                                  4, width / 4, height / 2, 5, context),
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

  /// Depending on the index of the image and total count of [images], URLImageTile will get different border radius.
  Widget _buildImageTile(
      int index, double width, double height, int total, context) {
    final image = images[index];
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

    switch (image) {
      case UrlImage(:final value):
        final child = isEditMode
            ? _URLImageTile(
                id: index,
                url: value,
                onDelete: () => onDelete?.call(index),
                width: width,
                height: height,
                isEditMode: isEditMode,
                borderRadius: borderRadius,
              )
            : Hero(
                tag: value,
                createRectTween: _createRectTween,
                child: _URLImageTile(
                  id: index,
                  url: value,
                  onDelete: () => onDelete?.call(index),
                  width: width,
                  height: height,
                  isEditMode: isEditMode,
                  borderRadius: borderRadius,
                ),
              );
        return GestureDetector(
          onTap: isEditMode
              ? null
              : () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 1),
                      pageBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                      ) =>
                          AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity:
                                      opacityCurve.transform(animation.value),
                                  child: LayoutImagesDetailScreen(
                                    tags: images as List<UrlImage>,
                                    initialIndex: index,
                                  ),
                                );
                              }),
                    ),
                  );
                },
          child: child,
        );
      case XFileImage(:final value):
        return _XFileImageTile(
          id: index,
          image: value,
          onDelete: () => onDelete?.call(index),
          width: width,
          height: height,
          isEditMode: isEditMode,
          borderRadius: borderRadius,
        );
    }
  }
}

/// Displays network images with caching support via CachedNetworkImage. Shows delete button in edit mode.
class _URLImageTile extends StatelessWidget {
  const _URLImageTile({
    required this.id,
    required this.url,
    required this.onDelete,
    required this.isEditMode,
    this.width,
    this.height,
    this.borderRadius,
    this.scaleEffect,
  });
  final int id;
  final String url;
  final void Function()? onDelete;
  final bool isEditMode;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double? scaleEffect;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: borderRadius ??
              const BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
          child: CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Icon(
              Icons.broken_image,
              size: 50,
            ),
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
    ]);
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
