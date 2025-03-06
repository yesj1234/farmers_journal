import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Displays network images with caching support via CachedNetworkImage. Shows delete button in edit mode.
class URLImageTile extends StatelessWidget {
  const URLImageTile({
    super.key,
    required this.url,
    required this.onDelete,
    required this.isEditMode,
    required this.maxWidth,
    required this.maxHeight,
    required this.minWidth,
    required this.minHeight,
    this.borderRadius,
    this.boxFit,
  });

  final String url;
  final void Function()? onDelete;
  final bool isEditMode;
  final double maxWidth;
  final double maxHeight;
  final double minWidth;
  final double minHeight;
  final BorderRadius? borderRadius;
  final BoxFit? boxFit;

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
        child: CachedNetworkImage(
          imageUrl: url,
          width: maxWidth,
          height: maxHeight,
          fit: boxFit ?? BoxFit.cover,
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
    ]);
  }
}

/// Displays local images selected from device storage. Shows delete button in edit mode.
class XFileImageTile extends StatelessWidget {
  const XFileImageTile({
    super.key,
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
