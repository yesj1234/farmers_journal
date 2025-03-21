import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/update_journal.dart';

/// {@category Presentation}
class PageUpdateJournal extends StatelessWidget {
  const PageUpdateJournal({super.key, required this.id});
  final String? id;
  TextStyle get textStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(true),
        ),
        title: Text(
          "일지 쓰기",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(child: UpdateJournalForm(id: id!)),
      ),
    );
  }
}
