import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/interface/report_interface.dart';
import 'package:farmers_journal/domain/model/report.dart';
import 'package:uuid/uuid.dart';

class FireStoreReportRepository implements ReportRepository {
  FireStoreReportRepository({required this.instance});
  final FirebaseFirestore instance;

  @override
  Future<void> reportJournal(
      {required String journalId,
      required String writerId,
      required String reason}) async {
    final String uuid = const Uuid().v4();
    final newReport = Report(
      id: uuid,
      writerId: writerId,
      journalId: journalId,
      reason: reason,
    ).toJson();
    try {
      instance.collection('reports').doc(uuid).set(newReport);
    } catch (error) {
      throw Exception(error);
    }
  }
}
