import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_image_controller.g.dart';

@riverpod
class JournalImageController extends _$JournalImageController {
  @override
  List<AssetEntity> build() {
    return [];
  }

  void onDelete(int index) {
    final List<AssetEntity> temp = state;
    temp.removeAt(index);
    state = [...temp];
  }

  void onAssetTap(AssetEntity assetEntity) {
    if (state.contains(assetEntity)) {
      final List<AssetEntity> temp = state;
      temp.remove(assetEntity);
      state = [...temp];
    } else {
      state = [...state, assetEntity];
    }
  }
}
