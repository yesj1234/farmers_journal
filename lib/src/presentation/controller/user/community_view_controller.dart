import 'package:farmers_journal/src/data/firestore_providers.dart';
import 'package:farmers_journal/src/presentation/controller/user/community_view_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
part 'community_view_controller.g.dart';

/// {@category Controller}
@riverpod
class CommunityViewController extends _$CommunityViewController {
  @override
  CommunityViewState build() {
    return const CommunityViewState.initial();
  }

  Future<void> getUserById({required String id}) async {
    state = const CommunityViewState.loading();
    try {
      final userInfo =
          await ref.read(userRepositoryProvider).getUserById(id: id);

      state = CommunityViewState.data(userInfo);
    } catch (stk, error) {
      print(stk);
      state = CommunityViewState.error(error);
    }
  }
}
