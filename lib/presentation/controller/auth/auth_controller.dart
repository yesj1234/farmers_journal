import 'package:flutter/foundation.dart';
import 'package:farmers_journal/data/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_controller.g.dart';

// TODO: handle the error state when login fails. Currently, the loading status does not change.
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() {
    return ref.read(authRepositoryProvider).getCurrentUser();
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signUpWithEmail(email: email, password: password);
      ref.invalidateSelf();
    } catch (error) {
      state = const AsyncData(null);
    }
  }

  Future<void> signInWithKakaoTalk() async {
    state = const AsyncLoading();
    try {
      ref.read(authRepositoryProvider).signInWithKakaoTalk();
    } catch (error) {
      state = const AsyncData(null);
    }
    ref.invalidateSelf();
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password);
      ref.invalidateSelf();
    } catch (error) {
      state = const AsyncData(null);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).signOut();
    ref.invalidateSelf();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).resetPassword(email: email);
    ref.invalidateSelf();
  }

  Future<void> deleteAccount() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).deleteAccount();
    ref.invalidateSelf();
  }

  Future<void> setProfileImage({required XFile image}) async {
    state = const AsyncLoading();
    Uint8List bytes = await image.readAsBytes();
    await ref.read(authRepositoryProvider).setProfileImage(bytes: bytes);
    ref.invalidateSelf();
  }

  Future<void> setProfileName({required String name}) async {
    await ref.read(authRepositoryProvider).setProfileName(name: name);
    ref.invalidateSelf();
  }
}
