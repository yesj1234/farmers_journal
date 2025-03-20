import 'package:farmers_journal/src/presentation/components/layout_images/layout_images.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/image_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:farmers_journal/src/presentation/components/card/card_single.dart';

import '../handle_journal_delete.dart';

/// {@category Presentation}
/// A widget that displays a journal entry as a card with images, text, and action buttons.
///
/// This widget is used in the week view to present journal entries with optional images,
/// title, content preview, and date, along with edit and delete actions.
class WeekViewCard extends ConsumerWidget {
  /// Constructs a [WeekViewCard] widget.
  const WeekViewCard({
    super.key,
    required this.journal,
    this.cardMinHeight = 0,
    this.cardMaxHeight = 300,
    this.cardMaxWidth = 270,
    this.horizontalPadding = 6.0,
    this.verticalPadding = 0.0,
    this.textMaxLine = 3,
    this.dateFontSize = 12,
  });

  /// The journal entry to be displayed in the card.
  final Journal journal;

  /// Minimum height of the card.
  final double cardMinHeight;

  /// Maximum height of the card.
  final double cardMaxHeight;

  /// Maximum width of the card.
  final double cardMaxWidth;

  /// Horizontal padding for content inside the card.
  final double horizontalPadding;

  /// Vertical padding for content inside the card.
  final double verticalPadding;

  /// Maximum number of lines to display for the journal content.
  final int textMaxLine;

  /// Font size for the date display.
  final double dateFontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: cardMaxWidth,
          minHeight: cardMinHeight,
          maxHeight: cardMaxHeight),
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            journal.images != null && journal.images!.isNotEmpty
                ? Expanded(
                    flex: 4,
                    child: CustomImageWidgetLayout(
                        images: journal.images!.map((item) {
                      if (item is String) {
                        return UrlImage(item);
                      } else {
                        throw ArgumentError(
                            'Invalid type in list: ${item.runtimeType}');
                      }
                    }).toList()),
                  )
                : const SizedBox.shrink(),
            journal.title != null
                ? Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Text(
                        journal.title!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(width: 0, height: 0),
            Expanded(
              child: TextPortion(
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                child: RichText(
                  maxLines: textMaxLine,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                      text: journal.content),
                ),
              ),
            ),
            const Spacer(),
            Divider(
              indent: horizontalPadding,
              endIndent: horizontalPadding,
            ),
            Flexible(
              child: DatePortion(
                fontSize: dateFontSize,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                date: journal.date!,
                onEdit: () => context.push('/update/${journal.id}'),
                onDelete: () {
                  handleJournalDelete(context, ref, journal.id!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
