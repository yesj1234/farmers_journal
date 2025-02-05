import 'package:farmers_journal/domain/model/report.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "report_state.freezed.dart";

@freezed
class ReportState with _$ReportState {
  const factory ReportState.initial() = Initial;
  const factory ReportState.data(List<Report?> reports) = Data;
  const factory ReportState.error(Object? e, [StackTrace? stk]) = Error;
  const factory ReportState.loading() = Loading;
  const factory ReportState.done() = Done;
}
