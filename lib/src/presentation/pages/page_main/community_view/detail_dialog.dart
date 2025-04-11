import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:farmers_journal/src/domain/model/user.dart';
import 'package:farmers_journal/src/presentation/components/card/card_single.dart';
import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/src/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/report_controller.dart';
import 'package:farmers_journal/src/presentation/controller/user/community_view_controller.dart';
import 'package:farmers_journal/src/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/src/presentation/components/show_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/show_report_dialog.dart';

/// {@category Presentation}
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
    final theme = Theme.of(context);
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
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        info.nickName!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withAlpha((0.5 * 255).toInt())),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Consumer(builder: (context, ref, child) {
                    final userInfo = ref.read(userControllerProvider(null));
                    return userInfo.value!.id == journalInfo.writer
                        ? MyCascadingMenu(
                            menuType: CascadingMenuType.personal,
                            onCallback1: () => context
                                .push('/update/${journalInfo.id}')
                                .then((value) {
                              if (value == true && context.mounted) {
                                context.pop();
                              }
                            }),
                            onCallback2: () {
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
                            onCallback1: () {
                              showCupertinoReportDialog(
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
                                          .reportJournal(
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
                            onCallback2: () => showMyAlertDialog(
                                context: context,
                                type: AlertDialogType.block,
                                cb: () {
                                  ref
                                      .read(
                                          userControllerProvider(null).notifier)
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
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '${journalInfo.plant}, ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                          text: journalInfo.place,
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
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
                      style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  if (journalInfo.content!.isNotEmpty)
                    SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Text(journalInfo.content!),
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
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  ShimmerCircle(size: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      ShimmerRectangle(width: 120, height: 16),
                      ShimmerRectangle(width: 80, height: 14),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ShimmerRectangle(width: 200, height: 16),
              SizedBox(height: 10),
              ShimmerRectangle(width: double.infinity, height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

/// Creates a rectangular shimmer effect widget.
///
/// [width]: The width of the rectangle.
/// [height]: The height of the rectangle.
/// Returns a shimmering rectangle widget.
///
class ShimmerRectangle extends StatelessWidget {
  const ShimmerRectangle(
      {super.key, required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
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
}

/// Creates a circular shimmer effect widget.
///
/// [size]: The diameter of the circle.
/// Returns a shimmering circle widget.
class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
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
