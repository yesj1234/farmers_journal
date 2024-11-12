import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:farmers_journal/enums.dart';

part 'providers.g.dart';

@riverpod
class DateFilter extends _$DateFilter {
  @override
  DateView build() {
    return DateView.day;
  }

  changeDateFilter(DateView view) {
    state = view;
  }
}
