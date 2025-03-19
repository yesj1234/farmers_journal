import 'package:farmers_journal/domain/firebase/default_image.dart';

abstract class DefaultImageRepository {
  Future<DefaultImage> getDefaultImage();
}
