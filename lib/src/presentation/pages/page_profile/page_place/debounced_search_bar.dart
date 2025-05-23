import 'dart:async';
import 'package:flutter/material.dart';

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
/// This means that the original function will be called only after no calls.
/// have been made for the given duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;
  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } on _CancelException {
      return null;
    }
    return function(parameter);
  };
}

class _CancelException implements Exception {
  const _CancelException();
}

class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(_duration, _onComplete);
  }

  late final Timer _timer;
  final Duration _duration = const Duration(milliseconds: 300);
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

class DebouncedSearchBar<T> extends StatefulWidget {
  const DebouncedSearchBar({
    super.key,
    this.hintText,
    required this.resultToString,
    required this.resultTitleBuilder,
    required this.searchFunction,
    this.resultSubtitleBuilder,
    this.resultLeadingBuilder,
    this.onResultSelected,
  });

  final String? hintText;
  final String Function(T result) resultToString;
  final Widget Function(T result) resultTitleBuilder;
  final Widget Function(T result)? resultSubtitleBuilder;
  final Widget Function(T result)? resultLeadingBuilder;
  final Future<Iterable<T>> Function(String query) searchFunction;
  final Function(T result)? onResultSelected;

  @override
  State<StatefulWidget> createState() => DebouncedSearchBarState<T>();
}

class DebouncedSearchBarState<T> extends State<DebouncedSearchBar<T>> {
  final _searchController = SearchController();
  late final _Debounceable<Iterable<T>?, String> _debouncedSearch;

  Future<Iterable<T>> _search(String query) async {
    if (query.isEmpty) {
      return <T>[];
    }
    try {
      final results = await widget.searchFunction(query);
      return results;
    } catch (error) {
      return <T>[];
    }
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = _debounce<Iterable<T>?, String>(_search);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
            controller: controller,
            onTap: () {
              controller.openView();
            },
            leading: IconButton(
              onPressed: () {
                controller.openView();
              },
              icon: const Icon(Icons.search),
            ));
      },
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        final results = await _debouncedSearch(controller.text);
        if (results == null) {
          return <Widget>[];
        }
        return results.map((result) {
          return ListTile(
              title: Text(result as String),
              onTap: () {
                widget.onResultSelected?.call(result);
                controller.closeView(result);
              });
        });
      },
    );
  }
}
