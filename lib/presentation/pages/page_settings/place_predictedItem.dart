import 'package:flutter/material.dart';

class PlaceAutoCompletePredictionItem extends StatelessWidget {
  const PlaceAutoCompletePredictionItem(
      {super.key, required this.onTap, required this.description});

  final VoidCallback onTap;
  final String description;

  Shadow get shadow => const Shadow(
        offset: Offset(0.5, 2),
        blurRadius: 30,
        color: Color.fromRGBO(0, 0, 0, 0.5),
      );

  TextStyle get textStyle =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.normal, shadows: [
        shadow,
      ]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(Icons.place, size: 30, shadows: [
              shadow,
            ]),
            const SizedBox(width: 5),
            Expanded(
              child: Text.rich(
                TextSpan(text: description),
                style: textStyle,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
