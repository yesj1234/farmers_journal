import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'firestore_providers.dart';
import 'repositories/excel_repository.dart';
import 'repositories/google_api.dart';
import '../domain/model/user.dart';
import '../domain/firebase/default_image.dart';
import '../../enums.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Future<HSCodeRepository> hsCodeRepository(Ref ref) async {
  final hsCodeRepository = HSCodeRepository(
      instance: FirebaseStorage.instance, filePath: 'hs_code.xlsx');
  await hsCodeRepository.initialize();
  return hsCodeRepository;
}

@Riverpod(keepAlive: true)
class MainViewFilter extends _$MainViewFilter {
  @override
  MainView build() {
    return MainView.day;
  }

  changeDateFilter(MainView view) {
    state = view;
  }
}

@riverpod
Future<DefaultImage> defaultImage(Ref ref) async {
  final repository = ref.read(defaultImageRepositoryProvider);
  return await repository.getDefaultImage();
}

@riverpod
List<int> price(Ref ref) {
  // fetch Price API..
  Random random = Random();
  return List.generate(10, (index) => random.nextInt(6000));
}

final googleAPIProvider = Provider<GoogleAPI>((ref) {
  return GoogleAPI();
});

final loggerProvider = Provider<Logger>((ref) {
  return Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Show method calls in logs
      errorMethodCount: 8, // More stack trace lines for errors
      lineLength: 120, // Max log line length
      colors: true, // Enable colorful logs
      printEmojis: true, // Include emojis
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
});
