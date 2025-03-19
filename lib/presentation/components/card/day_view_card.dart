import 'dart:math' hide log;
import 'package:farmers_journal/presentation/components/handle_journal_delete.dart';
import 'package:farmers_journal/presentation/components/layout_images/layout_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';
import '../../pages/page_journal/image_type.dart';

/// {@category Presentation}
/// A card widget displaying a journal entry for a single day.
///
/// This widget shows a journal's images, title, content, and date, with optional
/// edit and delete actions. It adapts its size and layout based on provided constraints.
class DayViewCard extends ConsumerStatefulWidget {
  /// Creates a [DayViewCard] widget.
  ///
  /// The [journal] parameter provides the journal data to display.
  /// The [editable] parameter defaults to true and controls edit/delete visibility.
  /// The [cardMinHeight], [cardMaxHeight], and [cardMaxWidth] define size constraints.
  /// The [horizontalPadding] and [verticalPadding] set internal spacing.
  /// The [textMaxLine] limits the content text lines.
  /// The [dateFontSize] sets the date text size.
  const DayViewCard({
    super.key,
    required this.journal,
    this.editable = true,
    this.cardMinHeight = 0,
    this.cardMaxHeight = 320,
    this.cardMaxWidth = 300,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 0.0,
    this.textMaxLine = 3,
    this.dateFontSize = 12,
    this.onTapCallback,
  });

  final Journal journal;
  final bool editable;
  final double cardMinHeight;
  final double cardMaxHeight;
  final double cardMaxWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final int textMaxLine;
  final double dateFontSize;
  final void Function()? onTapCallback;
  @override
  ConsumerState<DayViewCard> createState() => _DayViewCardState();
}

class _DayViewCardState extends ConsumerState<DayViewCard> {
  bool _isImagesHidden = true;
  void _showHiddenImages() {
    setState(() {
      _isImagesHidden = !_isImagesHidden;
    });
  }

  double get cardMaxHeightOnImageCount =>
      widget.journal.images!.length > 5 && !_isImagesHidden
          ? widget.cardMaxHeight * 2
          : widget.cardMaxHeight;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: max(widget.cardMaxWidth,
            MediaQuery.sizeOf(context).width - 32), // Ensure responsiveness
        minHeight: widget.cardMinHeight,
        maxHeight: cardMaxHeightOnImageCount,
      ),
      child: Card.outlined(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        elevation: 2.0, // Slight shadow for depth
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Minimize vertical space
          children: [
            widget.journal.images != null && widget.journal.images!.isNotEmpty
                ? Expanded(
                    child: Center(
                      child: CustomImageWidgetLayout(
                        images: widget.journal.images!.map((item) {
                          if (item is String) {
                            return UrlImage(
                                item); // Convert string to image type
                          } else {
                            throw ArgumentError(
                                'Invalid type in list: ${item.runtimeType}');
                          }
                        }).toList(),
                        onTapCallback: widget.onTapCallback,
                        isImagesHidden: _isImagesHidden,
                        showHiddenImages: _showHiddenImages,
                      ),
                    ),
                  )
                : const SizedBox.shrink(), // Hide if no images
            widget.journal.title!.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding,
                      vertical: 5,
                    ),
                    child: Text(
                      widget.journal.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            widget.journal.content!.isEmpty
                ? const SizedBox.shrink()
                : TextPortion(
                    horizontalPadding: widget.horizontalPadding,
                    verticalPadding: widget.verticalPadding,
                    child: RichText(
                      maxLines: widget.textMaxLine,
                      overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                      text: TextSpan(
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                        text: widget.journal.content,
                      ),
                    ),
                  ),
            widget.journal.content!.isEmpty && widget.journal.title!.isEmpty
                ? const SizedBox.shrink()
                : Divider(
                    height: 0.5,
                    thickness: 1,
                    indent: widget.verticalPadding,
                    endIndent: widget.verticalPadding,
                  ), // Separator between content and date
            Flexible(
              child: DatePortion(
                fontSize: widget.dateFontSize,
                horizontalPadding: widget.horizontalPadding,
                verticalPadding: widget.verticalPadding,
                date: widget.journal.date!,
                editable: widget.editable,
                onEdit: () {
                  widget.onTapCallback?.call();
                  context.push('/update/${widget.journal.id}');
                }, // Navigate to edit page
                onDelete: () {
                  widget.onTapCallback?.call();
                  handleJournalDelete(context, ref, widget.journal.id!);
                },
                onTapCallback: widget.onTapCallback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
