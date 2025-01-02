import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/data/interfaces.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/plant.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class FireStoreUserRepository implements UserRepository {
  final FirebaseFirestore instance;
  final Ref _ref;
  FireStoreUserRepository(
    this._ref, {
    required this.instance,
  });
  Future<DocumentReference<Map<String, dynamic>>> _fetchUserRef() async {
    final User? userData = _ref.read(authRepositoryProvider).getCurrentUser();
    if (userData == null) {
      throw Exception('Auth Exception');
    } else {
      return instance.collection('users').doc(userData.uid);
    }
  }

  @override
  Future<void> setPlantAndPlace({required Plant plant}) async {
    try {
      final user = await _fetchUserRef();
      await user.update({
        'isInitialSettingRequired': false,
        'plants': FieldValue.arrayUnion([plant.toJson()])
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> setPlace(
      {required String? id, required String? newPlantPlace}) async {
    try {
      final userRef = await _fetchUserRef();
      final user = await userRef.get();
      List plants = user.data()?['plants'] ?? [];
      int index = plants.indexWhere((plant) => plant['id'] == id);
      Map<String, dynamic> plant = plants[index];
      plant.update('place', (_) => newPlantPlace);
      plants[index] = plant;
      await userRef.update({'plants': plants});
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> setPlant(
      {required String? id, required String? newPlantName}) async {
    try {
      final userRef = await _fetchUserRef();
      final user = await userRef.get();
      List plants = user.data()?['plants'] ?? [];
      int index = plants.indexWhere((plant) => plant['id'] == id);
      Map<String, dynamic> plant = plants[index];
      plant.update('name', (_) => newPlantName);
      plants[index] = plant;
      await userRef.update({'plants': plants});
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<AppUser?> getUser() async {
    try {
      final userRef = await _fetchUserRef();
      final result = await userRef.get().then((DocumentSnapshot doc) {
        final json = doc.data() as Map<String, dynamic>;
        final userModel = AppUser.fromJson(json);
        print(userModel);
        return userModel;
      });
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<Journal?>> getJournals() async {
    try {
      final userRef = await _fetchUserRef();
      final journalRef = instance.collection("journals");

      final journals = await userRef.get().then((DocumentSnapshot doc) {
        final json = doc.data() as Map<String, dynamic>;
        final userModel = AppUser.fromJson(json);
        return userModel.journals;
      });
      List<Journal?> res = [];
      for (String id in journals) {
        Journal journal = await journalRef.doc(id).get().then((docSnapshot) {
          return Journal.fromJson(docSnapshot.data() as Map<String, dynamic>);
        });
        res.add(journal);
      }
      return res;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child("images/$fileName");

    UploadTask uploadTask = storageRef.putFile(imageFile);

    TaskSnapshot snapshot = await uploadTask;

    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Future<List<Journal?>> createJournal(
      {required String title,
      required String content,
      required DateTime date,
      required List<String>? images}) async {
    try {
      final userRef = await _fetchUserRef();
      final journalRef = instance.collection("journals");
      var uuid = const Uuid();
      String id = uuid.v4();
      if (images != null) {
        List<String>? imageURLs = [];
        for (String path in images) {
          String downloadURL = await _uploadImage(File(path));
          imageURLs.add(downloadURL);
        }
        final newJournal = Journal(
            id: id,
            title: title,
            content: content,
            images: imageURLs,
            createdAt: date);
        userRef.update({
          "journals": FieldValue.arrayUnion([id])
        });
        journalRef.doc(id).set(newJournal.toJson());
      } else {
        final newJournal = Journal(
            id: id,
            title: title,
            content: content,
            images: images,
            createdAt: date);
        userRef.update({
          "journals": FieldValue.arrayUnion([id])
        });
        journalRef.doc(id).set(newJournal.toJson());
      }
      return getJournals();
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<Journal?>> updateJournal(
      {required String id,
      required String title,
      required String content,
      required DateTime date,
      required List<String?>? images}) async {
    final journalRef = instance.collection("journals").doc(id);

    if (images != null && images.isNotEmpty) {
      List<String>? imageURLs = [];
      for (String? path in images) {
        if (path != null && path.isNotEmpty) {
          if (path.startsWith('http')) {
            imageURLs.add(path);
          } else {
            String downloadURL = await _uploadImage(File(path));
            imageURLs.add(downloadURL);
          }
        }
      }
      journalRef.update(Journal(
              id: id,
              title: title,
              content: content,
              images: imageURLs,
              createdAt: date)
          .toJson());
    } else {
      await journalRef.update(Journal(
              id: id,
              title: title,
              content: content,
              images: images,
              createdAt: date)
          .toJson());
    }
    return await getJournals();
  }

  @override
  Future<List<Journal?>> deleteJournal({required String id}) async {
    try {
      final userRef = await _fetchUserRef();
      final journalRef = instance.collection("journals").doc(id);
      final user =
          await userRef.get().then((doc) => AppUser.fromJson(doc.data()!));
      final previousJournalList = user.journals;
      previousJournalList.remove(id);
      await userRef.update({'journals': previousJournalList});
      await journalRef.delete();
      return await getJournals();
    } catch (error) {
      throw Exception(error);
    }
  }
}
