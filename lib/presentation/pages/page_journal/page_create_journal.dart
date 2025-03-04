import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/presentation/pages/page_journal/create_journal.dart';

class PageCreateJournal extends StatelessWidget {
  const PageCreateJournal({super.key, this.initialDate});
  final DateTime? initialDate;
  TextStyle get textStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop('/main'),
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
        child: Center(child: CreateJournalForm(initialDate: initialDate)),
      ),
    );
  }
}
