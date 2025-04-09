import '../../../domain/model/comment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/src/data/firestore_providers.dart';

part 'comment_controller.g.dart';

/// {@category Controller}
@riverpod
class CommentController extends _$CommentController {
  @override
  FutureOr<List<Comment>> build(String journalId) async {
    final repo = ref.read(commentRepositoryProvider);
    return await repo.getComments(journalId);
  }

  Future<void> addComment(
      {required String journalId, required Comment comment}) async {
    final repo = ref.read(commentRepositoryProvider);
    try {
      await repo.addComment(journalId, comment);
      state = AsyncValue.data(await repo.getComments(journalId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteComment(
      {required String journalId, required String commentId}) async {
    final repo = ref.read(commentRepositoryProvider);
    try {
      await repo.deleteComment(journalId: journalId, commentId: commentId);
      state = AsyncValue.data(await repo.getComments(journalId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
