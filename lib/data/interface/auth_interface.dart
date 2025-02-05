import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class AuthRepository {
  User? getCurrentUser();
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });
  Future<void> signInWithApple();
  Future<void> signInWithKakaoTalk();
  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<void> signOut();
  Future<void> resetPassword({
    required String email,
  });
  Future<void> deleteAccount();
  Future<void> setProfileImage({required Uint8List bytes});
  Future<void> setProfileName({required String name});
}
