import 'package:flutter/material.dart';

class PageTermsAndPolicy extends StatelessWidget {
  const PageTermsAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and policy'),
      ),
      body: const SafeArea(
        child: Center(child: Column(children: [_TermsAndPolicy()])),
      ),
    );
  }
}

class _TermsAndPolicy extends StatelessWidget {
  const _TermsAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        TextButton.icon(
          onPressed: () {},
          label: const Text(
            '서비스 이용약관',
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          label: const Text(
            '개인정보 처리방침',
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          label: const Text(
            '위치기반 서비스 이용약관',
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          label: const Text(
            '개인위치정보 처리방침',
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          label: const Text(
            '오픈소스 라이선스',
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          label: const Text(
            '회원 탈퇴',
          ),
        ),
      ],
    );
  }
}
