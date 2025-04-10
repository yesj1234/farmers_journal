import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Displays a dialog for reporting a journal with selectable reasons.
///
/// [context]: The build context to show the dialog in.
/// [journalId]: The ID of the journal being reported.
/// [onConfirm]: Callback function invoked with the selected reason when confirmed.

/// Displays a Cupertino-style dialog for reporting a journal with selectable reasons.
///
/// [context]: The build context to show the dialog in.
/// [journalId]: The ID of the journal being reported.
/// [onConfirm]: Callback function invoked with the selected reason when confirmed.
void showCupertinoReportDialog({
  required BuildContext context,
  required String journalId,
  required void Function(String? value) onConfirm,
}) {
  final reasons = [
    '스팸 또는 사기',
    '혐오 발언 또는 차별',
    '부적절한 콘텐츠',
    '허위 정보 또는 가짜 뉴스',
    '폭력 또는 유해 콘텐츠',
    '기타',
  ];

  String selectedReason = reasons[0];
  final TextEditingController customReasonController = TextEditingController();

  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) {
        return CupertinoAlertDialog(
          title: const Text(
            '게시물 신고',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Column(
            spacing: 12,
            children: [
              SizedBox(
                height: selectedReason == '기타' ? 43 : 100,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedReason != null
                        ? reasons.indexOf(selectedReason!)
                        : 0,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedReason = reasons[index];
                    });
                  },
                  children: reasons
                      .map(
                        (r) => Center(
                          child: Text(r),
                        ),
                      )
                      .toList(),
                ),
              ),
              if (selectedReason == '기타') ...[
                CupertinoTextField(
                  controller: customReasonController,
                  placeholder: '신고 사유를 입력해주세요.',
                  minLines: 1,
                  maxLines: 3,
                  padding: const EdgeInsets.all(12),
                ),
              ],
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('취소', style: Theme.of(context).textTheme.bodyLarge),
              onPressed: () => Navigator.pop(ctx),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('확인'),
              onPressed: () {
                final reason = selectedReason == '기타'
                    ? customReasonController.text
                    : selectedReason;

                if (reason != null && reason.isNotEmpty) {
                  onConfirm(reason);
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        );
      },
    ),
  );
}
