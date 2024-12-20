import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/domain/model/journal.dart';

class CardSingle extends StatelessWidget {
  const CardSingle({
    super.key,
    required this.journal,
    this.cardMinHeight = 0,
    this.cardMaxHeight = 300,
    this.cardMaxWidth = 270,
    this.horizontalPadding = 4.0,
    this.verticalPadding = 0.0,
    this.textMaxLine = 3,
    this.aspectRatio = 7 / 3,
    this.dateFontSize = 12,
  });
  final Journal journal;
  final double cardMinHeight;
  final double cardMaxHeight;
  final double cardMaxWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final int textMaxLine;
  final double aspectRatio;
  final double dateFontSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: cardMaxWidth,
          minHeight: cardMinHeight,
          maxHeight: cardMaxHeight),
      child: Card(
        color: colorScheme.surface.withOpacity(0.5),
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            journal.images != null && journal.images!.isNotEmpty
                ? Expanded(
                    flex: 4,
                    child: ImageWidgetLayout(
                        images: journal.images as List<dynamic>),
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
            Expanded(
              flex: 2,
              child: _TextPortion(
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
            Expanded(
              child: Container(
                  child: _DatePortion(
                fontSize: dateFontSize,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                date: journal.createdAt!,
                onEdit: () => context.go('/update/${journal.id}'),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

/// TODO:
/// 1. Add abbreviation functionality when the text exceeds certain amount. DONE
/// 2. connect onTap / onClick functionality to onCreate icon.
class _TextPortion extends StatelessWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final Widget? child;

  const _TextPortion(
      {required this.child,
      required this.horizontalPadding,
      required this.verticalPadding});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: child);
  }
}

class _DatePortion extends StatelessWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final DateTime date;
  final VoidCallback onEdit;
  final double fontSize;

  const _DatePortion(
      {required this.horizontalPadding,
      required this.verticalPadding,
      required this.date,
      required this.onEdit,
      required this.fontSize});

  String? _formatDate(DateTime date) {
    final localDateTime = date.toLocal();
    final weekDayOrder = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
    int month = localDateTime.month;
    int day = localDateTime.day;
    int weekDay = localDateTime.weekday;

    return '$month월 $day일 ${weekDayOrder[weekDay]}';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      child: Row(
        children: [
          Text(
            '${_formatDate(date)}',
            style: textStyle,
          ),
          const Spacer(),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onEdit,
                child: const Icon(
                  Icons.create_rounded,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
