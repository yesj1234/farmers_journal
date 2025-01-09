import 'package:flutter/material.dart';

class PlantSelection extends StatelessWidget {
  const PlantSelection(
      {super.key, required this.onChange, required this.onFieldSubmitted});
  final void Function(String) onChange;
  final void Function(String) onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlantTextField(
              onFieldSubmitted: onFieldSubmitted, onChange: onChange),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class PlantTextField extends StatefulWidget {
  const PlantTextField(
      {super.key, required this.onFieldSubmitted, required this.onChange});
  final void Function(String) onFieldSubmitted;
  final void Function(String) onChange;
  @override
  State<PlantTextField> createState() => _PlantTextFieldState();
}

class _PlantTextFieldState extends State<PlantTextField> {
  InputDecoration get inputDecoration => const InputDecoration(
        labelText: "작물 선택",
        fillColor: Colors.transparent,
        isDense: true,
      );
  final TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
              validator: (inputValue) {
                if (inputValue == null) {
                  return 'Null not allowed';
                }
                if (inputValue.isEmpty) {
                  return 'Empty value not allowed';
                }
                return null;
              },
              onChanged: widget.onChange,
              controller: textEditingController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (String text) {
                widget.onFieldSubmitted(text);
              },
              decoration: inputDecoration),
        ),
        InkWell(
          onTap: () {
            widget.onFieldSubmitted(textEditingController.text);
          },
          child: const Icon(Icons.check),
        )
      ],
    );
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
