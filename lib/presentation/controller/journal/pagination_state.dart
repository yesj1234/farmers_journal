import 'package:farmers_journal/domain/model/journal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_state.freezed.dart';

@freezed
class PaginationState with _$PaginationState {
  const factory PaginationState.initial() = Initial;
  const factory PaginationState.data(List<Journal> journals) = Data;
  const factory PaginationState.error(Object? e, [StackTrace? stk]) = Error;
  const factory PaginationState.loading() = Loading;
  const factory PaginationState.onGoingLoading(List<Journal> journals) =
      OnGoingLoading;
  const factory PaginationState.onGoingError(List<Journal> journals, Object? e,
      [StackTrace? stk]) = OnGoingError;
}
