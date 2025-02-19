import 'package:flutter/material.dart';

class TitleForm extends StatelessWidget {
  const TitleForm({
    super.key,
    required this.controller,
    required this.notValid,
  });

  final TextEditingController controller;
  final bool notValid;

  TextStyle get textStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (notValid && controller.text.isEmpty) {
            return '비어 있는 일지를 만들 수 없습니다.';
          } else {
            return null;
          }
        },
        style: textStyle,
        decoration: const InputDecoration(
          hintText: '제목',
          fillColor: Colors.white,
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
