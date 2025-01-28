import 'package:flutter/material.dart';

Future<void> showDeleteAlertDialog(context, cb) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제', style: TextStyle(color: Colors.red)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('정말 삭제하시겠습니까?'),
                Text('이 동작은 되돌릴 수 없습니다.')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소')),
            TextButton(
              child: const Text(
                '삭제',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                cb();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

Future<void> showBlockAlertDialog(context, cb) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('차단', style: TextStyle(color: Colors.red)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('정말 차단하시겠습니까?'),
                Text('이 동작은 되돌릴 수 없습니다.')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소')),
            TextButton(
              child: const Text(
                '차단',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                cb();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
