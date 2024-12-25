import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/domain/model/geocoding_response.dart';
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
Future<int> journalCount(Ref ref) async {
  final userRepo = ref.watch(userRepositoryProvider);
  final user = await userRepo.getUser();
  return user?.journals != null && user!.journals.isNotEmpty
      ? user.journals.length
      : 0;
}

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
