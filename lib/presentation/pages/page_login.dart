import 'package:flutter/material.dart';

class PageLogin extends StatelessWidget {
  const PageLogin({super.key});
  ButtonStyle get loginButtonStyle => ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        fixedSize: const WidgetStatePropertyAll(
          Size(250, 0),
        ),
        backgroundColor: const WidgetStatePropertyAll(
          Colors.green,
        ),
        foregroundColor: const WidgetStatePropertyAll(
          Colors.white,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("login page"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            const _AppIcon(),
            const _LoginForm(),
            Flexible(
              child: ElevatedButton(
                style: loginButtonStyle,
                onPressed: () {
                  print('click login btn');
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const _DividerWithText(text: "혹은"),
            const Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('계정이 없으신가요?'),
                Text(
                  '회원가입',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText({super.key, required this.text});
  final String text;
  final double indent = 20;
  final double thickness = 2;
  final Color color = Colors.green;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color,
            thickness: thickness,
            indent: indent,
            endIndent: indent / 2,
          ),
        ),
        Text(
          text,
        ),
        Expanded(
          child: Divider(
            color: color,
            thickness: thickness,
            indent: indent / 2,
            endIndent: indent,
          ),
        )
      ],
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({super.key});
  TextStyle get textStyle => const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            color: Colors.grey,
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.tab_sharp,
          size: 70,
        ),
        Text("농사 일지", style: textStyle)
      ],
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({super.key});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: const Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LoginFormTextField(
            text: 'Email',
            subText: 'forgot your email?',
          ),
          _LoginFormTextField(
            text: 'Password',
            subText: 'forgot your password?',
          ),
        ],
      ),
    );
  }
}

class _LoginFormTextField extends StatelessWidget {
  const _LoginFormTextField(
      {super.key, required this.text, required this.subText});
  final String text;
  final String subText;
  BoxConstraints get textFormConstraints => const BoxConstraints(
        minHeight: 70,
        maxHeight: 80,
      );

  InputDecoration get inputDecoration => InputDecoration(
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      );
  TextStyle get labelTextStyle => const TextStyle(
        color: Colors.black54,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(3, 3),
            blurRadius: 10.0,
            color: Colors.grey,
          ),
        ],
      );
  TextStyle get helpTextStyle => const TextStyle(
        fontSize: 15,
        color: Colors.black54,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(3, 3),
            blurRadius: 10.0,
            color: Colors.grey,
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: textFormConstraints.copyWith(
          maxWidth: MediaQuery.sizeOf(context).width / 1.2),
      child: Column(
        spacing: 5,
        children: [
          Flexible(
            child: TextFormField(
              decoration: inputDecoration.copyWith(
                label: Text(
                  text,
                  style: labelTextStyle,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(subText, style: helpTextStyle),
          ),
        ],
      ),
    );
  }
}
