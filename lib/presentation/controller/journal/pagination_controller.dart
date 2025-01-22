import 'dart:async';
import 'dart:developer';

import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/presentation/controller/journal/pagination_state.dart';

part 'pagination_controller.g.dart';

@riverpod
class PaginationController extends _$PaginationController {
  final List<Journal> _totalJournals = [];
  bool noMoreItems = false;
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});
  @override
  PaginationState build() {
    fetchFirstBatch(); // Future that will eventually change the state to data or loading.
    return const PaginationState.loading();
  }

  Future<void> fetchFirstBatch() async {
    try {
      state = const PaginationState.loading();
      final List<Journal> result = _totalJournals.isEmpty
          ? await _fetchNextItems(lastJournal: null)
          : await _fetchNextItems(lastJournal: _totalJournals.last);
      updateState(result);
    } catch (error, stackTrace) {
      state = PaginationState.error(error, stackTrace);
    }
  }

  void updateState(List<Journal> journals) {
    noMoreItems = journals.length < 10; //
    if (journals.isEmpty) {
      state = PaginationState.data(_totalJournals);
    } else {
      state = PaginationState.data(_totalJournals..addAll(journals));
    }
  }

  Future<List<Journal>> _fetchNextItems({required Journal? lastJournal}) {
    return ref
        .read(journalRepositoryProvider)
        .fetchPaginatedJournals(lastJournal: lastJournal);
  }

  Future<void> fetchNextBatch() async {
    if (_timer.isActive && _totalJournals.isNotEmpty) {
      return;
    }
    _timer = Timer(const Duration(milliseconds: 1000), () {});

    if (noMoreItems) {
      return;
    }

    if (state == PaginationState.onGoingLoading(_totalJournals)) {
      // Rejecting the concurrent request.
      log("Rejected");
      return;
    }

    state = PaginationState.onGoingLoading(_totalJournals);
    try {
      await Future.delayed(const Duration(seconds: 1));
      final result = await _fetchNextItems(lastJournal: _totalJournals.last);
      updateState(result);
    } catch (error, stackTrace) {
      state = PaginationState.error(error, stackTrace);
    }
  }
}
