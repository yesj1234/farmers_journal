import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/interface/journal_interface.dart';
import 'package:farmers_journal/domain/model/journal.dart';

/// Implementation of [JournalRepository] using Firebase fire store backend service.
class FireStoreJournalRepository implements JournalRepository {
  final FirebaseFirestore instance;

  FireStoreJournalRepository({required this.instance});

  @override
  Future<Journal> getJournal(String id) async {
    Journal journal;
    return await instance
        .collection("journals")
        .doc(id)
        .get()
        .then((docSnapshot) {
      journal = Journal.fromJson(docSnapshot.data() as Map<String, dynamic>);
      return journal;
    });
  }

  @override
  Future<List<Journal>> getJournals(List<String> ids) async {
    List<Journal> result = [];
    for (String id in ids) {
      await instance.collection("journals").doc(id).get().then((docSnapshot) {
        if (docSnapshot.data() != null) {
          result.add(
            Journal.fromJson(docSnapshot.data() as Map<String, dynamic>),
          );
        }
      }, onError: (e) => print("Error completing : $e"));
    }
    return result;
  }

  @override
  Future<List<Journal>> fetchPaginatedJournals({Journal? lastJournal}) async {
    final journalRef = instance.collection('journals');
    // initial fetching
    if (lastJournal == null) {
      try {
        final journals =
            await journalRef.orderBy('date', descending: true).limit(10).get();
        return journals.docs
            .map((doc) => Journal.fromJson(doc.data()))
            .toList();
      } catch (error) {
        throw Exception(error);
      }
    } else {
      // start after the last journal
      try {
        final journals = await journalRef
            .orderBy('date', descending: true)
            .startAfter([lastJournal.date])
            .limit(10)
            .get();
        return journals.docs
            .map((doc) => Journal.fromJson(doc.data()))
            .toList();
      } catch (error) {
        throw Exception(error);
      }
    }
  }

  @override
  Future<void> reportJournal(
      {required String id, required String userId}) async {
    final journalRef = instance.collection("journals").doc(id);
    final userRef = instance.collection('users').doc(userId);
    try {
      journalRef.update({"reportCount": FieldValue.increment(1)});
      userRef.update({
        "blockedJournals": FieldValue.arrayUnion([id])
      });
    } catch (error) {
      throw Exception(error);
    }
  }
}
