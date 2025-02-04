import 'dart:math';

import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/presentation/components/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';

import '../../pages/page_journal/image_type.dart';

class DayViewCard extends ConsumerWidget {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: max(cardMaxWidth, MediaQuery.sizeOf(context).width - 32),
          minHeight: cardMinHeight,
          maxHeight: cardMaxHeight),
      child: Card.outlined(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            journal.images != null && journal.images!.isNotEmpty
                ? Expanded(
                    flex: 4,
                    child: HeroImageWidgetLayout(
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
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text(
                      journal.title!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(width: 0, height: 0),
            Flexible(
              flex: 2,
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
            Divider(
              indent: verticalPadding,
              endIndent: verticalPadding,
            ),
            Flexible(
              child: DatePortion(
                fontSize: dateFontSize,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                date: journal.date!,
                editable: editable,
                onEdit: () => context.go('/update/${journal.id}'),
                onDelete: () => showMyAlertDialog(
                    context: context,
                    type: AlertDialogType.delete,
                    cb: () => ref
                        .read(journalControllerProvider.notifier)
                        .deleteJournal(id: journal.id as String)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
