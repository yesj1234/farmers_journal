import 'dart:ui';

import 'package:farmers_journal/src/presentation/components/layout_images/layout_images.dart';
import 'package:flutter/material.dart';

import '../../pages/page_journal/image_type.dart';
import '../image_tile.dart';
import 'layout_images_detail_screen.dart';

/// {@category Presentation}
/// A stateless widget that builds an image tile based on the provided image type.
///
/// This widget supports different image types (`UrlImage` and `XFileImage`) and provides
/// configurable dimensions, edit mode options, and interaction callbacks.
///
/// When in edit mode, the widget allows deletion of images. Otherwise, it supports
/// tap interactions that navigate to a detail view with a hero animation.
class ImageTileBuilder extends StatelessWidget {
  /// Creates an [ImageTileBuilder] with required properties.
  const ImageTileBuilder({
    super.key,
    required this.index,
    required this.images,
    required this.total,
    required this.minWidth,
    required this.maxWidth,
    required this.minHeight,
    required this.maxHeight,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });

  /// Index of the image in the list.
  final int index;

  /// List of images to be displayed.
  final List<ImageType> images;

  /// Total number of images.
  final int total;

  /// Minimum width of the image tile.
  final double minWidth;

  /// Maximum width of the image tile.
  final double maxWidth;

  /// Minimum height of the image tile.
  final double minHeight;

  /// Maximum height of the image tile.
  final double maxHeight;

  /// Callback function triggered when an image is deleted.
  final void Function(int index)? onDelete;

  /// Indicates whether the widget is in edit mode.
  final bool? isEditMode;

  /// Callback function triggered when the image tile is tapped.
  final void Function()? onTapCallback;

  /// Whether to use the widget as the original use case, to expand to a detail page view of the images.
  final bool? doEnlarge;

  /// Opacity transition curve for hero animations.
  static const opacityCurve = Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  @override
  Widget build(BuildContext context) {
    // Calculate the border radius based on the image index and total count.
    final BorderRadius borderRadius =
        CustomImageWidgetLayout.calculateBorderRadius(total, index);

    final image = images[index];

    // Create the image tile based on the image type.
    final imageTile = switch (image) {
      UrlImage(:final value) => URLImageTile(
          url: value,
          onDelete: () => onDelete?.call(index),
          minWidth: minWidth,
          minHeight: minHeight,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          isEditMode: isEditMode ?? false,
          borderRadius: borderRadius,
        ),
      XFileImage(:final value) => XFileImageTile(
          id: index,
          image: value,
          onDelete: () => onDelete?.call(index),
          width: minWidth,
          height: minHeight,
          isEditMode: isEditMode ?? false,
          borderRadius: borderRadius,
        ),
    };

    switch (image) {
      case UrlImage(:final value):
        final child = isEditMode ?? false
            ? imageTile
            : Hero(
                tag: value,
                transitionOnUserGestures: true,
                child: imageTile,
              );

        if (doEnlarge == null || doEnlarge == true) {
          return GestureDetector(
            onTap: isEditMode ?? false
                ? null
                : () {
                    onTapCallback?.call();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        maintainState: true,
                        opaque: false,
                        transitionsBuilder: (context, animation, _, child) =>
                            Opacity(
                                opacity:
                                    opacityCurve.transform(animation.value),
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
        } else {
          return child;
        }

      case XFileImage():
        return imageTile;
    }
  }
}

class SingleImageBuilder extends StatelessWidget {
  const SingleImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.index = 0,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final int? index;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;
  final bool? doEnlarge;
  @override
  Widget build(BuildContext context) {
    return ImageTileBuilder(
      total: 1,
      index: index ?? 0,
      minHeight: height,
      maxHeight: height,
      minWidth: width,
      maxWidth: width,
      images: images,
      onDelete: onDelete,
      isEditMode: isEditMode,
      onTapCallback: onTapCallback,
      doEnlarge: doEnlarge,
    );
  }
}

class DoubleImageBuilder extends StatelessWidget {
  const DoubleImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;
  final bool? doEnlarge;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      children: [
        Expanded(
          child: ImageTileBuilder(
            total: 2,
            index: 0,
            maxWidth: width,
            maxHeight: height,
            minWidth: width / 2,
            minHeight: height,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
            doEnlarge: doEnlarge,
          ),
        ),
        Expanded(
          child: ImageTileBuilder(
            total: 2,
            index: 1,
            maxWidth: width,
            maxHeight: height,
            minWidth: width / 2,
            minHeight: height,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
            images: images,
            doEnlarge: doEnlarge,
          ),
        ),
      ],
    );
  }
}

class TripleImageBuilder extends StatelessWidget {
  const TripleImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;
  final bool? doEnlarge;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      children: [
        Expanded(
          child: ImageTileBuilder(
            total: 3,
            index: 0,
            maxWidth: width,
            maxHeight: height,
            minWidth: width / 2,
            minHeight: height,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
            doEnlarge: doEnlarge,
          ),
        ),
        Expanded(
          child: Column(
            spacing: 2,
            children: [
              Expanded(
                child: ImageTileBuilder(
                  total: 3,
                  index: 1,
                  maxWidth: width,
                  maxHeight: height,
                  minWidth: width / 2,
                  minHeight: height / 2,
                  images: images,
                  onDelete: onDelete,
                  isEditMode: isEditMode,
                  onTapCallback: onTapCallback,
                  doEnlarge: doEnlarge,
                ),
              ),
              Expanded(
                child: ImageTileBuilder(
                  total: 3,
                  index: 2,
                  maxWidth: width,
                  maxHeight: height,
                  minWidth: width / 2,
                  minHeight: height / 2,
                  images: images,
                  onDelete: onDelete,
                  isEditMode: isEditMode,
                  onTapCallback: onTapCallback,
                  doEnlarge: doEnlarge,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class QuadrupleImageBuilder extends StatelessWidget {
  const QuadrupleImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;
  final bool? doEnlarge;

  @override
  Widget build(BuildContext context) {
    return Row(spacing: 2, children: [
      Expanded(
        child: ImageTileBuilder(
          total: 4,
          index: 0,
          maxWidth: width,
          maxHeight: height,
          minWidth: width / 2,
          minHeight: height,
          images: images,
          onDelete: onDelete,
          isEditMode: isEditMode,
          onTapCallback: onTapCallback,
          doEnlarge: doEnlarge,
        ),
      ),
      Expanded(
        child: Column(
          spacing: 2,
          children: [
            Expanded(
              child: ImageTileBuilder(
                total: 4,
                index: 1,
                maxWidth: width,
                maxHeight: height,
                minWidth: width / 2,
                minHeight: height / 2,
                images: images,
                onDelete: onDelete,
                isEditMode: isEditMode,
                onTapCallback: onTapCallback,
                doEnlarge: doEnlarge,
              ),
            ),
            Expanded(
              child: Row(
                spacing: 2,
                children: [
                  Expanded(
                    child: ImageTileBuilder(
                      total: 4,
                      index: 2,
                      maxWidth: width,
                      maxHeight: height,
                      minWidth: width / 4,
                      minHeight: height / 4,
                      images: images,
                      onDelete: onDelete,
                      isEditMode: isEditMode,
                      onTapCallback: onTapCallback,
                      doEnlarge: doEnlarge,
                    ),
                  ),
                  Expanded(
                    child: ImageTileBuilder(
                      total: 4,
                      index: 3,
                      maxWidth: width,
                      maxHeight: height,
                      minWidth: width / 4,
                      minHeight: height / 4,
                      images: images,
                      onDelete: onDelete,
                      isEditMode: isEditMode,
                      onTapCallback: onTapCallback,
                      doEnlarge: doEnlarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class QuintupleImageBuilder extends StatelessWidget {
  const QuintupleImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;
  final bool? doEnlarge;

  @override
  Widget build(BuildContext context) {
    return Row(spacing: 2, children: [
      Expanded(
        child: ImageTileBuilder(
          total: 5,
          index: 0,
          maxWidth: width,
          maxHeight: height,
          minWidth: width / 2,
          minHeight: height,
          images: images,
          onDelete: onDelete,
          isEditMode: isEditMode,
          onTapCallback: onTapCallback,
          doEnlarge: doEnlarge,
        ),
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
                    child: ImageTileBuilder(
                      total: 5,
                      index: 1,
                      maxWidth: width,
                      maxHeight: height,
                      minWidth: width / 2,
                      minHeight: height / 2,
                      images: images,
                      onDelete: onDelete,
                      isEditMode: isEditMode,
                      onTapCallback: onTapCallback,
                      doEnlarge: doEnlarge,
                    ),
                  ),
                  Expanded(
                    child: ImageTileBuilder(
                      total: 5,
                      index: 2,
                      maxWidth: width,
                      maxHeight: height,
                      minWidth: width / 2,
                      minHeight: height / 2,
                      images: images,
                      onDelete: onDelete,
                      isEditMode: isEditMode,
                      onTapCallback: onTapCallback,
                      doEnlarge: doEnlarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 2,
                children: [
                  Expanded(
                    child: ImageTileBuilder(
                      total: 5,
                      index: 3,
                      maxWidth: width,
                      maxHeight: height,
                      minWidth: width / 4,
                      minHeight: height / 2,
                      images: images,
                      onDelete: onDelete,
                      isEditMode: isEditMode,
                      onTapCallback: onTapCallback,
                      doEnlarge: doEnlarge,
                    ),
                  ),
                  Expanded(
                    child: ImageTileBuilder(
                      total: 5,
                      index: 4,
                      maxWidth: width,
                      maxHeight: height,
                      minWidth: width / 4,
                      minHeight: height / 2,
                      images: images,
                      onDelete: onDelete,
                      isEditMode: isEditMode,
                      onTapCallback: onTapCallback,
                      doEnlarge: doEnlarge,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }
}

/// A stateful widget that manages the display of multiple images.
///
/// This widget allows displaying a collection of images with configurable
/// width, height, and interaction options. It supports editing mode,
/// deletion, tap callbacks, and the ability to hide or show images.
class MultipleImageBuilder extends StatefulWidget {
  /// Creates a [MultipleImageBuilder] with required dimensions and image list.
  const MultipleImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.isImagesHidden = true,
    this.showHiddenImages,
    this.doEnlarge,
  });

  /// The width of the image display area.
  final double width;

  /// The height of the image display area.
  final double height;

  /// A list of images to be displayed.
  final List<ImageType> images;

  /// Callback function triggered when an image is deleted.
  final void Function(int index)? onDelete;

  /// Indicates whether the widget is in edit mode.
  final bool? isEditMode;

  /// Callback function triggered when an image is tapped.
  final void Function()? onTapCallback;

  /// Determines whether images should be initially hidden.
  final bool isImagesHidden;

  /// Callback function to show hidden images.
  final void Function()? showHiddenImages;
  final bool? doEnlarge;

  @override
  State<MultipleImageBuilder> createState() => _MultipleImageBuilderState();
}

/// The state class for [MultipleImageBuilder], responsible for rendering
/// multiple images in a structured layout.
///
/// This stateful widget arranges images in a stacked column-row structure,
/// with support for blurring hidden images, toggling visibility, and handling
/// user interactions like tapping and deleting images.
class _MultipleImageBuilderState extends State<MultipleImageBuilder> {
  /// Determines whether images should be blurred based on the hidden state.
  ImageFilter get isBlurred => widget.isImagesHidden
      ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
      : ImageFilter.blur(sigmaX: 0, sigmaY: 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          spacing: 2,
          children: [
            Expanded(
              child: Row(
                spacing: 2,
                children: [
                  Expanded(
                      child: ImageTileBuilder(
                    total: 5,
                    index: 0,
                    minWidth: widget.width / 2,
                    maxWidth: widget.width,
                    minHeight: widget.height,
                    maxHeight: widget.height,
                    images: widget.images,
                    onDelete: widget.onDelete,
                    isEditMode: widget.isEditMode,
                    onTapCallback: widget.onTapCallback,
                    doEnlarge: widget.doEnlarge,
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
                                child: ImageTileBuilder(
                                  total: 5,
                                  index: 1,
                                  minWidth: widget.width / 2,
                                  maxWidth: widget.width,
                                  minHeight: widget.height / 2,
                                  maxHeight: widget.height,
                                  images: widget.images,
                                  onDelete: widget.onDelete,
                                  isEditMode: widget.isEditMode,
                                  onTapCallback: widget.onTapCallback,
                                  doEnlarge: widget.doEnlarge,
                                ),
                              ),
                              Expanded(
                                child: ImageTileBuilder(
                                  total: 5,
                                  index: 2,
                                  minWidth: widget.width / 2,
                                  maxWidth: widget.width,
                                  minHeight: widget.height / 2,
                                  maxHeight: widget.height,
                                  images: widget.images,
                                  onDelete: widget.onDelete,
                                  isEditMode: widget.isEditMode,
                                  onTapCallback: widget.onTapCallback,
                                  doEnlarge: widget.doEnlarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            spacing: 2,
                            children: [
                              Expanded(
                                child: ImageTileBuilder(
                                  total: 5,
                                  index: 3,
                                  minWidth: widget.width / 4,
                                  maxWidth: widget.width,
                                  minHeight: widget.height / 2,
                                  maxHeight: widget.height,
                                  images: widget.images,
                                  onDelete: widget.onDelete,
                                  isEditMode: widget.isEditMode,
                                  onTapCallback: widget.onTapCallback,
                                  doEnlarge: widget.doEnlarge,
                                ),
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRect(
                                      child: ImageFiltered(
                                        imageFilter: isBlurred,
                                        child: ImageTileBuilder(
                                          total: 5,
                                          index: 4,
                                          maxWidth: widget.width,
                                          maxHeight: widget.height,
                                          minWidth: widget.width / 4,
                                          minHeight: widget.height / 2,
                                          images: widget.images,
                                          onDelete: widget.onDelete,
                                          isEditMode: widget.isEditMode,
                                          onTapCallback: widget.onTapCallback,
                                          doEnlarge: widget.doEnlarge,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.isImagesHidden,
                                      child: GestureDetector(
                                        onTap: widget.showHiddenImages,
                                        child: Container(
                                          color: Colors.black54,
                                          child: Center(
                                            child: Text(
                                              "+${widget.images.length - 4}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
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
            ),
            Visibility(
              visible: !widget.isImagesHidden,
              child: widget.isImagesHidden
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: RemainingImageBuilder(
                        width: widget.width,
                        height: widget.height,
                        images: widget.images,
                        onDelete: widget.onDelete,
                        isEditMode: widget.isEditMode,
                        onTapCallback: widget.onTapCallback,
                        doEnlarge: widget.doEnlarge,
                      ),
                    ),
            )
          ],
        ),
      ],
    );
  }
}

class RemainingImageBuilder extends StatelessWidget {
  const RemainingImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });
  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;
  final bool? doEnlarge;
  @override
  Widget build(BuildContext context) {
    if (images.length == 6) {
      return SingleImageBuilder(
        width: width,
        height: height / 2,
        images: images,
        index: 5,
        onDelete: onDelete,
        onTapCallback: onTapCallback,
        isEditMode: isEditMode,
        doEnlarge: doEnlarge,
      );
    }
    if (images.length == 7) {
      return _DoubleRemainingImageTile(
        width: width,
        height: height,
        images: images,
        onDelete: onDelete,
        isEditMode: isEditMode,
        onTapCallback: onTapCallback,
        doEnlarge: doEnlarge,
      );
    }
    if (images.length == 8) {
      return _TripleRemainingImageTile(
        width: width,
        height: height,
        images: images,
        onDelete: onDelete,
        isEditMode: isEditMode,
        onTapCallback: onTapCallback,
        doEnlarge: doEnlarge,
      );
    }
    return const SizedBox.shrink();
  }
}

class _DoubleRemainingImageTile extends StatelessWidget {
  const _DoubleRemainingImageTile({
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;
  final bool? doEnlarge;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      children: [
        Expanded(
          child: ImageTileBuilder(
            total: 2,
            index: 5,
            maxWidth: width,
            maxHeight: height,
            minWidth: width / 2,
            minHeight: height,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
            doEnlarge: doEnlarge,
          ),
        ),
        Expanded(
          child: ImageTileBuilder(
            total: 2,
            index: 6,
            maxWidth: width,
            maxHeight: height,
            minWidth: width / 2,
            minHeight: height,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
            images: images,
            doEnlarge: doEnlarge,
          ),
        ),
      ],
    );
  }
}

class _TripleRemainingImageTile extends StatelessWidget {
  const _TripleRemainingImageTile({
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
    this.doEnlarge,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;
  final bool? doEnlarge;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      children: [
        Expanded(
          child: Column(
            spacing: 2,
            children: [
              Expanded(
                child: ImageTileBuilder(
                  total: 3,
                  index: 5,
                  maxWidth: width,
                  maxHeight: height,
                  minWidth: width / 2,
                  minHeight: height / 2,
                  images: images,
                  onDelete: onDelete,
                  isEditMode: isEditMode,
                  onTapCallback: onTapCallback,
                  doEnlarge: doEnlarge,
                ),
              ),
              Expanded(
                child: ImageTileBuilder(
                  total: 3,
                  index: 6,
                  maxWidth: width,
                  maxHeight: height,
                  minWidth: width / 2,
                  minHeight: height / 2,
                  images: images,
                  onDelete: onDelete,
                  isEditMode: isEditMode,
                  onTapCallback: onTapCallback,
                  doEnlarge: doEnlarge,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ImageTileBuilder(
            total: 3,
            index: 7,
            maxWidth: width,
            maxHeight: height,
            minWidth: width / 2,
            minHeight: height,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
            doEnlarge: doEnlarge,
          ),
        ),
      ],
    );
  }
}
