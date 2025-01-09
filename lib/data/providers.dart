import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/data/repositories/googleAPI.dart';
import 'package:farmers_journal/domain/model/geocoding_response.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/enums.dart';
import 'package:farmers_journal/domain/model/places_autocomplete_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'providers.g.dart';

@Riverpod(keepAlive: true)
class DateFilter extends _$DateFilter {
  @override
  DateView build() {
    return DateView.day;
  }

  changeDateFilter(DateView view) {
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
