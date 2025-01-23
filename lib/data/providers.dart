import 'package:farmers_journal/data/firestore_service.dart';

import 'package:farmers_journal/data/repositories/excel_repository.dart';
import 'package:farmers_journal/data/repositories/googleAPI.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/enums.dart';
import 'dart:math';

part 'providers.g.dart';

Future<List<Journal>> paginatedJournals(Ref ref) async {
  final journalRef = ref.watch(journalRepositoryProvider);
  return journalRef.fetchPaginatedJournals();
}

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

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  bool build() {
    FirebaseAuth.instance.userChanges().listen((authUser) async {
      if (authUser == null) {
        state = false;
      } else {
        final AppUser? user = await ref.read(userRepositoryProvider).getUser();
        if (user == null) {
          state = false;
        } else {
          state = true;
        }
      }
    });
    FirebaseAuth.instance.authStateChanges().listen((authUser) async {
      if (authUser == null) {
        state = false;
      } else {
        final AppUser? user = await ref.read(userRepositoryProvider).getUser();
        if (user == null) {
          state = false;
        } else {
          state = true;
        }
      }
    });
    return false;
  }
}
