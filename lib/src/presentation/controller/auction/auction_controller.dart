import 'package:farmers_journal/src/data/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/model/real_time_auction_info.dart';

part 'auction_controller.g.dart';

@riverpod
class AuctionController extends _$AuctionController {
  @override
  Future<List<AuctionPrice>> build() async {
    // Now you can make async calls directly in build()
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    final prices = await ref.read(auctionAPIProvider).getPrice(
        saleDate: DateTime.now(),
        whsalcd: '110001',
        large: '13',
        mid: '26',
        small: '03',
        startRow: 1,
        endRow: 10);

    return prices;
  }

  Future<void> refresh() async {
    // You can add methods to refresh data
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prices = await ref.read(auctionAPIProvider).getPrice(
          saleDate: DateTime.now(),
          whsalcd: '110001',
          large: '13',
          mid: '26',
          small: '03',
          startRow: 1,
          endRow: 10);
      return prices;
    });
  }
}
