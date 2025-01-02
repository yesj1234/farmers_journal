import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
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
    this.cardMinHeight = 0,
    this.cardMaxHeight = 300,
    this.cardMaxWidth = 270,
    this.horizontalPadding = 4.0,
    this.verticalPadding = 0.0,
    this.textMaxLine = 3,
    this.dateFontSize = 12,
  });
  final Journal journal;
  final double cardMinHeight;
  final double cardMaxHeight;
  final double cardMaxWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final int textMaxLine;
  final double dateFontSize;
  Future<void> _showDeleteAlertDialog(context, cb) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('삭제', style: TextStyle(color: Colors.red)),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('정말 삭제하시겠습니까?'),
                  Text('이 동작은 되돌릴 수 없습니다.')
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소')),
              TextButton(
                child: const Text(
                  '삭제',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  cb();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: cardMaxWidth,
          minHeight: cardMinHeight,
          maxHeight: cardMaxHeight),
      child: Card(
        color: colorScheme.surface.withValues(alpha: 0.5),
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            journal.images != null && journal.images!.isNotEmpty
                ? Expanded(
                    flex: 4,
                    child: ImageWidgetLayout(
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
                date: journal.createdAt!,
                onEdit: () => context.go('/update/${journal.id}'),
                onDelete: () => _showDeleteAlertDialog(
                    context,
                    () => ref
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
