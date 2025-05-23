import 'package:farmers_journal/controller.dart';
import 'package:farmers_journal/src/data/firestore_providers.dart';
import 'package:farmers_journal/src/presentation/controller/journal/day_view_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/journal_form_controller_state.dart';
import 'package:farmers_journal/src/presentation/controller/journal/month_view_controller.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/image_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_form_controller.g.dart';

/// {@category Controller}
@riverpod
class JournalFormController extends _$JournalFormController {
  @override
  JournalFormControllerState build() {
    return const JournalFormControllerState.initial();
  }

  Future<void> createJournal({
    required String title,
    required String content,
    required DateTime date,
    required List<XFile>? images,
    required bool? isPublic,
    double? temperature,
    int? weatherCode,
    void Function({
      int transferred,
      int totalBytes,
    })? progressCallback,
  }) async {
    state = const JournalFormControllerState.loading();
    if (title.isEmpty && content.isEmpty && images != null && images.isEmpty) {
      state = const JournalFormControllerState.initial();
      throw Exception(
        "제목, 내용, 이미지 모두 빈 값을 사용할 수 없습니다.",
      );
    } else {
      await ref.read(userRepositoryProvider).createJournal(
          title: title,
          content: content,
          date: date,
          images: images,
          isPublic: isPublic,
          temperature: temperature,
          weatherCode: weatherCode,
          progressCallback: progressCallback);
      state = const JournalFormControllerState.done();
    }
    ref.invalidate(dayViewControllerProvider);
    ref.invalidate(weekViewControllerProvider);
    ref.invalidate(monthViewControllerProvider);
  }

  Future<void> updateJournal({
    required String id,
    required String title,
    required String content,
    required DateTime date,
    required List<ImageType?>? images,
    required bool? isPublic,
    double? temperature,
    int? weatherCode,
    void Function({
      int transferred,
      int totalBytes,
    })? progressCallback,
  }) async {
    state = const JournalFormControllerState.loading();
    if (title.isEmpty && content.isEmpty && images != null && images.isEmpty) {
      state = const JournalFormControllerState.initial();
      throw Exception(
        "제목, 내용, 이미지 모두 빈 값을 사용할 수 없습니다.",
      );
    } else {
      await ref.read(userRepositoryProvider).updateJournal(
          id: id,
          title: title,
          content: content,
          date: date,
          images: images,
          isPublic: isPublic,
          temperature: temperature,
          weatherCode: weatherCode,
          progressCallback: progressCallback);
    }
    ref.invalidate(dayViewControllerProvider);
    ref.invalidate(weekViewControllerProvider);
    ref.invalidate(monthViewControllerProvider);
  }
}
