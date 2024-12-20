import 'package:farmers_journal/domain/model/journal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/presentation/components/create_journal.dart';
import 'package:farmers_journal/presentation/components/update_journal.dart';

class PageCreateJournal extends StatelessWidget {
  const PageCreateJournal({super.key, required this.id});
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
          onPressed: () => context.go('/main'),
        ),
        title: const Text("일지 쓰기"),
      ),
      body: SafeArea(
        child: Center(
          child: id != null
              ? UpdateJournalForm(id: id)
              : const CreateJournalForm(),
        ),
      ),
    );
  }
}
