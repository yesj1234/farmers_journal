import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/src/presentation/controller/auth/auth_controller.dart';
import 'login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

/// {@category Presentation}
class PageLogin extends ConsumerWidget {
  const PageLogin({super.key});
  get registrationButtonStyle => ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    const _AppIcon(),
                    const _LoginForm(),
                    const _DividerWithText(text: "혹은"),
                    SizedBox(
                      width: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            spacing: 4,
                            children: [
                              const Text('비밀번호를 잊으셨나요?'),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => context.go('/reset_password'),
                                child: Text(
                                  "비밀번호 찾기",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('계정이 없으신가요?'),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  context.go('/registration');
                                },
                                child: Text(
                                  '회원가입',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width / 1.2,
                      ),
                      child: KakaoLoginButton(
                        onPressed: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .signInWithKakaoTalk()
                              .then((_) {}, onError: (error) {
                            if (context.mounted) {
                              showSnackBar(context, error);
                            }
                          });
                          if (context.mounted) {
                            context.go('/');
                          }
                        },
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width / 1.2,
                      ),
                      child: AppleLoginButton(
                        onPressed: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .signInWithApple()
                              .then((_) {}, onError: (error) {
                            if (context.mounted) {
                              showSnackBar(context, error);
                            }
                          });
                          if (context.mounted) {
                            context.go('/');
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText({required this.text});
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
  const _AppIcon();
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
        Image.asset(
          'assets/icons/leaf_icon.png',
          height: 160,
        ),
        Text("농사 일지", style: textStyle)
      ],
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isEmailObscure = true;

  void onEmailSaved(String? value) {
    email = value;
  }

  void onPasswordSaved(String? value) {
    password = value;
  }

  String? validateEmail(String? value) {
    if (emailController.text.isEmpty && email == null) {
      return null;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      return '올바른 이메일 형식을 입력하세요';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (passwordController.text.isEmpty && password == null) {
      return null;
    }
    if (passwordController.text.length < 6) {
      return '비밀번호는 최소 6자 이상이어야 합니다';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => _formKey.currentState?.validate());
    passwordController.addListener(() => _formKey.currentState?.validate());
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
            controller: emailController,
            text: '이메일',
            hintText: '예)farmer@mail.com',
            onValidate: validateEmail,
            onSaved: onEmailSaved,
          ),
          Stack(
            children: [
              _LoginFormTextField(
                controller: passwordController,
                text: '비밀번호',
                hintText: '비밀번호를 입력해주세요.',
                onValidate: validatePassword,
                onSaved: onPasswordSaved,
                obscureText: isEmailObscure,
              ),
              Positioned(
                right: 5,
                top: 25,
                child: GestureDetector(
                  onTap: () => setState(() {
                    isEmailObscure = !isEmailObscure;
                  }),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: isEmailObscure
                        ? const FaIcon(
                            key: ValueKey('obscure'),
                            color: Colors.grey,
                            FontAwesomeIcons.eyeSlash,
                            size: 20,
                          )
                        : const Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: FaIcon(
                              key: ValueKey('expose'),
                              color: Colors.grey,
                              FontAwesomeIcons.eye,
                              size: 20,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: EmailLoginButton(
              status: state.isLoading ? true : false,
              onPressed: state.isLoading
                  ? null
                  : () {
                      _formKey.currentState?.save();
                      final validated =
                          _formKey.currentState?.validate() ?? false;

                      if (validated &&
                          emailController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty) {
                        _formKey.currentState?.save();
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithEmail(email: email!, password: password!)
                            .then((_) {
                          if (context.mounted) {
                            context.go('/');
                          }
                        }, onError: (error) {
                          if (context.mounted) {
                            showSnackBar(context, error.toString());
                          }
                        });
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginFormTextField extends StatelessWidget {
  const _LoginFormTextField({
    required this.controller,
    required this.text,
    required this.onValidate,
    required this.onSaved,
    required this.hintText,
    this.obscureText = false,
  });
  final TextEditingController controller;
  final FormFieldValidator<String> onValidate;
  final void Function(String?) onSaved;
  final String text;

  final String hintText;
  final bool obscureText;
  BoxConstraints get textFormConstraints => const BoxConstraints(
        minHeight: 70,
        maxHeight: 90,
      );

  InputDecoration get inputDecoration => InputDecoration(
        filled: false,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
      );
  TextStyle get labelTextStyle => const TextStyle();
  TextStyle get helpTextStyle => const TextStyle(
        fontSize: 15,
      );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextFormField(
            controller: controller,
            validator: onValidate,
            onSaved: onSaved,
            obscureText: obscureText,
            obscuringCharacter: '*',
            decoration: inputDecoration.copyWith(
              label: Text(
                text,
                style: labelTextStyle.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
