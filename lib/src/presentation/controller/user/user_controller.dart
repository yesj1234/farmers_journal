import 'package:farmers_journal/src/domain/model/plant.dart';
import 'package:farmers_journal/src/domain/model/user.dart';
import 'package:farmers_journal/src/presentation/controller/journal/pagination_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/src/data/firestore_providers.dart';
import 'package:uuid/uuid.dart';

part 'user_controller.g.dart';

/// {@category Controller}
@riverpod
class UserController extends _$UserController {
  @override
  Future<AppUser?> build(String? userId) {
    final repository = ref.read(userRepositoryProvider);

    if (userId == null) {
      return repository.getUser();
    } else {
      return repository.getUser(userId: userId);
    }
  }

  Future<void> editProfile(
      {String? name, String? nickName, XFile? profileImage}) async {
    try {
      await ref.read(userRepositoryProvider).editProfile(
          name: name, nickName: nickName, profileImage: profileImage);
    } catch (error) {
      throw Exception(error);
    } finally {
      ref.invalidateSelf();
    }
  }

  Future<void> setProfileImage({required XFile image}) async {
    try {
      state = const AsyncLoading();
      Uint8List bytes = await image.readAsBytes();
      await ref.read(userRepositoryProvider).setProfileImage(bytes: bytes);
    } catch (error) {
      throw Exception(error);
    } finally {
      ref.invalidateSelf();
    }
  }

  Future<void> setInitial(
      {required String plantName,
      required String place,
      required String code,
      required String name}) async {
    final repository = ref.read(userRepositoryProvider);
    const uuid = Uuid();
    final Plant plant = Plant.fromJson(
        {'id': uuid.v4(), 'name': plantName, 'place': place, 'code': code});
    repository.setInitial(plant: plant, name: name);

    ref.invalidateSelf();
  }

  Future<void> setPlant(
      {required String? id,
      required String? newPlantName,
      required String code}) async {
    final repository = ref.read(userRepositoryProvider);

    await repository.setPlant(id: id, newPlantName: newPlantName, code: code);

    ref.invalidateSelf();
  }

  Future<void> setPlace(
      {required String? id, required String? newPlantPlace}) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.setPlace(id: id, newPlantPlace: newPlantPlace);
    ref.invalidateSelf();
  }

  Future<void> blockUser({required String id}) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.blockUser(id: id);
    ref
        .read(paginationControllerProvider.notifier)
        .updateStateOnUserBlock(id: id);
  }
}
