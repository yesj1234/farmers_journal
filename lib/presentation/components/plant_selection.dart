import 'package:flutter/material.dart';

class PlantSelection extends StatelessWidget {
  const PlantSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlantTextField(),
          SizedBox(height: 10),
          PlantSuggestion(
            suggestions: [
              "캠밸얼리",
              "거봉",
              "샤인 머스캣",
              "레드글로브",
              "마스캇베리에이",
              "청포도",
              '흑보석'
            ],
          ),
        ],
      ),
    );
  }
}

class PlantTextField extends StatelessWidget {
  const PlantTextField({super.key});
  InputDecoration get inputDecoration => const InputDecoration(
        labelText: "작물 선택",
        fillColor: Colors.transparent,
        isDense: true,
      );

  @override
  Widget build(BuildContext context) {
    return TextField(decoration: inputDecoration);
  }
}

class PlantSuggestion extends StatelessWidget {
  const PlantSuggestion({super.key, required this.suggestions});
  final List<String> suggestions;

  TextStyle get textStyle => const TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        fontSize: 18,
        fontWeight: FontWeight.normal,
        shadows: [
          Shadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            offset: Offset(-1, -1),
            blurRadius: 10,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (String suggestion in suggestions)
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              top: 10,
            ),
            child: Text(suggestion, style: textStyle),
          )
      ],
    );
  }
}
