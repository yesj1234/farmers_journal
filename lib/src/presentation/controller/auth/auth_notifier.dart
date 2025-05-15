import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/firestore_providers.dart';
import 'auth_notifier_state.dart';
import '../../../../domain.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthNotifierState build() {
    FirebaseAuth.instance.userChanges().listen((authUser) async {
      if (authUser == null) {
        state = const AuthNotifierState.data(null);
      } else {
        state = const AuthNotifierState.loading();
        final AppUser? user = await ref.read(userRepositoryProvider).getUser();
        if (user == null) {
          state = const AuthNotifierState.data(null);
        } else {
          state = AuthNotifierState.data(user);
        }
      }
    });
    FirebaseAuth.instance.authStateChanges().listen((authUser) async {
      if (authUser == null) {
        state = const AuthNotifierState.data(null);
      } else {
        state = const AuthNotifierState.loading();
        final AppUser? user = await ref.read(userRepositoryProvider).getUser();
        if (user == null) {
          state = const AuthNotifierState.data(null);
        } else {
          state = AuthNotifierState.data(user);
        }
      }
    });
    return const AuthNotifierState.initial();
  }
}
