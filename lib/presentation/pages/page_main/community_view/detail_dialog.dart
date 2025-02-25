import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';
import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/presentation/controller/journal/report_controller.dart';
import 'package:farmers_journal/presentation/controller/user/community_view_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/components/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

/// A dialog widget displaying detailed journal information for a user.
///
/// This widget shows a user's profile, journal details like plant and place,
/// and provides options to edit/delete (for the journal writer) or report/block
/// (for community members).
class DataStateDialog extends StatelessWidget {
  /// The user information to display in the dialog.
  final AppUser info;

  /// The journal information to display in the dialog.
  final Journal journalInfo;

  /// Creates a [DataStateDialog] with required user and journal info.
  const DataStateDialog({
    super.key,
    required this.info,
    required this.journalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(info.profileImage!),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        info.nickName!,
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Consumer(builder: (context, ref, child) {
                    final userInfo = ref.read(userControllerProvider);
                    return userInfo.value!.id == journalInfo.writer
                        ? MyCascadingMenu(
                            menuType: CascadingMenuType.personal,
                            onCallBack1: () => context
                                .push('/update/${journalInfo.id}')
                                .then((value) {
                              if (value == true && context.mounted) {
                                context.pop();
                              }
                            }),
                            onCallBack2: () {
                              showMyAlertDialog(
                                context: context,
                                type: AlertDialogType.delete,
                                cb: () {
                                  ref
                                      .read(journalControllerProvider.notifier)
                                      .deleteJournal(
                                          id: journalInfo.id as String);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          )
                        : MyCascadingMenu(
                            menuType: CascadingMenuType.community,
                            onCallBack1: () {
                              showReportDialog(
                                  context: context,
                                  journalId: journalInfo.id!,
                                  onConfirm: (String? value) {
                                    try {
                                      ref
                                          .read(journalControllerProvider
                                              .notifier)
                                          .reportJournal(
                                            id: journalInfo.id!,
                                            userId: userInfo.value!.id,
                                            reason: value ?? '',
                                          );
                                      ref
                                          .read(
                                              reportControllerProvider.notifier)
                                          .createReport(
                                            journalId: journalInfo.id!,
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
                                      .blockUser(id: journalInfo.writer!);
                                  ref.invalidate(
                                      communityViewControllerProvider);
                                  Navigator.pop(context);
                                  ref.invalidate(paginationControllerProvider);
                                  showSnackBar(context, "차단되었습니다.");
                                }),
                          );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${journalInfo.plant}, ',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: journalInfo.place,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (journalInfo.title!.isNotEmpty)
                    Text(
                      journalInfo.title!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (journalInfo.content!.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Text(journalInfo.content!),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _formatDate(journalInfo.date!)!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats a [DateTime] into a localized Korean date string.
  ///
  /// For example, "2월 24일 월요일" for February 24th, a Monday.
  ///
  /// [date]: The date to format.
  /// Returns a formatted string or null if the date is invalid.
  String? _formatDate(DateTime date) {
    final localDateTime = date.toLocal();
    final weekDayOrder = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
    int month = localDateTime.month;
    int day = localDateTime.day;
    int weekDay = localDateTime.weekday;

    return '$month월 $day일 ${weekDayOrder[weekDay - 1]}';
  }
}

/// A dialog widget displaying a shimmer loading effect for journal data.
///
/// This is used as a placeholder while data is being fetched.
class ShimmerLoadingStateDialog extends StatelessWidget {
  /// Creates a [ShimmerLoadingStateDialog].
  const ShimmerLoadingStateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _shimmerCircle(size: 50),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerRectangle(width: 120, height: 16),
                      const SizedBox(height: 8),
                      _shimmerRectangle(width: 80, height: 14),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _shimmerRectangle(width: 200, height: 16),
              const SizedBox(height: 10),
              _shimmerRectangle(width: double.infinity, height: 14),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a rectangular shimmer effect widget.
  ///
  /// [width]: The width of the rectangle.
  /// [height]: The height of the rectangle.
  /// Returns a shimmering rectangle widget.
  Widget _shimmerRectangle({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Creates a circular shimmer effect widget.
  ///
  /// [size]: The diameter of the circle.
  /// Returns a shimmering circle widget.
  Widget _shimmerCircle({required double size}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// A dialog widget displaying an error state for journal data loading.
///
/// Shown when an error occurs during data retrieval.
class ErrorStateDialog extends StatelessWidget {
  /// Creates an [ErrorStateDialog].
  const ErrorStateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(height: 10),
            Text(
              "Error occurred while loading data!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a dialog for reporting a journal with selectable reasons.
///
/// [context]: The build context to show the dialog in.
/// [journalId]: The ID of the journal being reported.
/// [onConfirm]: Callback function invoked with the selected reason when confirmed.
void showReportDialog({
  required BuildContext context,
  required String journalId,
  required void Function(String? value) onConfirm,
}) {
  String? selectedReason;
  final TextEditingController customReasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text('게시물 신고'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                hint: const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('신고 사유 선택'),
                ),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: 'Spam',
                    child: FittedBox(
                        fit: BoxFit.fitWidth, child: Text('스팸 또는 사기')),
                  ),
                  DropdownMenuItem(
                    value: 'Hate Speech or Discrimination',
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('혐오 발언 또는 차별'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Inappropriate Content',
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('부적절한 콘텐츠'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Misinformation or Fake News',
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('허위 정보 또는 가짜 뉴스'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Violence or Harm',
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('폭력 또는 유채 콘텐츠'),
                    ),
                  ),
                  DropdownMenuItem(value: 'Other', child: Text('기타')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedReason = value;
                  });
                },
              ),
              if (selectedReason == 'Other')
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: customReasonController,
                    decoration: const InputDecoration(
                      labelText: '신고 사유를 입력해주세요.',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final reason = selectedReason == 'Other'
                    ? customReasonController.text
                    : selectedReason;
                if (reason != null) {
                  onConfirm(reason);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('제출'),
            ),
          ],
        );
      },
    ),
  );
}
