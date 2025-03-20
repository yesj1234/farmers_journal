import 'package:farmers_journal/src/domain/firebase/default_image.dart';

abstract class DefaultImageRepository {
  Future<DefaultImage> getDefaultImage();
}
