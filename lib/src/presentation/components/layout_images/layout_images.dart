import 'package:flutter/material.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/image_type.dart';
import 'image_tile_builder.dart';

/// {@category Presentation}
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
    this.isImagesHidden = true,
    this.showHiddenImages,
  });

  /// Optional. Whether  gallery is in edit mode, which shows delete buttons. Default is false.
  final bool isEditMode;

  /// Optional. Callback function that is triggered when an image is deleted.
  final void Function(int id)? onDelete;

  /// Required. A list of images to display. Supports both [UrlImage] and [XFileImage] types.
  final List<ImageType> images;

  /// Optional. Callback function that is triggered when an image is tapped.
  final void Function()? onTapCallback;

  final bool isImagesHidden;
  final void Function()? showHiddenImages;

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
          return SingleImageBuilder(
            width: maxWidth,
            height: maxHeight,
            images: images,
            onDelete: onDelete,
            onTapCallback: onTapCallback,
            isEditMode: isEditMode,
          );
        case 2:
          return DoubleImageBuilder(
            width: maxWidth,
            height: maxHeight,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
          );
        case 3:
          return TripleImageBuilder(
            width: maxWidth,
            height: maxHeight,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
          );
        case 4:
          return QuadrupleImageBuilder(
            width: maxWidth,
            height: maxHeight,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
          );
        case 5:
          return QuintupleImageBuilder(
            width: maxWidth,
            height: maxHeight,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
          );
        default:
          return MultipleImageBuilder(
            width: maxWidth,
            height: maxHeight,
            images: images,
            onDelete: onDelete,
            isEditMode: isEditMode,
            onTapCallback: onTapCallback,
            isImagesHidden: isImagesHidden,
            showHiddenImages: showHiddenImages,
          );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
