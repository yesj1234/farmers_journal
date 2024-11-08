import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/providers.dart';
import 'package:flutter/material.dart';

/// TODO:
/// 2. GET dummy image stored in fire storage DONE / dummy title and content in firestore
/// 3. DRAW the widget tree composing this single item view card. DONE
/// 4. ADD Intl api formatting the datatime to locale date time. DONE
/// 5. Structure the image list of each journal. image contained in jounrnal can be in range from 0 to 8.
/// 6. Change the code showing the placement of pictures.
/// 7. Add on progress circular indicator to show the fetching image.
/// 8. Add caching image to local device.
class CardSingle extends StatelessWidget {
  const CardSingle(
      {super.key, this.createdAt, this.title, this.content, this.image});
  final double innerPadding = 12.0;
  final Timestamp? createdAt;
  final String? title;
  final String? content;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UpperDatePortion(
          padding: innerPadding,
          child: Text(
            "${DateTime.parse(createdAt!.toDate().toString()).day}일",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 270, maxWidth: 325),
          child: Card(
            color: colorScheme.surface.withOpacity(0.5),
            elevation: 3.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImagePortion(padding: innerPadding, url: image),
                title != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: innerPadding),
                        child: Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox(width: 0, height: 0),
                _TextPortion(
                  padding: innerPadding,
                  child: RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                          text: content)),
                ),
                const Spacer(),
                const Divider(
                  indent: 12,
                  endIndent: 12,
                ),
                _DatePortion(
                  padding: innerPadding,
                  date: DateTime.now(),
                  onEdit: () => debugPrint("Hello"),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _UpperDatePortion extends StatelessWidget {
  final double padding;
  final Widget? child;
  const _UpperDatePortion(
      {super.key, this.padding = 12.0, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding), child: child);
  }
}

class _ImagePortion extends StatelessWidget {
  final String? url;
  final double padding;

  const _ImagePortion({required this.padding, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: padding, right: padding, top: 8.0, bottom: 8.0),
      child: SizedBox(
        height: 110,
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(4.0),
            right: Radius.circular(4.0),
          ),
          child: url != null
              ? Center(
                  child: AspectRatio(
                    aspectRatio: 13 / 4,
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
  final double padding;
  final Widget? child;

  const _TextPortion({required this.child, required this.padding});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: padding, right: padding, top: 8.0, bottom: 8.0),
        child: child);
  }
}

class _DatePortion extends StatelessWidget {
  final double padding;
  final DateTime date;
  final VoidCallback onEdit;
  const _DatePortion(
      {required this.padding, required this.date, required this.onEdit});

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
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
    );

    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding, bottom: 4.0),
      child: Row(
        children: [
          Text(
            '${_formatDate(date)}',
            style: textStyle,
          ),
          const Spacer(),
          const Icon(
            Icons.create_rounded,
            size: 20,
          ),
        ],
      ),
    );
  }
}
