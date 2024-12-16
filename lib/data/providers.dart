import 'package:farmers_journal/domain/model/geocoding_response.dart';
import 'package:farmers_journal/presentation/controller/journal_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/enums.dart';
import 'package:farmers_journal/domain/model/places_autocomplete_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'providers.g.dart';

@riverpod
int journalCount(Ref ref) {
  final journalController = ref.watch(journalControllerProvider);
  return AsyncData(journalController).when(
      data: (data) => data.value != null ? data.value!.length : 0,
      error: (e, st) => 0,
      loading: () => 0);
}

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

@riverpod
class DatePicked extends _$DatePicked {
  @override
  DateTime? build() {
    return DateTime.now();
  }

  updatePickedDate(DateTime? pickedDate) {
    if (pickedDate == null) {
      state = DateTime.now();
    } else {
      state = pickedDate;
    }
  }
}

@riverpod
class NewJournalTitle extends _$NewJournalTitle {
  @override
  String? build() {
    return '';
  }

  updateJournalTitle(String? title) {
    if (title == null || title.isEmpty) {
      state = '';
    } else {
      state = title;
    }
  }
}

@riverpod
class NewJournalContent extends _$NewJournalContent {
  @override
  String? build() {
    return '';
  }

  updateJournalContent(String? content) {
    if (content == null || content.isEmpty) {
      state = '';
    } else {
      state = content;
    }
  }
}

@riverpod
List<int> price(Ref ref) {
  // fetch Price API..
  Random random = Random();
  return List.generate(10, (index) => random.nextInt(6000));
}

@riverpod
Future<GooglePlaceResponse> googlePlaceAPI(
    Ref ref, String place, String token) async {
  String? key = dotenv.env['GOOGLE_MAPS_API_KEY'];
  String input = place;
  String language = "ko";
  String sessionToken = token; // to identify autocomplete session for billing
  Uri url = Uri.parse(
    'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:kr&language=$language&sessiontoken=$sessionToken&key=$key',
  );
  var response = await http.get(url);
  var googlePlaceResponse = response.body;
  var parsedJson = jsonDecode(googlePlaceResponse);
  var googlePlaceResponseJson = GooglePlaceResponse.fromJson(parsedJson);
  return googlePlaceResponseJson;
}

@riverpod
Future<MyLatLng> geoCodingAPI(Ref ref, String address) async {
  String? key = dotenv.env['GOOGLE_MAPS_API_KEY'];

  Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$key');
  var response = await http.get(url);
  var geoCodingResponse = response.body;
  var parsedJson = jsonDecode(geoCodingResponse);
  var geoCodingResponseJson = GeocodingResponse.fromJson(parsedJson);

  return geoCodingResponseJson.results.first.geometry.location;
}
