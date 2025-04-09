import 'package:farmers_journal/component.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/journal_detail/comment_input_form.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/journal_detail/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/model/journal.dart';
import '../../../components/show_alert_dialog.dart';
import '../../../components/show_snackbar.dart';
import '../../../controller/journal/journal_controller.dart';
import '../../../controller/journal/pagination_controller.dart';
import '../../../controller/journal/report_controller.dart';
import '../../../controller/user/community_view_controller.dart';
import '../../../controller/user/user_controller.dart';
import '../community_view/detail_dialog.dart';
import 'comments.dart';
import 'image_pageview.dart';

class JournalDetail extends StatelessWidget {
  const JournalDetail({super.key, required this.journal});
  final Journal? journal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, viewport) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewport.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      journal!.images!.isEmpty
                          ? SizedBox(
                              height: MediaQuery.sizeOf(context).height / 2.4,
                              child: Center(
                                child:
                                    Image.asset('assets/icons/leaf_icon.png'),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.sizeOf(context).height / 2.4,
                              child: ImagePageView(journal: journal!),
                            ),
                      SizedBox(
                        height: 55,
                        child: UserProfile(journal: journal!),
                      ),
                      journal!.title!.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: _JournalTitle(title: journal!.title!),
                            ),
                      journal!.content!.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child:
                                  _JournalContent(content: journal!.content!),
                            ),
                      const Divider(),
                      Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Comments(journalId: journal!.id!))
                    ],
                  ),
                ),
              ),
            ),
          ),
          _BuildAppBar(journal: journal!),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CommentInputField(journalId: journal!.id!))
        ],
      ),
    );
  }
}

class _BuildAppBar extends StatelessWidget {
  const _BuildAppBar({super.key, required this.journal});
  final Journal journal;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: journal.images!.isEmpty
                  ? Theme.of(context).primaryColor
                  : Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Consumer(builder: (context, ref, child) {
            final userInfo = ref.read(userControllerProvider);
            return userInfo.value!.id == journal.writer
                ? MyCascadingMenu(
                    color: journal.images!.isEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    menuType: CascadingMenuType.personal,
                    onCallBack1: () => context.push('/update/${journal.id}'),
                    onCallBack2: () {
                      showMyAlertDialog(
                        context: context,
                        type: AlertDialogType.delete,
                        cb: () {
                          ref
                              .read(journalControllerProvider.notifier)
                              .deleteJournal(id: journal.id as String);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                : MyCascadingMenu(
                    color: journal.images!.isEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    menuType: CascadingMenuType.community,
                    onCallBack1: () {
                      showReportDialog(
                          context: context,
                          journalId: journal.id!,
                          onConfirm: (String? value) {
                            try {
                              ref
                                  .read(journalControllerProvider.notifier)
                                  .reportJournal(
                                    id: journal.id!,
                                    userId: userInfo.value!.id,
                                    reason: value ?? '',
                                  );
                              ref
                                  .read(reportControllerProvider.notifier)
                                  .createReport(
                                    journalId: journal.id!,
                                    writerId: userInfo.value!.id,
                                    reason: value ?? '',
                                  );
                              showSnackBar(context,
                                  "신고가 정상적으로 처리되었습니다. 적절한 조치를 취하겠습니다.");
                            } catch (error) {
                              showSnackBar(context,
                                  "신고 요청 처리에 문제가 발생했습니다. 불편을 드려 죄송하며 빠르게 해결하겠습니다. 잠시 후 다시 시도해 주세요.");
                            }
                            Navigator.pop(context);
                          });
                    },
                    onCallBack2: () => showMyAlertDialog(
                        context: context,
                        type: AlertDialogType.block,
                        cb: () {
                          ref
                              .read(userControllerProvider.notifier)
                              .blockUser(id: journal!.writer!);
                          ref.invalidate(communityViewControllerProvider);
                          Navigator.pop(context);
                          ref.invalidate(paginationControllerProvider);
                          showSnackBar(context, "차단되었습니다.");
                        }),
                  );
          })
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  const Comment({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _JournalTitle extends StatelessWidget {
  const _JournalTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _JournalContent extends StatelessWidget {
  const _JournalContent({super.key, required this.content});
  final String content;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Text(content),
      ),
    );
  }
}
