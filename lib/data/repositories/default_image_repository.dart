import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/domain/firebase/default_image.dart';
import 'package:farmers_journal/domain/interface/default_image_interface.dart';

/// {@category Data}
class FireStoreDefaultImageRepository implements DefaultImageRepository {
  final FirebaseFirestore instance;
  FireStoreDefaultImageRepository({required this.instance});
  @override
  Future<DefaultImage> getDefaultImage() async {
    // TODO: send request, parse response, return DefaultImage object or throw.
    final image = instance.collection('images').doc('LNnga0Rn86RkxU6kB8VO');
    final result = await image.get().then((DocumentSnapshot doc) {
      final json = doc.data() as Map<String, dynamic>;
      final defaultImage = DefaultImage.fromJson(json);
      return defaultImage;
    });
    return result;
  }
}
