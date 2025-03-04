import 'dart:collection';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/model/journal.dart';

part 'month_view_state.freezed.dart';

@freezed
class MonthViewState with _$MonthViewState {
  const factory MonthViewState.initial() = Initial;
  const factory MonthViewState.data(
      LinkedHashMap<DateTime, List<Journal?>> data) = Data;
  const factory MonthViewState.loading() = Loading;
  const factory MonthViewState.error(Object? e, [StackTrace? stk]) = Error;
}
