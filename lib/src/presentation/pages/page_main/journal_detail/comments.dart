import 'package:farmers_journal/src/presentation/controller/comment/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../domain/model/comment.dart';
import '../../../controller/user/user_controller.dart';

class Comments extends ConsumerWidget {
  final String journalId;

  const Comments({super.key, required this.journalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(commentControllerProvider(journalId));

    return commentsAsync.when(
      data: (comments) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('댓글 ${comments.length}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...comments.map((comment) =>
                CommentTile(comment: comment, journalId: journalId)),
          ],
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => const Text('댓글을 불러오지 못했습니다.'),
    );
  }
}

class CommentTile extends ConsumerWidget {
  final Comment comment;
  final String? journalId;
  const CommentTile(
      {super.key, required this.comment, required this.journalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider).value;
    final isMyComment = user?.id == comment.writerId;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.content ?? ''),
            Text(
              DateFormat('M/d HH:mm').format(comment.createdAt!.toLocal()) ??
                  '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            )
          ],
        ),
        isMyComment
            ? IconButton(
                onPressed: () => _confirmDelete(context, ref),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('댓글 삭제'),
              content: const Text('정말 이 댓글을 삭제하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(commentControllerProvider(comment.id!).notifier)
                        .deleteComment(
                          commentId: comment.id!,
                          journalId: journalId!,
                        );
                    if (context.mounted) {
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('삭제', style: TextStyle(color: Colors.red)),
                ),
              ],
            ));
  }
}
