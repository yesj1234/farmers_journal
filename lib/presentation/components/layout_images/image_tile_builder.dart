import 'package:farmers_journal/presentation/components/layout_images/layout_images.dart';
import 'package:flutter/material.dart';

import '../../pages/page_journal/image_type.dart';
import '../image_tile.dart';
import 'layout_images_detail_screen.dart';

class ImageTileBuilder extends StatelessWidget {
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
  });

  final int index;
  final List<ImageType> images;
  final int total;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;

  static const opacityCurve = Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius =
        CustomImageWidgetLayout.calculateBorderRadius(total, index);

    final image = images[index];
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

class SingleImageBuilder extends StatelessWidget {
  const SingleImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;

  @override
  Widget build(BuildContext context) {
    return ImageTileBuilder(
      total: 1,
      index: 0,
      minHeight: height,
      maxHeight: height,
      minWidth: width,
      maxWidth: width,
      images: images,
      onDelete: onDelete,
      isEditMode: isEditMode,
      onTapCallback: onTapCallback,
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
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;

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
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;

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
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;

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
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;

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

class MultipleImageBuilder extends StatelessWidget {
  const MultipleImageBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.images,
    this.onDelete,
    this.isEditMode,
    this.onTapCallback,
  });

  final double width;
  final double height;
  final List<ImageType> images;
  final void Function(int index)? onDelete;
  final bool? isEditMode;
  final void Function()? onTapCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          spacing: 2,
          children: [
            Expanded(
                child: ImageTileBuilder(
              total: 5,
              index: 0,
              minWidth: width / 2,
              maxWidth: width,
              minHeight: height,
              maxHeight: height,
              images: images,
              onDelete: onDelete,
              isEditMode: isEditMode,
              onTapCallback: onTapCallback,
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
                            minWidth: width / 2,
                            maxWidth: width,
                            minHeight: height / 2,
                            maxHeight: height,
                            images: images,
                            onDelete: onDelete,
                            isEditMode: isEditMode,
                            onTapCallback: onTapCallback,
                          ),
                        ),
                        Expanded(
                          child: ImageTileBuilder(
                            total: 5,
                            index: 2,
                            minWidth: width / 2,
                            maxWidth: width,
                            minHeight: height / 2,
                            maxHeight: height,
                            images: images,
                            onDelete: onDelete,
                            isEditMode: isEditMode,
                            onTapCallback: onTapCallback,
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
                            minWidth: width / 4,
                            maxWidth: width,
                            minHeight: height / 2,
                            maxHeight: height,
                            images: images,
                            onDelete: onDelete,
                            isEditMode: isEditMode,
                            onTapCallback: onTapCallback,
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              ImageTileBuilder(
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
                              ),
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
}
