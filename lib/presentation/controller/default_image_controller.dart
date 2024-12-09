import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:farmers_journal/data/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'default_image_controller.g.dart';

@riverpod
class DefaultImageController extends _$DefaultImageController {
  @override
  Future<DefaultImage> build() async {
    final repository = ref.read(defaultImageRepositoryProvider);
    return await repository.getDefaultImage();
  }
}
