/// {@category Domain}
class Report {
  Report(
      {required this.id,
      required this.journalId,
      required this.writerId,
      required this.reason});

  final String id;
  final String journalId;
  final String writerId;
  final String reason;

  factory Report.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final journalId = json['journalId'] as String;
    final writerId = json['writerId'] as String;
    final reason = json['reason'] as String;

    return Report(
      id: id,
      journalId: journalId,
      writerId: writerId,
      reason: reason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'journalId': journalId,
      'writerId': writerId,
      'reason': reason,
    };
  }
}
