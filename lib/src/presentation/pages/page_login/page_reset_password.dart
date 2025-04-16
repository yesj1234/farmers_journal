import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/src/presentation/controller/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// {@category Presentation}
class PageResetPassword extends ConsumerStatefulWidget {
  const PageResetPassword({super.key});

  @override
  ConsumerState<PageResetPassword> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<PageResetPassword> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  InputDecoration get inputDecoration => const InputDecoration(
        filled: false,
        labelText: '이메일',
        hintText: 'example@example.com',
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
      );

  Future<bool> _resetPassword(context, String email) async {
    bool res = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(email: email)
        .then((_) {
      showSnackBar(context, '비밀번호 재설정 이메일이 전송되었습니다.');
      return true;
    }).onError((e, st) {
      showSnackBar(context, e.toString());
      return false;
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('비밀번호 재설정을 위해\n이메일을 입력해주세요',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: inputDecoration,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력하세요';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return '유효한 이메일을 입력하세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        bool success = await _resetPassword(context, email!);
                        if (success) {
                          context.mounted ? context.go('/') : null;
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('비밀번호 재설정 이메일 보내기',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                  ),
                ),
                const SizedBox(height: 16),
                Text('* 이메일을 통해 비밀번호 재설정 링크를 확인하세요.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
