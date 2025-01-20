import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/interface/journal_interface.dart';
import 'package:farmers_journal/data/providers.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({super.key});
  static const pageSize = 20;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView> {
  final int pageSize = 20;
  DocumentSnapshot? lastDocument;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      final indexInPage = index % pageSize;

      final AsyncValue<PaginatedJournalResponse> responseAsync = ref.watch(
          getPaginatedJournalsProvider(
              pageSize: pageSize, lastDocument: lastDocument));

      return responseAsync.when(
          error: (err, stack) => Text(err.toString()),
          loading: () => const CircularProgressIndicator(),
          data: (response) {
            lastDocument = response.lastDocument;
            if (indexInPage >= response.journals.length) {
              return null;
            }
            final journal = response.journals[indexInPage];
            return _DayViewCard(journal: journal);
          });
    });
  }
}

class _DayViewCard extends StatelessWidget {
  const _DayViewCard({super.key, required this.journal});
  final Journal journal;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Center(
        child: DayViewCard(
          verticalPadding: 0,
          journal: journal,
        ),
      ),
    );
  }
}
