import 'package:farmers_journal/presentation/components/profile_banner.dart';
import 'package:flutter/material.dart';

class PageProfileName extends StatelessWidget {
  const PageProfileName({super.key});

  BoxDecoration get floatingActionButtonDecoration => BoxDecoration(
        color: const Color.fromRGBO(184, 230, 185, 0.5),
        borderRadius: BorderRadius.circular(10),
      );

  TextStyle get floatingActionButtonTextStyle => const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Name")),
      body: const SafeArea(
        child: Column(
          children: [
            ProfileBanner(),
            SizedBox(height: 40),
            _ProfileNameForm(),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 300,
        height: 50,
        decoration: floatingActionButtonDecoration,
        child: Center(
          child: Text(
            "변경사항 저장",
            style: floatingActionButtonTextStyle,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ProfileNameForm extends StatelessWidget {
  const _ProfileNameForm({super.key});

  TextStyle get titleTextStyle => const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      );

  InputDecoration get inputDecoration => const InputDecoration(
        filled: false,
        hintText: "Anonymous",
        hintStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("프로필 이름", style: titleTextStyle),
        TextField(
          decoration: inputDecoration.copyWith(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 40),
          ),
        ),
      ],
    );
  }
}
