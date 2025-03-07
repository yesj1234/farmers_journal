import 'dart:collection';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/model/journal.dart';
import '../../../utils.dart';

part 'week_view_state.freezed.dart';

@freezed
class WeekViewState with _$WeekViewState {
  const factory WeekViewState.initial() = Initial;
  const factory WeekViewState.data(List<WeeklyGroup<Journal>> data) = Data;
  const factory WeekViewState.loading() = Loading;
  const factory WeekViewState.error(Object? e, [StackTrace? stk]) = Error;
}
