import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/model/comment.dart';
import '../../../controller/comment/comment_controller.dart';
import '../../../controller/user/user_controller.dart';

class CommentInputField extends ConsumerStatefulWidget {
  const CommentInputField({super.key, required this.journalId});
  final String journalId;

  @override
  ConsumerState<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends ConsumerState<CommentInputField> {
  final TextEditingController _controller = TextEditingController();
  bool isSending = false;

  void _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty || isSending) return;

    final user = ref.read(userControllerProvider).value;
    if (user == null) return;

    setState(() => isSending = true);

    final newComment = Comment(
      writerId: user.id,
      content: content,
      createdAt: DateTime.now(),
    );

    await ref
        .read(commentControllerProvider(widget.journalId).notifier)
        .addComment(journalId: widget.journalId, comment: newComment);

    _controller.clear();
    setState(() => isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "댓글을 입력하세요...",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _submit,
              icon: isSending
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
