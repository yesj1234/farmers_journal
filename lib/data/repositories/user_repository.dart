import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/interfaces.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/plant.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FireStoreUserRepository implements UserRepository {
  final FirebaseFirestore instance;
  FireStoreUserRepository({required this.instance});

  @override
  Future<void> setPlantAndPlace({required Plant plant}) async {
    final user =
        instance.collection('users').doc('otOHyOdeUe97mmVyeIXz'); // REPLACE
    await user.update({
      'plants': FieldValue.arrayUnion([plant.toJson()])
    });
  }

  @override
  Future<void> setPlace(
      {required String? id, required String? newPlantPlace}) async {
    final userRef =
        instance.collection('users').doc('otOHyOdeUe97mmVyeIXz'); // REPLACE
    final user = await userRef.get();
    List plants = user.data()?['plants'] ?? [];
    int index = plants.indexWhere((plant) => plant['id'] == id);
    Map<String, dynamic> plant = plants[index];
    plant.update('place', (_) => newPlantPlace);
    plants[index] = plant;
    await userRef.update({'plants': plants});
  }

  @override
  Future<void> setPlant(
      {required String? id, required String? newPlantName}) async {
    final userRef =
        instance.collection('users').doc('otOHyOdeUe97mmVyeIXz'); // REPLACE
    final user = await userRef.get();
    List plants = user.data()?['plants'] ?? [];
    int index = plants.indexWhere((plant) => plant['id'] == id);
    Map<String, dynamic> plant = plants[index];
    plant.update('name', (_) => newPlantName);
    plants[index] = plant;
    await userRef.update({'plants': plants});
  }

  @override
  Future<AppUser?> getUser() async {
    final user =
        instance.collection("users").doc('otOHyOdeUe97mmVyeIXz'); // REPLACE
    final result = await user.get().then((DocumentSnapshot doc) {
      final json = doc.data() as Map<String, dynamic>;
      final userModel = AppUser.fromJson(json);
      return userModel;
    });
    return result;
  }

  @override
  Future<List<Journal?>> getJournals() async {
    final user =
        instance.collection("users").doc('otOHyOdeUe97mmVyeIXz'); // REPLACE
    final journalRef = instance.collection("journals");

    final journals = await user.get().then((DocumentSnapshot doc) {
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
    // TODO: user authentication
    final userRef =
        instance.collection("users").doc('otOHyOdeUe97mmVyeIXz'); // REPLACE
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
    // 1. remove the journal with journal id
    // 2. remove the id from the user's journal
    // 3. optionally remove the image from the firestorage
    final userRef = instance.collection("users").doc(
        'otOHyOdeUe97mmVyeIXz'); // TODO: Replace with actual logged in user fetching logic
    final journalRef = instance.collection("journals").doc(id);
    final user =
        await userRef.get().then((doc) => AppUser.fromJson(doc.data()!));
    final previousJournalList = user.journals;
    previousJournalList.remove(id);
    await userRef.update({'journals': previousJournalList});
    await journalRef.delete();
    return await getJournals();
  }
}
