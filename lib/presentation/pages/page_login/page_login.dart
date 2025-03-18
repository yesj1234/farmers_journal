import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/controller/auth/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple_login;

class PageLogin extends ConsumerWidget {
  const PageLogin({super.key});
  get registrationButtonStyle => ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width / 1.2,
                    ),
                    child: _KakaoLoginButton(
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInWithKakaoTalk()
                            .then((_) {}, onError: (error) {
                          showSnackBar(context, error);
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
                    child: _AppleLoginButton(
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInWithApple()
                            .then((_) {}, onError: (error) {
                          showSnackBar(context, error);
                        });
                        if (context.mounted) {
                          context.go('/');
                        }
                      },
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

/// Apple login button
///
/// Apple login button should be responsive.
/// Apple provides [system-provided buttons and built-in button styles](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple#Displaying-buttons).
/// [sign_in_with_apple package](https://pub.dev/packages/sign_in_with_apple) works well as the bridge between flutter and the Apple provided login buttons APIs.
class _AppleLoginButton extends StatelessWidget {
  const _AppleLoginButton({super.key, required this.onPressed});
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return apple_login.SignInWithAppleButton(
        onPressed: onPressed,
        style: apple_login.SignInWithAppleButtonStyle.black,
        height: 44,
        borderRadius: BorderRadius.circular(8),
        iconAlignment: apple_login.IconAlignment.left,
        text: '애플 로그인');
  }
}

class KakaoLogoPainter extends CustomPainter {
  const KakaoLogoPainter({
    required this.color,
  });
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawPath(_getKakaoPath(size.width, size.height), paint);
  }

  static Path _getKakaoPath(double w, double h) {
    Path path = Path();

    path = Path();
    path.lineTo(w * 0.23, h * 0.56);
    path.cubicTo(w * 0.23, h * 0.56, w / 4, h * 0.4, w * 0.44, h * 0.29);
    path.cubicTo(w * 0.63, h * 0.18, w * 0.84, h / 5, w * 0.98, h * 0.28);
    path.cubicTo(w * 1.07, h * 0.32, w * 1.26, h * 0.49, w * 1.21, h * 0.73);
    path.cubicTo(w * 1.16, h * 0.96, w * 0.93, h * 1.08, w * 0.69, h * 1.08);
    path.cubicTo(w * 0.69, h * 1.08, w * 0.62, h * 1.07, w * 0.62, h * 1.07);
    path.cubicTo(w * 0.62, h * 1.07, w * 0.41, h * 1.22, w * 0.41, h * 1.22);
    path.cubicTo(w * 0.41, h * 1.22, w * 0.45, h, w * 0.45, h);
    path.cubicTo(w * 0.45, h, w * 0.16, h * 0.87, w * 0.23, h * 0.56);
    path.cubicTo(w * 0.23, h * 0.56, w * 0.23, h * 0.56, w * 0.23, h * 0.56);
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _KakaoLoginButton extends StatelessWidget {
  const _KakaoLoginButton({
    super.key,
    required this.onPressed,
    this.text = '카카오 로그인',
    this.height = 44,
  });
  final void Function() onPressed;
  final String text;
  final double height;
  static const _scale = 28 / 44;

  @override
  Widget build(BuildContext context) {
    final double fontSize = height * 0.43;
    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        inherit: false,
        color: const Color.fromRGBO(0, 0, 0, 0.85),
        fontFamily: '.SF Pro Text',
        letterSpacing: -0.41,
        fontWeight: FontWeight.w500,
        fontSize: fontSize.toDouble(),
      ),
    );

    final kakaoIcon = Container(
      width: _scale * height,
      height: _scale * height + 2,
      padding: EdgeInsets.only(
        bottom: (4 / 44) * height,
      ),
      child: Center(
        child: SizedBox(
          width: fontSize,
          height: fontSize,
          child: const CustomPaint(
            painter: KakaoLogoPainter(color: Colors.black),
          ),
        ),
      ),
    );
    var children = <Widget>[];
    children = [
      kakaoIcon,
      Expanded(
        child: textWidget,
      ),
      SizedBox(
        width: _scale * height,
      ),
    ];
    return SizedBox(
      height: height,
      child: SizedBox.expand(
        child: CupertinoButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(254, 229, 0, 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
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
        Image.asset(
          'assets/icons/leaf_icon.png',
          height: 100,
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
                  style: labelTextStyle.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
          ),
          subText.isNotEmpty
              ? Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/reset_password');
                    },
                    child: Text(subText, style: helpTextStyle),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
