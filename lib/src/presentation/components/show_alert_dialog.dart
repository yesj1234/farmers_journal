import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// {@category Presentation}
/// Enum representing the type of alert dialog.
///
/// - [delete]: Used for deletion confirmations.
/// - [block]: Used for blocking confirmations.
enum AlertDialogType {
  delete,
  block,
}

/// Displays a confirmation alert dialog based on the specified [AlertDialogType].
///
/// The dialog prompts the user with a title and description, and provides confirm and cancel actions.
///
/// - [context]: The build context where the dialog should be displayed.
/// - [type]: The type of the alert dialog, either [AlertDialogType.delete] or [AlertDialogType.block].
/// - [cb]: A callback function executed when the confirm button is pressed.
///
Future<void> showMyAlertDialog(
    {required context, required AlertDialogType type, required cb}) async {
  final alertTitle = switch (type) {
    AlertDialogType.delete =>
      const Text('삭제', style: TextStyle(color: Colors.red)),
    AlertDialogType.block =>
      const Text('차단', style: TextStyle(color: Colors.red)),
  };

  final alertChildren = switch (type) {
    AlertDialogType.delete => const [
        Text('정말 삭제 하시겠습니까?'),
        Text('이 동작은 되돌릴 수 없습니다.')
      ],
    AlertDialogType.block => const [
        Text('정말 차단 하시겠습니까?'),
        Text('이 동작은 이 유저의 모든 글을 차단합니다.')
      ],
  };
  final confirmText = switch (type) {
    AlertDialogType.delete => const Text(
        '삭제',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    AlertDialogType.block => const Text(
        '차단',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
  };
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: alertTitle,
          content: SingleChildScrollView(
            child: ListBody(
              children: alertChildren,
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소')),
            TextButton(
              child: confirmText,
              onPressed: () {
                cb();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

Future<void> showMyCupertinoAlertDialog({
  required BuildContext context,
  required AlertDialogType type,
  required VoidCallback cb,
}) async {
  final alertTitle = switch (type) {
    AlertDialogType.delete => const Text('삭제'),
    AlertDialogType.block => const Text('차단'),
  };

  final alertContent = switch (type) {
    AlertDialogType.delete => const Text('정말 삭제 하시겠습니까?\n이 동작은 되돌릴 수 없습니다.'),
    AlertDialogType.block =>
      const Text('정말 차단 하시겠습니까?\n이 동작은 이 유저의 모든 글을 차단합니다.'),
  };

  final confirmText = switch (type) {
    AlertDialogType.delete => '삭제',
    AlertDialogType.block => '차단',
  };

  return showCupertinoDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: alertTitle,
        content: alertContent,
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              cb();
              Navigator.of(context).pop();
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
