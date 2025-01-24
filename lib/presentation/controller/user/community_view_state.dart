import 'package:farmers_journal/domain/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_view_state.freezed.dart';

@freezed
class CommunityViewState with _$CommunityViewState {
  const factory CommunityViewState.initial() = Initial;
  const factory CommunityViewState.data(AppUser userInfo) = Data;
  const factory CommunityViewState.error(Object? e, [StackTrace? stk]) = Error;
  const factory CommunityViewState.loading() = Loading;
}
