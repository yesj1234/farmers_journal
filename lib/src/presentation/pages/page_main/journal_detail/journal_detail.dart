import 'package:farmers_journal/component.dart';
import 'package:farmers_journal/src/presentation/components/handle_journal_delete.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/journal_detail/comment_input_form.dart';
import 'package:farmers_journal/src/presentation/pages/page_main/journal_detail/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/model/journal.dart';
import '../../../components/show_alert_dialog.dart';
import '../../../components/show_report_dialog.dart';
import '../../../components/show_snackbar.dart';
import '../../../controller/journal/journal_controller.dart';
import '../../../controller/journal/pagination_controller.dart';
import '../../../controller/journal/report_controller.dart';
import '../../../controller/user/community_view_controller.dart';
import '../../../controller/user/user_controller.dart';
import 'comments.dart';
import 'image_pageview.dart';

class JournalDetail extends StatelessWidget {
  const JournalDetail({super.key, required this.journal});
  final Journal? journal;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 55,
                          child: UserProfile(journal: journal!),
                        ),
                        const SizedBox(height: 1),
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
                        Comments(journalId: journal!.id!),
                        const SizedBox(height: 90),
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
        bottomNavigationBar: Container(
          height: 1,
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        ),
      ),
    );
  }
}

class _BuildAppBar extends StatelessWidget {
  const _BuildAppBar({required this.journal});
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
            final userInfo = ref.read(userControllerProvider(null));

            return userInfo.value!.id == journal.writer
                ? MyCascadingMenu(
                    color: journal.images!.isEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    menuType: CascadingMenuType.personal,
                    onCallback1: () => context.push('/update/${journal.id}'),
                    onCallback2: () {
                      handleJournalDelete(context, ref, journal.id!);
                    },
                  )
                : MyCascadingMenu(
                    color: journal.images!.isEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    menuType: CascadingMenuType.community,
                    onCallback1: () {
                      showCupertinoReportDialog(
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
                                  .reportJournal(
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
                    onCallback2: () => showMyCupertinoAlertDialog(
                        context: context,
                        type: AlertDialogType.block,
                        cb: () {
                          ref
                              .read(userControllerProvider(null).notifier)
                              .blockUser(id: journal.writer!);
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

class _JournalTitle extends StatelessWidget {
  const _JournalTitle({required this.title});
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
  const _JournalContent({required this.content});
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
