import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/data/interface/journal_interface.dart';
import 'package:farmers_journal/data/repositories/excel_repository.dart';
import 'package:farmers_journal/data/repositories/googleAPI.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/enums.dart';
import 'dart:math';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Future<PaginatedJournalResponse> getPaginatedJournals(Ref ref,
    {required DocumentSnapshot? lastDocument, required int pageSize}) {
  final journalRef = ref.watch(journalRepositoryProvider);
  return journalRef.getPaginatedJournals(
      pageSize: pageSize, lastDocument: lastDocument);
}

@Riverpod(keepAlive: true)
HSCodeRepository hsCodeRepository(Ref ref) => HSCodeRepository(
    filePath:
        '/Users/yangseungjun/AndroidStudioProjects/farmers_journal/assets/xls/hs_code.xlsx');

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
