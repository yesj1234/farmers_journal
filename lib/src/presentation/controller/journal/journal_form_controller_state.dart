import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_form_controller_state.freezed.dart';

@freezed
class JournalFormControllerState with _$JournalFormControllerState {
  const factory JournalFormControllerState.initial() = Initial;
  const factory JournalFormControllerState.error(Object? e, [StackTrace? stk]) =
      Error;
  const factory JournalFormControllerState.loading() = Loading;
  const factory JournalFormControllerState.done() = Done;
}
