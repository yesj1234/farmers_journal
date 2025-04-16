import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple_login;

class EmailLoginButton extends StatelessWidget {
  const EmailLoginButton({
    super.key,
    required this.status,
    required this.onPressed,
  });

  final bool status;
  final void Function()? onPressed;
  ButtonStyle get loginButtonStyle => ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.zero,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 100,
        height: 44,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 5,
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            status
                ? const Positioned(
                    right: 0, top: 0, child: CircularProgressIndicator())
                : Positioned(
                    right: 0,
                    top: 2,
                    child: Icon(
                      Icons.login_outlined,
                      size: 35,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

/// Apple login button
///
/// Apple login button should be responsive.
/// Apple provides [system-provided buttons and built-in button styles](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple#Displaying-buttons).
/// [sign_in_with_apple package](https://pub.dev/packages/sign_in_with_apple) works well as the bridge between flutter and the Apple provided login buttons APIs.
class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({super.key, required this.onPressed});
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

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({
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
