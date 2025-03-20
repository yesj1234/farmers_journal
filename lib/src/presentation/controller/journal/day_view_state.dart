import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_view_state.freezed.dart';

@freezed
class DayViewState with _$DayViewState {
  const factory DayViewState.initial() = Initial;
  const factory DayViewState.data(Map<DateTime, List<Journal?>> data) = Data;
  const factory DayViewState.loading() = Loading;
  const factory DayViewState.error(Object? e, [StackTrace? stk]) = Error;
}
