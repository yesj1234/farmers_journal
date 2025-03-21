import 'dart:async';
import 'dart:developer';

import 'package:farmers_journal/src/data/firestore_providers.dart';
import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/src/presentation/controller/journal/pagination_state.dart';

part 'pagination_controller.g.dart';

/// {@category Controller}
@riverpod
class PaginationController extends _$PaginationController {
  final List<Journal?> _totalJournals = [];
  Journal? _lastJournal;
  bool noMoreItems = false;
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});
  bool _isFetching = false;
  @override
  PaginationState build() {
    _lastJournal = null;
    _totalJournals.clear(); // re-initialize the _totalJournals
    state = const PaginationState.initial();
    fetchFirstBatch(); // Future that will eventually change the state to data or loading.
    return const PaginationState.initial();
  }

  Future<void> fetchFirstBatch() async {
    try {
      state = const PaginationState.loading();
      final List<Journal> result =
          await _fetchNextItems(lastJournal: _lastJournal);
      updateState(result);
    } catch (error, stackTrace) {
      state = PaginationState.error(error, stackTrace);
    }
  }

  void updateState(List<Journal> journals) async {
    // filter blocked users and blocked journals
    final user = await ref.read(userRepositoryProvider).getUser();
    final blockedJournals = user?.blockedJournals ?? [];
    final blockedUsers = user?.blockedUsers ?? [];

    final filteredJournals = journals
        .where((journal) =>
            !blockedJournals.contains(journal.id) &&
            !blockedUsers.contains(journal.writer))
        .toList();
    if (filteredJournals.isNotEmpty) {
      _lastJournal = journals.last;
    }
    noMoreItems = journals.length < 10;
    final existingIds = _totalJournals.map((journal) => journal?.id).toSet();
    final uniqueJournals = filteredJournals
        .where((journal) => !existingIds.contains(journal.id))
        .toList();
    state = PaginationState.data(_totalJournals..addAll(uniqueJournals));
  }

  Future<List<Journal>> _fetchNextItems({required Journal? lastJournal}) {
    return ref
        .read(journalRepositoryProvider)
        .fetchPaginatedJournals(lastJournal: lastJournal);
  }

  Future<void> fetchNextBatch() async {
    if (_isFetching || _timer.isActive || noMoreItems) {
      return;
    }
    _isFetching = true;
    _timer = Timer(const Duration(milliseconds: 1000), () {});

    if (state == PaginationState.onGoingLoading(_totalJournals)) {
      // Rejecting the concurrent request.
      log("Rejected");
      return;
    }

    state = PaginationState.onGoingLoading(_totalJournals);
    try {
      final result = await _fetchNextItems(lastJournal: _lastJournal);
      updateState(result);
    } catch (error, stackTrace) {
      state = PaginationState.error(error, stackTrace);
    } finally {
      _isFetching = false;
    }
  }

  void updateStateOnJournalReport({required String id}) {
    _totalJournals
        .removeWhere((journal) => journal?.id == id); // Clean up nulls
    state = PaginationState.data(_totalJournals);
  }

  void updateStateOnUserBlock({required String id}) {
    _totalJournals
        .removeWhere((journal) => journal?.writer == id); // Clean up nulls
    state = PaginationState.data(_totalJournals);
  }
}
