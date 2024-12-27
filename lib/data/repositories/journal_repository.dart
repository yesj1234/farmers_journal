import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/interfaces.dart';
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
      await instance.collection("journals").doc(id).get().then(
          (docSnapshot) => result.add(
                Journal.fromJson(docSnapshot.data() as Map<String, dynamic>),
              ),
          onError: (e) => print("Error completing : $e"));
    }
    return result;
  }
}
