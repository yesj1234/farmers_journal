import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@category Domain}
/// abstract class for auth repository.
///
abstract class AuthRepository {
  User? getCurrentUser();
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });
  Future<void> signInWithApple(WidgetRef widgetRef);
  Future<void> signInWithKakaoTalk(WidgetRef widgetRef);
  Future<void> signInWithEmail(
      {required String email,
      required String password,
      required WidgetRef widgetRef});
  Future<void> signOut(WidgetRef ref);
  Future<void> resetPassword({
    required String email,
  });
  Future<void> deleteAccount();
  Future<void> setProfileImage({required Uint8List bytes});
  Future<void> setProfileName({required String name});
}
