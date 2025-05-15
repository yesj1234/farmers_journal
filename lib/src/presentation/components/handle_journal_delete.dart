import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/journal/journal_controller.dart';

Future<bool?> handleJournalDelete(
    BuildContext context, WidgetRef ref, String journalId) async {
  final isDeleted = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) {
        return CupertinoPopupSurface(
          isSurfacePainted: true,
          child: Container(
            height: 180,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 4,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:
                            CupertinoTheme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: FittedBox(
                              child: Text(
                                "이 입력 항목을 삭제하겠습니까? 이 동작은 취소할 수 없습니다.",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              ref
                                  .read(journalControllerProvider.notifier)
                                  .deleteJournal(id: journalId);
                              Navigator.of(context).pop(
                                  true); // return true and dismiss the popup
                            },
                            child: const SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  '입력 항목 삭제',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: () => Navigator.of(context)
                        .pop(false), // return false and dismiss popup
                    color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
  return isDeleted;
}
