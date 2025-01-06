import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/controller/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PageLogin extends ConsumerWidget {
  const PageLogin({super.key});
  get registrationButtonStyle => ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const _DividerWithText(text: "혹은"),
            Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('계정이 없으신가요?'),
                TextButton(
                  onPressed: () {
                    context.go('/registration');
                  },
                  style: registrationButtonStyle,
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(authControllerProvider.notifier)
                    .signInWithKakaoTalk()
                    .then((_) => null, onError: (error) {
                  showSnackBar(context, error);
                });
              },
              child: const Text('KakaoTalk'),
            )
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

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm({super.key});

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력하세요';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '올바른 이메일 형식을 입력하세요';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요';
    }
    if (value.length < 6) {
      return '비밀번호는 최소 6자 이상이어야 합니다';
    }
    return null;
  }

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
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  void onEmailSaved(String? value) {
    email = value;
  }

  void onPasswordSaved(String? value) {
    password = value;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<void> state = ref.watch(authControllerProvider);
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LoginFormTextField(
            text: 'Email',
            subText: '',
            onValidate: validateEmail,
            onSaved: onEmailSaved,
          ),
          _LoginFormTextField(
            text: 'Password',
            subText: 'forgot your password?',
            onValidate: validatePassword,
            onSaved: onPasswordSaved,
            obscureText: true,
          ),
          Flexible(
            child: ElevatedButton(
              style: loginButtonStyle,
              onPressed: state.isLoading
                  ? null
                  : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithEmail(email: email!, password: password!)
                            .then((_) {
                          context.go('/');
                        }, onError: (error) {
                          showSnackBar(context, error.toString());
                        });
                      }
                    },
              child: _CustomText(
                status: state.isLoading ? true : false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomText extends StatelessWidget {
  const _CustomText({super.key, required this.status});
  final bool status;
  @override
  Widget build(BuildContext context) {
    if (status == false) {
      return const Text(
        'Login',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class _LoginFormTextField extends StatelessWidget {
  const _LoginFormTextField({
    super.key,
    required this.text,
    required this.subText,
    required this.onValidate,
    required this.onSaved,
    this.obscureText = false,
  });
  final FormFieldValidator<String> onValidate;
  final void Function(String?) onSaved;
  final String text;
  final String subText;
  final bool obscureText;
  BoxConstraints get textFormConstraints => const BoxConstraints(
        minHeight: 70,
        maxHeight: 90,
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: TextFormField(
              validator: onValidate,
              onSaved: onSaved,
              obscureText: obscureText,
              decoration: inputDecoration.copyWith(
                label: Text(
                  text,
                  style: labelTextStyle,
                ),
              ),
            ),
          ),
          subText.isNotEmpty
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Text(subText, style: helpTextStyle),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
