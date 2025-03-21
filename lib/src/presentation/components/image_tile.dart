import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// {@category Presentation}
/// {@subCategory Component}
///
/// A widget that displays an image from a network URL with caching support.
///
/// The `URLImageTile` widgetuses the `CachedNetworkImage` package to
/// efficiently load and cache images from the network. It also provides
/// an optional delete button that is visible when the widget is in edit mode.
///
///
/// ## Features
///
/// *   **Caching:** Uses `CachedNetworkImage` for efficient image loading and caching.
/// *   **Error Handling:** Displays a broken image icon if the image fails to load.
/// *   **Edit Mode:** Shows a delete button when `isEditMode` is true.
/// *   **Customizable:** Allows customization of size, border radius, and `BoxFit`.
///
/// ## Parameters
///
/// *   **`url`** (required): The URL of the image to display.
/// *   **`onDelete`** (required): A callback function that is called when the delete button is pressed.
/// *   **`isEditMode`** (required): A boolean indicating whether the widget is in edit mode.
/// *   **`maxWidth`** (required): The maximum width of the image.
/// *   **`maxHeight`** (required): The maximumheight of the image.
/// *   **`minWidth`** (required): The minimum width of the image.
/// *   **`minHeight`** (required): The minimum height of the image.
/// *   **`borderRadius`** (optional): The border radius of the image. Defaults to a rounded top corners.
/// *   **`boxFit`** (optional): How the image should be inscribed into the space. Defaults to `BoxFit.cover`.
///
/// ## Dependencies
///
/// *   `cached_network_image`: For caching and displaying network images.
class URLImageTile extends StatelessWidget {
  /// Creates a [URLImageTile] widget.
  ///
  /// All parameters are required except [borderRadius] and [boxFit].
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

  /// The URL of the image to display.
  final String url;

  /// A callback function that is called when the delete button is pressed.
  final void Function()? onDelete;

  /// A boolean indicating whether the widget is in edit mode.
  final bool isEditMode;

  /// The maximum width of the image.
  final double maxWidth;

  /// The maximum height of the image.
  final double maxHeight;

  /// The minimum width of the image.
  final double minWidth;

  /// The minimum height of the image.
  final double minHeight;

  /// The border radius of the image.
  final BorderRadius? borderRadius;

  /// How the image should be inscribed into the space.
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

/// {@category Presentation}
/// {@subCategory Component}
///
/// A widget that displays a local image selected from device storage.
///
/// The `XFileImageTile` widget displays an image selected from the device's
/// storage using the `image_picker` package. It also provides an optional
/// delete button that is visible when the widget is in edit mode.
/// ## Features
///
/// *   **Local Image Display:** Displays images selected from device storage.
/// *   **Error Handling:** Displays a broken image icon if the image fails to load.
/// *   **Edit Mode:** Shows a delete button when `isEditMode` is true.
/// *   **Customizable:** Allows customization of size and border radius.
///
/// ## Parameters
///
/// *   **`id`** (required): An identifier for the image.
/// *   **`image`** (required): The `XFile` object representing the image.
/// *   **`isEditMode`** (required): A boolean indicating whether the widget is in edit mode.
/// *   **`onDelete`** (required): A callback function that is called when the delete button is pressed.
/// *   **`width`** (optional): The width of the image.
/// *   **`height`** (optional): The height of the image.
/// *   **`borderRadius`** (optional): The border radius of the image. Defaults to a circular radius of 10.
///
/// ## Dependencies
///
/// *   `image_picker`: For selecting images from device storage.
/// *   `flutter/material.dart`: For UI elements and theming.
class XFileImageTile extends StatelessWidget {
  /// Creates a [XFileImageTile] widget.
  ///
  /// All parameters are required except [width], [height] and [borderRadius].
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

  /// An identifier for the image.
  final int id;

  /// The `XFile` object representing the image.
  final XFile image;

  /// A boolean indicating whether the widget is in edit mode.
  final bool isEditMode;

  /// A callback function that is called when the delete button is pressed.
  final void Function()? onDelete;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The border radius of the image.
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
