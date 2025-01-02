import 'package:farmers_journal/domain/model/plant.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/data/firestore_service.dart';
import 'package:uuid/uuid.dart';


part 'user_controller.g.dart';

@riverpod
class UserController extends _$UserController {
  @override
  Future<AppUser?> build() {
    final repository = ref.read(userRepositoryProvider);
    return repository.getUser();
  }

  Future<void> setPlantAndPlace(
      {required String plantName, required String place}) async {
    final repository = ref.read(userRepositoryProvider);
    const uuid = Uuid();
    final Plant plant =
        Plant.fromJson({'id': uuid.v4(), 'name': plantName, 'place': place});
    repository.setPlantAndPlace(plant: plant);
    ref.invalidateSelf();
  }

  Future<void> setPlant(
      {required String? id, required String? newPlantName}) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.setPlant(id: id, newPlantName: newPlantName);
    ref.invalidateSelf();
  }

  Future<void> setPlace(
      {required String? id, required String? newPlantPlace}) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.setPlace(id: id, newPlantPlace: newPlantPlace);
    ref.invalidateSelf();
  }
}
