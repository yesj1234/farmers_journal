import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/model/comment.dart';
import '../../../controller/comment/comment_controller.dart';
import '../../../controller/user/user_controller.dart';

class CommentInputField extends ConsumerStatefulWidget {
  const CommentInputField(
      {super.key, required this.journalId, required this.journalWriterId});
  final String journalId;
  final String journalWriterId;

  @override
  ConsumerState<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends ConsumerState<CommentInputField> {
  final TextEditingController _controller = TextEditingController();

  bool isSending = false;

  void _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty || isSending) return;

    final user = ref.read(userControllerProvider(null)).value;
    if (user == null) return;

    setState(() => isSending = true);

    final newComment = Comment(
      writerId: user.id,
      content: content,
      createdAt: DateTime.now(),
    );

    await ref
        .read(commentControllerProvider(widget.journalId).notifier)
        .addComment(
            journalId: widget.journalId,
            journalWriterId: widget.journalWriterId,
            comment: newComment);

    _controller.clear();
    setState(() => isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "댓글을 입력하세요.",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  isDense: true,
                  filled: true,
                ),
                minLines: 1,
                maxLines: 4,
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
