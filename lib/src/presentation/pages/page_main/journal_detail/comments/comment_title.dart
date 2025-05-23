// comment_tile.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../domain/model/comment.dart';
import '../../../../components/card/card_single.dart';
import '../../../../components/show_alert_dialog.dart';
import '../../../../components/show_report_dialog.dart';
import '../../../../components/show_snackbar.dart';
import '../../../../controller/comment/comment_controller.dart';
import '../../../../controller/journal/journal_controller.dart';
import '../../../../controller/journal/pagination_controller.dart';
import '../../../../controller/journal/report_controller.dart';
import '../../../../controller/user/community_view_controller.dart';
import '../../../../controller/user/user_controller.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  final String? journalId;
  const CommentTile(
      {super.key, required this.comment, required this.journalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider(comment.writerId)).value;
    final isMyComment = user?.id == comment.writerId;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: SvgPicture.asset(
                        'assets/svgs/anonymous.svg',
                        semanticsLabel: 'Logo',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user?.name ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.content ?? ''),
                Text(
                  DateFormat('M/d HH:mm').format(comment.createdAt!.toLocal()),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          isMyComment
              ? IconButton(
                  onPressed: () => _confirmDelete(context, ref),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: MyCascadingMenu(
                    color: Colors.grey,
                    onCallback1: () {
                      showCupertinoReportDialog(
                        context: context,
                        journalId: journalId!,
                        onConfirm: (String? value) {
                          try {
                            ref
                                .read(journalControllerProvider.notifier)
                                .reportJournal(
                                  id: journalId!,
                                  userId: user!.id,
                                  reason: value ?? '',
                                );
                            ref
                                .read(reportControllerProvider.notifier)
                                .reportJournal(
                                  journalId: journalId!,
                                  writerId: user.id,
                                  reason: value ?? '',
                                );
                            showSnackBar(
                                context, "신고가 정상적으로 처리되었습니다. 적절한 조치를 취하겠습니다.");
                          } catch (error) {
                            showSnackBar(context,
                                "신고 요청 처리에 문제가 발생했습니다. 불편을 드려 죄송하며 빠르게 해결하겠습니다. 잠시 후 다시 시도해 주세요.");
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                    onCallback2: () => showMyCupertinoAlertDialog(
                      context: context,
                      type: AlertDialogType.block,
                      cb: () {
                        ref
                            .read(userControllerProvider(null).notifier)
                            .blockUser(id: comment.writerId!);
                        ref.invalidate(communityViewControllerProvider);
                        Navigator.pop(context);
                        ref.invalidate(paginationControllerProvider);
                        showSnackBar(context, "차단되었습니다.");
                      },
                    ),
                    onCallback1Name: '댓글 신고',
                    menuType: CascadingMenuType.community,
                  ),
                ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('댓글 삭제'),
        content: const Text('정말 이 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(commentControllerProvider(comment.id!).notifier)
                    .deleteComment(
                      commentId: comment.id!,
                      journalId: journalId!,
                    );
                ref.invalidate(commentControllerProvider(journalId!));
                if (context.mounted) {
                  Navigator.pop(ctx);
                }
              } catch (e) {
                if (context.mounted) {
                  showSnackBar(context, '댓글 삭제에 실패했습니다.');
                }
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
