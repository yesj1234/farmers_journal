import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// TODO:
/// 2. GET dummy image stored in fire storage DONE / dummy title and content in firestore
/// 3. DRAW the widget tree composing this single item view card. DONE
/// 4. ADD Intl api formatting the datatime to locale date time. DONE
/// 5. Structure the image list of each journal. image contained in jounrnal can be in range from 0 to 8.
/// 6. Change the code showing the placement of pictures.
/// 7. Add on progress circular indicator to show the fetching image.
/// 8. Add caching image to local device.
class CardSingle extends StatefulWidget {
  const CardSingle({super.key});

  @override
  State<CardSingle> createState() => _CardSingleState();
}

class _CardSingleState extends State<CardSingle> {
  String? imageURL;
  final double innerPadding = 12.0;

  Future<void> _fetchImageURLs() async {
    final storageRef = FirebaseStorage.instance.ref();
    final String url =
        await storageRef.child('/grapeFarm.jpg').getDownloadURL();

    setState(() {
      imageURL = url;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchImageURLs();
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = imageURL != null
        ? ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(4.0),
              right: Radius.circular(4.0),
            ),
            child: Image.network(imageURL!, fit: BoxFit.cover),
          )
        : const Text("Network Error");
    // debugPrint(imageURL);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UpperDatePortion(
          padding: innerPadding,
          child: const Text(
            "오늘",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 335, maxWidth: 325),
          child: Card(
            color: colorScheme.primaryContainer,
            elevation: 3.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImagePortion(padding: innerPadding, child: image),
                _TextPortion(
                  padding: innerPadding,
                  child: RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: const TextSpan(
                          text:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In neque quam, pellentesque eu nisl a, posuere posuere lacus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. ")),
                ),
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
  final Widget? child;
  final double padding;

  const _ImagePortion({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: padding, right: padding, top: 8.0, bottom: 8.0),
        child: child);
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
      padding: EdgeInsets.symmetric(horizontal: padding),
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
