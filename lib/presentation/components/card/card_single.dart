import 'package:flutter/material.dart';

import 'package:farmers_journal/domain/model/journal.dart';

/// TODO:
/// 2. GET dummy image stored in fire storage DONE / dummy title and content in firestore
/// 3. DRAW the widget tree composing this single item view card. DONE
/// 4. ADD Intl api formatting the datatime to locale date time. DONE
/// 5. Structure the image list of each journal. image contained in jounrnal can be in range from 0 to 8.
/// 6. Change the code showing the placement of pictures.
/// 7. Add on progress circular indicator to show the fetching image.
/// 8. Add caching image to local device.
class CardSingle extends StatelessWidget {
  const CardSingle({
    super.key,
    required this.journal,
    this.cardMinHeight = 0,
    this.cardMaxHeight = 300,
    this.cardMaxWidth = 270,
    this.horizontalPadding = 4.0,
    this.verticalPadding = 8.0,
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: cardMaxWidth,
                  minHeight: cardMinHeight,
                  maxHeight: cardMaxHeight),
              child: Card(
                shape: const ContinuousRectangleBorder(),
                color: colorScheme.surface.withOpacity(0.5),
                elevation: 2.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    journal.image != null && journal.image!.isNotEmpty
                        ? _ImagePortion(
                            horizontalPadding: horizontalPadding,
                            verticalPadding: verticalPadding,
                            aspectRatio: aspectRatio,
                            url: journal.image)
                        : const SizedBox.shrink(),
                    journal.title != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
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
                        child: _TextPortion(
                      horizontalPadding: horizontalPadding,
                      verticalPadding: verticalPadding,
                      child: RichText(
                          maxLines: textMaxLine,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant),
                              text: journal.content)),
                    )),
                    Divider(
                      indent: verticalPadding,
                      endIndent: verticalPadding,
                    ),
                    _DatePortion(
                      fontSize: dateFontSize,
                      horizontalPadding: horizontalPadding,
                      verticalPadding: verticalPadding,
                      date: journal.createdAt!,
                      onEdit: () => debugPrint("Hello"),
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }
}

class _UpperDatePortion extends StatelessWidget {
  final double padding;
  final Journal journal;
  const _UpperDatePortion(
      {super.key, required this.journal, this.padding = 12.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Text(
          "${journal.createdAt?.day}일",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ));
  }
}

class _ImagePortion extends StatelessWidget {
  final String? url;
  final double verticalPadding;
  final double horizontalPadding;
  final double aspectRatio;

  const _ImagePortion(
      {required this.verticalPadding,
      required this.horizontalPadding,
      required this.aspectRatio,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: SizedBox(
        height: 100,
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          child: url != null
              ? Center(
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Image.network(url!, fit: BoxFit.fill),
                  ),
                )
              : const Text("Network Error"),
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
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        children: [
          Text(
            '${_formatDate(date)}',
            style: textStyle,
          ),
          const Spacer(),
          const Icon(
            Icons.create_rounded,
            size: 18,
          ),
        ],
      ),
    );
  }
}
