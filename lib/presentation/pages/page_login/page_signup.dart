import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/controller/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PageSignup extends ConsumerStatefulWidget {
  const PageSignup({super.key});

  @override
  ConsumerState<PageSignup> createState() => _PageSignUpState();
}

class _PageSignUpState extends ConsumerState<PageSignup> {
  String? name;
  String? email;
  String? password;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool isAgreed = false;
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력하세요';
    }
    return null;
  }

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

  String? validateDoubleCheckPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 다시한번 입력하세요';
    } else if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }

  void onNameSaved(String? value) {
    name = value;
  }

  void onEmailSaved(String? value) {
    email = value;
  }

  void onPasswordSaved(String? value) {
    password = value;
  }

  void onFormSubmitted() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(authControllerProvider.notifier)
          .signUpWithEmail(email: email!, password: password!, name: name!)
          .then((_) {
        if (context.mounted) {
          showSnackBar(context, '회원가입이 완료되었습니다.');
          context.go('/initial_setting');
        }
      }).catchError((e) {
        if (context.mounted) {
          showSnackBar(context, e.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRef = ref.watch(authControllerProvider);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Registration',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 1.1,
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          bottom: 16,
                        ),
                        child: Text(
                          '회원 가입을 위해\n정보를 입력해주세요',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      _RegistrationFormTextField(
                          text: '이름',
                          onValidate: validateName,
                          onSaved: onNameSaved),
                      _RegistrationFormTextField(
                          text: '이메일',
                          onValidate: validateEmail,
                          onSaved: onEmailSaved),
                      _RegistrationFormTextField(
                          text: '비밀번호',
                          onValidate: validatePassword,
                          onSaved: onPasswordSaved,
                          obscureText: true,
                          controller: _passwordController),
                      _RegistrationFormTextField(
                        text: '비밀번호확인',
                        onValidate: validateDoubleCheckPassword,
                        onSaved: onPasswordSaved,
                        obscureText: true,
                      ),
                      Row(children: [
                        Checkbox(
                          value: isAgreed,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                isAgreed = value;
                              }
                            });
                          },
                        ),
                        const Text("이용약관에 동의합니다."),
                      ]),
                      ElevatedButton(
                        onPressed: authRef.isLoading || !isAgreed
                            ? null
                            : onFormSubmitted,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: authRef.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                '가입하기',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class _RegistrationFormTextField extends StatelessWidget {
  const _RegistrationFormTextField({
    required this.text,
    required this.onValidate,
    this.onSaved,
    this.obscureText = false,
    this.controller,
  });
  final FormFieldValidator<String> onValidate;
  final void Function(String?)? onSaved;
  final String text;
  final bool obscureText;
  final TextEditingController? controller;
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
        maxWidth: 300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
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
        ],
      ),
    );
  }
}
