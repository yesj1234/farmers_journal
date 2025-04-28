import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../firestore_providers.dart';
import '../../domain/interface/user_interface.dart';
import '../../domain/model/journal.dart';
import '../../domain/model/plant.dart';
import '../../domain/model/user.dart';
import '../../presentation/pages/page_journal/image_type.dart';

/// {@category Data}
/// Implementation of [AuthRepository] using Firebase auth backend service.
class FireStoreUserRepository implements UserRepository {
  final FirebaseFirestore instance;
  final Ref _ref;
  FireStoreUserRepository(
    this._ref, {
    required this.instance,
  });
  Future<DocumentReference<Map<String, dynamic>>?> _fetchUserRef() async {
    final User? userData = _ref.read(authRepositoryProvider).getCurrentUser();
    if (userData == null) {
      return null;
    } else {
      return instance.collection('users').doc(userData.uid);
    }
  }

  Future<String> _uploadBytes(
      {required Uint8List bytes,
      String? path,
      void Function({int transferred, int totalBytes})?
          progressCallback}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child("${path ?? ''}/$fileName");

    final compressedBytes = await FlutterImageCompress.compressWithList(bytes);

    UploadTask uploadTask = storageRef.putData(compressedBytes);
    int lastTransferred = -1;
    uploadTask.snapshotEvents.listen((snapshot) {
      if (lastTransferred != snapshot.bytesTransferred) {
        lastTransferred = snapshot.bytesTransferred;

        progressCallback?.call(
            transferred: snapshot.bytesTransferred,
            totalBytes: snapshot.totalBytes);
      }
    });

    TaskSnapshot snapshot = await uploadTask;

    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Future<void> setProfileImage({required Uint8List bytes}) async {
    try {
      final user = await _fetchUserRef();
      String photoURL =
          await _uploadBytes(bytes: bytes, path: 'profile_images');
      await user?.update({
        'profileImage': photoURL,
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> editProfile(
      {String? name, String? nickName, XFile? profileImage}) async {
    try {
      final user = await _fetchUserRef();
      Map<Object, Object> updateRef = {};
      if (name != null) {
        updateRef.update('name', (_) => name, ifAbsent: () => name);
      }
      if (nickName != null) {
        updateRef.update('nickName', (_) => nickName, ifAbsent: () => nickName);
      }
      if (profileImage != null) {
        String downloadURL = await _uploadBytes(
            bytes: await profileImage.readAsBytes(), path: 'profile_images');
        updateRef.update('profileImage', (_) => downloadURL,
            ifAbsent: () => downloadURL);
      }
      if (updateRef.keys.isNotEmpty) {
        await user?.update(updateRef);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> setInitial({required Plant plant, required String name}) async {
    try {
      final user = await _fetchUserRef();
      await user?.update({
        'isInitialSettingRequired': false,
        'name': name,
        'nickName': '${plant.name} 농부',
        'plants': FieldValue.arrayUnion([plant.toJson()])
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> setPlace(
      {required String? id,
      required String? newPlantPlace,
      required num? lat,
      required num? lng}) async {
    try {
      final userRef = await _fetchUserRef();
      final user = await userRef?.get();
      List plants = user?.data()?['plants'] ?? [];
      int index = plants.indexWhere((plant) => plant['id'] == id);
      Map<String, dynamic> plant = plants[index];
      plant.update('place', (_) => newPlantPlace);
      plant.update('lat', (_) => lat);
      plant.update('lng', (_) => lng);
      plants[index] = plant;
      await userRef?.update({'plants': plants});
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> setPlant(
      {required String? id,
      required String? newPlantName,
      required String code}) async {
    try {
      final userRef = await _fetchUserRef();
      final user = await userRef?.get();
      List plants = user?.data()?['plants'] ?? [];
      int index = plants.indexWhere((plant) => plant['id'] == id);
      Map<String, dynamic> plant = plants[index];
      plant.update('name', (_) => newPlantName);
      plant.update('code', (_) => code);
      plants[index] = plant;
      await userRef?.update({'plants': plants});
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<AppUser?> getUser({String? userId}) async {
    if (userId == null) {
      try {
        final userRef = await _fetchUserRef();
        final result = await userRef?.get().then((DocumentSnapshot doc) {
          final json = doc.data();
          if (json != null) {
            return AppUser.fromJson(json as Map<String, dynamic>);
          }
        });
        return result;
      } catch (error) {
        throw Exception(error);
      }
    } else {
      try {
        final snapshot = instance.collection('users').doc(userId);
        final result = await snapshot.get().then((DocumentSnapshot doc) {
          final json = doc.data();
          if (json != null) {
            return AppUser.fromJson(json as Map<String, dynamic>);
          }
        });
        return result;
      } catch (error) {
        throw Exception(error);
      }
    }
  }

  @override
  Future<List<Journal?>> getJournals() async {
    try {
      final userRef = await _fetchUserRef();
      final journalRef = instance.collection("journals");

      final journals = await userRef?.get().then((DocumentSnapshot doc) {
        if (doc.data() != null) {
          final json = doc.data() as Map<String, dynamic>;
          final userModel = AppUser.fromJson(json);
          return userModel.journals;
        } else {
          return [];
        }
      });
      List<Journal?> res = [];
      if (journals != null) {
        for (String id in journals) {
          Journal journal = await journalRef.doc(id).get().then((docSnapshot) {
            return Journal.fromJson(docSnapshot.data() as Map<String, dynamic>);
          });
          res.add(journal);
        }
      }
      return res;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<Journal?>> getJournalsByYear({required int year}) async {
    try {
      final userRef = await _fetchUserRef();
      final journalRef = instance.collection("journals");

      final journals = await userRef?.get().then((DocumentSnapshot doc) {
        final json = doc.data() as Map<String, dynamic>;
        final userModel = AppUser.fromJson(json);
        return userModel.journals;
      });
      List<Journal?> res = [];

      if (journals != null) {
        for (String id in journals) {
          Journal journal = await journalRef.doc(id).get().then((docSnapshot) {
            return Journal.fromJson(docSnapshot.data() as Map<String, dynamic>);
          });
          if (journal.date?.year == year) {
            res.add(journal);
          }
        }
      }
      return res;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<Journal?>> createJournal(
      {required String title,
      required String content,
      required DateTime date,
      required bool? isPublic,
      required List<XFile>? images,
      double? temperature,
      int? weatherCode,
      void Function({
        int transferred,
        int totalBytes,
      })? progressCallback}) async {
    try {
      final userRef = await _fetchUserRef();
      final userInfo = await userRef?.get().then((doc) {
        final json = doc.data() as Map<String, dynamic>;
        final userInfo = AppUser.fromJson(json);
        return userInfo;
      });
      final plant = userInfo?.plants.first.name;
      final place = userInfo?.plants.first.place;
      final writerId = userInfo?.id;
      final journalRef = instance.collection("journals");
      var uuid = const Uuid();
      String id = uuid.v4();

      Journal newJournal = Journal(
        id: id,
        title: title,
        content: content,
        plant: plant,
        place: place,
        images: [],
        date: date,
        createdAt: DateTime.now(),
        writer: writerId,
        reportCount: 0,
        isPublic: isPublic,
        temperature: temperature,
        weatherCode: weatherCode,
      );

      if (images != null) {
        final imageUploadTasks = images.map((image) async {
          try {
            final bytes = await image.readAsBytes();
            return _uploadBytes(
                bytes: bytes,
                path: 'images',
                progressCallback: progressCallback);
          } catch (e) {
            return null; // allow partial image upload.
          }
        }).toList();
        final imageURLs = await Future.wait(imageUploadTasks);
        newJournal = newJournal.copyWith(images: imageURLs);
      }
      userRef?.update({
        "journals": FieldValue.arrayUnion([id])
      });
      journalRef.doc(id).set(newJournal.toJson());

      return getJournals();
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<Journal?>> updateJournal({
    required String id,
    required String title,
    required String content,
    required DateTime date,
    required List<ImageType?>? images,
    required bool? isPublic,
    double? temperature,
    int? weatherCode,
    void Function({int transferred, int totalBytes})? progressCallback,
  }) async {
    final journalRef = instance.collection("journals").doc(id);
    List<dynamic> imageURLs = [];
    if (images != null && images.isNotEmpty) {
      final imageUploadTasks = images.map((image) async {
        switch (image) {
          case UrlImage():
            return image.value;
          case XFileImage():
            final bytes = await image.value.readAsBytes();
            String downloadURL = await _uploadBytes(
                path: 'images',
                bytes: bytes,
                progressCallback: progressCallback);
            return downloadURL;
          case null:
            throw UnimplementedError();
        }
      }).toList();
      imageURLs = await Future.wait(imageUploadTasks);
    }
    await journalRef.update({
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'images': imageURLs,
      'isPublic': isPublic,
      'temperature': temperature,
      'weatherCode': weatherCode,
    });
    return await getJournals();
  }

  @override
  Future<List<Journal?>> deleteJournal({required String id}) async {
    try {
      final userRef = await _fetchUserRef();
      final journalRef = instance.collection("journals").doc(id);
      final user =
          await userRef?.get().then((doc) => AppUser.fromJson(doc.data()!));
      final previousJournalList = user?.journals;
      previousJournalList?.remove(id);
      await userRef?.update({'journals': previousJournalList});
      await journalRef.delete();
      return await getJournals();
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<AppUser> getUserById({required String id}) async {
    try {
      final userDocSnapshot = await instance.collection("users").doc(id).get();
      final user = AppUser.fromJson(userDocSnapshot.data()!);
      return user;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> blockUser({required String id}) async {
    try {
      final userRef = await _fetchUserRef();
      userRef?.update({
        'blockedUsers': FieldValue.arrayUnion([id])
      });
    } catch (error) {
      throw Exception(error);
    }
  }
}
