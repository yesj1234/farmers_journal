import 'package:farmers_journal/domain/model/journal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_state.freezed.dart';

@freezed
class JournalState with _$JournalState {
  const factory JournalState.initial() = _Initial;
  const factory JournalState.loading() = _Loading;
  const factory JournalState.success({required List<Journal?> journals}) =
      _Success;
  const factory JournalState.failure({String? message}) = _Failure;
}
