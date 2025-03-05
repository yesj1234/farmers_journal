import 'dart:math' hide log;
import 'package:farmers_journal/presentation/components/handle_journal_delete.dart';
import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';
import '../../pages/page_journal/image_type.dart';

/// A card widget displaying a journal entry for a single day.
///
/// This widget shows a journal's images, title, content, and date, with optional
/// edit and delete actions. It adapts its size and layout based on provided constraints.
class DayViewCard extends ConsumerWidget {
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
    this.cardMaxHeight = 300,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: max(cardMaxWidth,
            MediaQuery.sizeOf(context).width - 32), // Ensure responsiveness
        minHeight: cardMinHeight,
        maxHeight: cardMaxHeight,
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
            journal.images != null && journal.images!.isNotEmpty
                ? Expanded(
                    child: Center(
                      child: CustomImageWidgetLayout(
                        images: journal.images!.map((item) {
                          if (item is String) {
                            return UrlImage(
                                item); // Convert string to image type
                          } else {
                            throw ArgumentError(
                                'Invalid type in list: ${item.runtimeType}');
                          }
                        }).toList(),
                        onTapCallback: onTapCallback,
                      ),
                    ),
                  )
                : const SizedBox.shrink(), // Hide if no images
            journal.title!.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 5,
                    ),
                    child: Text(
                      journal.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            journal.content!.isEmpty
                ? const SizedBox.shrink()
                : TextPortion(
                    horizontalPadding: horizontalPadding,
                    verticalPadding: verticalPadding,
                    child: RichText(
                      maxLines: textMaxLine,
                      overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                      text: TextSpan(
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                        text: journal.content,
                      ),
                    ),
                  ),
            journal.content!.isEmpty && journal.title!.isEmpty
                ? const SizedBox.shrink()
                : Divider(
                    height: 0.5,
                    thickness: 1,
                    indent: verticalPadding,
                    endIndent: verticalPadding,
                  ), // Separator between content and date
            Flexible(
              child: DatePortion(
                fontSize: dateFontSize,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                date: journal.date!,
                editable: editable,
                onEdit: () {
                  onTapCallback?.call();
                  context.push('/update/${journal.id}');
                }, // Navigate to edit page
                onDelete: () {
                  onTapCallback?.call();
                  handleJournalDelete(context, ref, journal.id!);
                },
                onTapCallback: onTapCallback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
