import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';
import 'package:farmers_journal/presentation/components/layout_images_detail_screen.dart';

class CustomImageWidgetLayout extends StatelessWidget {
  const CustomImageWidgetLayout({
    super.key,
    required this.images,
    this.isEditMode = false,
    this.onDelete,
  });
  final bool isEditMode;
  final void Function(int id)? onDelete;
  final List<ImageType> images;

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

  Widget _buildSingleImage(
    double width,
    double height,
    context,
  ) {
    return _buildImageTile(0, width, height, 1, context);
  }

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

  /// Depending on the index of the image and size of the total, URLImageTile will get different border radius.
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LayoutImagesDetailScreen(
                  tags: images as List<UrlImage>,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Hero(
            tag: value,
            child: _URLImageTile(
              id: index,
              url: value,
              onDelete: () => onDelete?.call(index),
              width: width,
              height: height,
              isEditMode: isEditMode,
              borderRadius: borderRadius,
            ),
          ),
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

class ImageWidgetLayout extends StatelessWidget {
  const ImageWidgetLayout({
    super.key,
    required this.images,
    this.isEditMode = false,
    this.onDelete,
  });
  final bool isEditMode;
  final void Function(int id)? onDelete;
  final List<ImageType> images;

  int _getCrossAxisCount(int imageCount) {
    if (imageCount == 1) return 1;
    if (imageCount <= 4) return 2;
    if (imageCount <= 9) return 3;
    return 4;
  }

  int _getRowCount(int imageCount, int crossAxisCount) {
    return (imageCount / crossAxisCount).ceil();
  }

  @override
  Widget build(BuildContext context) {
    if (images.isNotEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = _getCrossAxisCount(images.length);

          double totalHorizontalPadding = 8.0 * (crossAxisCount + 1);
          double availableWidth = constraints.maxWidth - totalHorizontalPadding;
          double tileWidth = availableWidth / crossAxisCount;

          double totalVerticalPadding =
              8.0 * ((_getRowCount(images.length, crossAxisCount)) + 1);
          double availableHeight = constraints.maxHeight - totalVerticalPadding;
          double tileHeight =
              availableHeight / _getRowCount(images.length, crossAxisCount);

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: tileWidth / tileHeight, // Dynamic aspect ratio
            ),
            itemCount: images.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              switch (images[index]) {
                case UrlImage(:final value):
                  return _URLImageTile(
                    id: index,
                    url: value,
                    onDelete: () {
                      onDelete!(index);
                    },
                    width: tileWidth,
                    height: tileHeight,
                    isEditMode: isEditMode,
                  );

                case XFileImage(:final value):
                  return _XFileImageTile(
                    id: index,
                    image: value,
                    onDelete: () {
                      onDelete!(index);
                    },
                    width: tileWidth,
                    height: tileHeight,
                    isEditMode: isEditMode,
                  );
              }
            },
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _URLImageTile extends StatelessWidget {
  const _URLImageTile({
    required this.id,
    required this.url,
    required this.onDelete,
    required this.isEditMode,
    this.width,
    this.height,
    this.borderRadius,
  });
  final int id;
  final String url;
  final void Function()? onDelete;
  final bool isEditMode;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: borderRadius ??
            const BorderRadius.only(
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
        child: SizedBox(
          width: width,
          height: height,
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
    return Stack(
      children: [
        ClipRRect(
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
      ],
    );
  }
}
