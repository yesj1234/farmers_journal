import 'package:flutter/material.dart';

enum AlertDialogType {
  delete,
  block,
  report,
}

Future<void> showMyAlertDialog(
    {required context, required AlertDialogType type, required cb}) async {
  final alertTitle = switch (type) {
    AlertDialogType.delete =>
      const Text('삭제', style: TextStyle(color: Colors.red)),
    AlertDialogType.block =>
      const Text('차단', style: TextStyle(color: Colors.red)),
    AlertDialogType.report =>
      const Text('신고', style: TextStyle(color: Colors.red)),
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
    AlertDialogType.report => const [
        Text('정말 신고하시겠습니까?'),
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
    AlertDialogType.report => const Text(
        '신고',
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
