import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/interface/journal_interface.dart';
import 'package:farmers_journal/domain/model/journal.dart';

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
  Future<PaginatedJournalResponse> getPaginatedJournals(
      {required int pageSize,
      required DocumentSnapshot<Object?>? lastDocument}) async {
    try {
      final CollectionReference journalRef = instance.collection('journals');
      Query query = journalRef.orderBy('createdAt');
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      QuerySnapshot querySnapshot = await query.limit(pageSize).get();
      DocumentSnapshot? newLastDocument =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
      final data = querySnapshot.docs
          .map((doc) => Journal.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return (journals: data, lastDocument: newLastDocument);
    } catch (error) {
      throw Exception(error);
    }
  }
}
