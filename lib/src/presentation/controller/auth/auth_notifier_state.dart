import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain.dart';

part 'auth_notifier_state.freezed.dart';

@freezed
class AuthNotifierState with _$AuthNotifierState {
  const factory AuthNotifierState.initial() = Initial;
  const factory AuthNotifierState.data(AppUser? appUser) = Data;
  const factory AuthNotifierState.loading() = Loading;
  const factory AuthNotifierState.error(Object? e, [StackTrace? stk]) = Error;
}
