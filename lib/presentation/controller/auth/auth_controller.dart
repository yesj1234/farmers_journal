import 'package:farmers_journal/data/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/presentation/controller/auth/auth_state.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthenticationState build() {
    return const AuthenticationState.initial();
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AuthenticationState.loading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signUpWithEmail(email: email, password: password);
      state = const AuthenticationState.authenticated();
    } catch (error) {
      state = AuthenticationState.unauthenticated(message: error.toString());
    }
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    state = const AuthenticationState.loading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password);
      state = const AuthenticationState.authenticated();
    } catch (error) {
      state = AuthenticationState.unauthenticated(message: error.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthenticationState.loading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AuthenticationState.authenticated();
    } catch (error) {
      state = AuthenticationState.unauthenticated(message: error.toString());
    }
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    state = const AuthenticationState.loading();
    try {
      await ref.read(authRepositoryProvider).resetPassword(email: email);
      state = const AuthenticationState.authenticated();
    } catch (error) {
      state = AuthenticationState.unauthenticated(message: error.toString());
    }
  }

  Future<void> deleteAccount() async {
    state = const AuthenticationState.loading();
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      state = const AuthenticationState.authenticated();
    } catch (error) {
      state = AuthenticationState.unauthenticated(message: error.toString());
    }
  }
}
