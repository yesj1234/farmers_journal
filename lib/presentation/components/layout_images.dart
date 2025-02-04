import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';
import 'package:farmers_journal/presentation/components/layout_images_detail_screen.dart';

class HeroImageWidgetLayout extends StatelessWidget {
  const HeroImageWidgetLayout({
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
            padding: const EdgeInsets.all(2.0),
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
                        onDelete: () {
                          onDelete!(index);
                        },
                        width: tileWidth,
                        height: tileHeight,
                        isEditMode: isEditMode,
                      ),
                    ),
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
  });
  final int id;
  final String url;
  final void Function()? onDelete;
  final bool isEditMode;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
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
          ? Align(
              alignment: Alignment.topRight,
              child: IconButton(
                alignment: Alignment.topRight,
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                iconSize: 20,
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: Colors.black,
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
  });
  final int id;
  final XFile image;
  final bool isEditMode;
  final void Function()? onDelete;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
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
            ? Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  alignment: Alignment.topRight,
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.black,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
