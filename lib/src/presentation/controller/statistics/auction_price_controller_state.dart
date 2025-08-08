import 'package:farmers_journal/src/domain/model/real_time_auction_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auction_price_controller_state.freezed.dart';

@freezed
sealed class AuctionPriceControllerState with _$AuctionPriceControllerState {
  const factory AuctionPriceControllerState.initial() = Initial;
  const factory AuctionPriceControllerState.loading() = Loading;
  const factory AuctionPriceControllerState.data(List<AuctionPrice> data) =
      Data;
  const factory AuctionPriceControllerState.error(Object? e, StackTrace stk) =
      Error;
}
