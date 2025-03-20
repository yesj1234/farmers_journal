import 'package:image_picker/image_picker.dart';

sealed class ImageType {}

final class UrlImage extends ImageType {
  UrlImage(this.value);
  final String value;
}

final class XFileImage extends ImageType {
  XFileImage(this.value);
  final XFile value;
}
