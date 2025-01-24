import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/presentation/controller/user/community_view_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_view_controller.g.dart';

@riverpod
class CommunityViewController extends _$CommunityViewController {
  CommunityViewState build() {
    return const CommunityViewState.initial();
  }

  Future<void> getUserById({required String id}) async {
    state = const CommunityViewState.loading();
    try {
      final userInfo =
          await ref.read(userRepositoryProvider).getUserById(id: id);
      state = CommunityViewState.data(userInfo);
    } catch (error) {
      state = CommunityViewState.error(error);
    }
  }
}
