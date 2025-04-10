import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/interface/report_interface.dart';
import '../../domain/model/report.dart';

/// {@category Data}
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

  @override
  Future<void> reportComment(
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
