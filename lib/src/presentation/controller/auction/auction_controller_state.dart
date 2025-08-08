import 'package:farmers_journal/src/domain/model/real_time_auction_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auction_controller_state.freezed.dart';

@freezed
sealed class AuctionControllerState with _$AuctionControllerState {
  const factory AuctionControllerState.loading() = Loading;
  const factory AuctionControllerState.data(List<AuctionPrice> data) = Data;
  const factory AuctionControllerState.error(Object? error, [StackTrace? stk]) =
      Error;
  const factory AuctionControllerState.initial() = Initial;
}
