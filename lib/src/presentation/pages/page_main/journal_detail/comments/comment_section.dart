import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../controller/comment/comment_controller.dart';
import '../comments.dart';

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
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '댓글 ${comments.length}개',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.grey),
              ),
            ),
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
