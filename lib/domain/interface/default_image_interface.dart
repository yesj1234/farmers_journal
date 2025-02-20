import 'package:farmers_journal/domain/firebase/DefaultImage.dart';

abstract class DefaultImageRepository {
  Future<DefaultImage> getDefaultImage();
}
