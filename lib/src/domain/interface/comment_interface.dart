import '../model/comment.dart';

/// {@category Domain}
/// abstract class for fetching comments from Journal.
abstract class CommentRepository {
  Future<List<Comment>> getComments(String journalId);
  Future<void> addComment(String journalId, Comment comment);
  Future<void> deleteComment({
    required String journalId,
    required String commentId,
  });
}
