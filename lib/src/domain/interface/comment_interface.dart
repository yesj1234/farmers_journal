import '../model/comment.dart';

/// {@category Domain}
/// abstract class for fetching comments from Journal.
abstract class CommentRepository {
  Future<List<Comment>> getComments(String journalId);
  Future<void> addComment(
      {required String journalId,
      required String journalWriterId,
      required Comment comment});
  Future<void> deleteComment({
    required String journalId,
    required String commentId,
  });
}
