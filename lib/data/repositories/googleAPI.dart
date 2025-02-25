import 'dart:convert';
import 'package:farmers_journal/domain/model/geocoding_response.dart';
import 'package:farmers_journal/domain/model/places_autocomplete_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Dart class for Google APIs.
class GoogleAPI {
  Future<GooglePlaceResponse> googlePlaceAPI(String place, String token) async {
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

  Future<MyLatLng> geoCodingAPI(String address) async {
    String? key = dotenv.env['GOOGLE_MAPS_API_KEY'];

    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$key');
    var response = await http.get(url);
    var geoCodingResponse = response.body;
    var parsedJson = jsonDecode(geoCodingResponse);
    var geoCodingResponseJson = GeocodingResponse.fromJson(parsedJson);

    return geoCodingResponseJson.results.first.geometry.location;
  }
}
