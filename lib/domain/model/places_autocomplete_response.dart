import 'package:farmers_journal/enums.dart';

/// PlaceAutocompleteMatchedSubString from [here](https://developers.google.com/maps/documentation/places/web-service/autocomplete?_gl=1*j7omyq*_up*MQ..*_ga*ODQ3MzE0MDQuMTczMjA4MjE0MA..*_ga_NRWSTWS78N*MTczMjA4MjEzOS4xLjEuMTczMjA4MjU1OS4wLjAuMA..#PlaceAutocompleteMatchedSubstring)
class PlaceAutocompleteMatchedSubString {
  PlaceAutocompleteMatchedSubString(
      {required this.length, required this.offset});
  final num length;
  final num offset;

  factory PlaceAutocompleteMatchedSubString.fromJson(
      Map<String, dynamic> data) {
    num length = data['length'] as num;
    num offset = data['offset'] as num;
    return PlaceAutocompleteMatchedSubString(length: length, offset: offset);
  }
}

/// PlaceAutocompleteStructuredFormat from [here](https://developers.google.com/maps/documentation/places/web-service/autocomplete?_gl=1*j7omyq*_up*MQ..*_ga*ODQ3MzE0MDQuMTczMjA4MjE0MA..*_ga_NRWSTWS78N*MTczMjA4MjEzOS4xLjEuMTczMjA4MjU1OS4wLjAuMA..#PlaceAutocompleteStructuredFormat)
class PlaceAutocompleteStructuredFormat {
  PlaceAutocompleteStructuredFormat({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    this.secondaryText,
    this.secondaryTextMatchedSubstrings,
  });

  final String mainText;
  final List<PlaceAutocompleteMatchedSubString> mainTextMatchedSubstrings;
  String? secondaryText;
  List<PlaceAutocompleteMatchedSubString>? secondaryTextMatchedSubstrings;

  factory PlaceAutocompleteStructuredFormat.fromJson(
      Map<String, dynamic> data) {
    String mainText = data['main_text'] as String;
    List<dynamic> mainTextMatchedSubstrings =
        data['main_text_matched_substrings'] as List<dynamic>;

    String? secondaryText;
    List<dynamic>? secondaryTextMatchedSubstrings;
    if (data['secondary_text'] != null) {
      secondaryText = data['secondary_text'] as String;
    }
    if (data['secondary_text_matched_substrings'] != null) {
      secondaryTextMatchedSubstrings =
          data['secondary_text_matched_substrings'] as List<dynamic>;
    }

    return PlaceAutocompleteStructuredFormat(
      mainText: mainText,
      mainTextMatchedSubstrings: mainTextMatchedSubstrings
          .map((subString) => PlaceAutocompleteMatchedSubString.fromJson(
              subString as Map<String, dynamic>))
          .toList(),
      secondaryText: secondaryText,
      secondaryTextMatchedSubstrings: secondaryTextMatchedSubstrings
          ?.map((subString) => PlaceAutocompleteMatchedSubString.fromJson(
              subString as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// PlaceAutocompleteTerm from [here](https://developers.google.com/maps/documentation/places/web-service/autocomplete?_gl=1*j7omyq*_up*MQ..*_ga*ODQ3MzE0MDQuMTczMjA4MjE0MA..*_ga_NRWSTWS78N*MTczMjA4MjEzOS4xLjEuMTczMjA4MjU1OS4wLjAuMA..#PlaceAutocompleteTerm)
class PlaceAutocompleteTerm {
  PlaceAutocompleteTerm({
    required this.offset,
    required this.value,
  });
  final num offset;
  final String value;

  factory PlaceAutocompleteTerm.fromJson(Map<String, dynamic> data) {
    num offset = data['offset'] as num;
    String value = data['value'] as String;

    return PlaceAutocompleteTerm(offset: offset, value: value);
  }
}

/// PlaceAutocompletePrediction from [here](https://developers.google.com/maps/documentation/places/web-service/autocomplete?_gl=1*j7omyq*_up*MQ..*_ga*ODQ3MzE0MDQuMTczMjA4MjE0MA..*_ga_NRWSTWS78N*MTczMjA4MjEzOS4xLjEuMTczMjA4MjU1OS4wLjAuMA..#PlaceAutocompletePrediction)
class PlaceAutocompletePrediction {
  PlaceAutocompletePrediction({
    required this.description,
    required this.matchedSubstrings,
    required this.structuredFormatting,
    required this.terms,
    this.distanceMeters,
    this.placeId,
    this.types,
  });

  final String description;
  final List<PlaceAutocompleteMatchedSubString> matchedSubstrings;
  final PlaceAutocompleteStructuredFormat structuredFormatting;
  final List<PlaceAutocompleteTerm> terms;
  final int? distanceMeters;
  final String? placeId;
  final List<dynamic>? types;

  factory PlaceAutocompletePrediction.fromJson(Map<String, dynamic> data) {
    String description = data['description'] as String;
    List<dynamic> matchedSubstrings =
        data['matched_substrings'] as List<dynamic>;
    Map<String, dynamic> structuredFormatting =
        data['structured_formatting'] as Map<String, dynamic>;
    List<dynamic> terms = data['terms'] as List<dynamic>;
    int? distanceMeters;
    String? placeId;
    List<dynamic>? types;

    if (data['distanceMeters'] != null) {
      distanceMeters = data['distance_meters'] as int;
    }
    if (data['place_id'] != null) {
      placeId = data['place_id'] as String;
    }
    if (data['types'] != null) {
      types = data['types'] as List<dynamic>;
    }
    return PlaceAutocompletePrediction(
      description: description,
      matchedSubstrings: matchedSubstrings
          .map((subStrings) => PlaceAutocompleteMatchedSubString.fromJson(
              subStrings as Map<String, dynamic>))
          .toList(),
      structuredFormatting:
          PlaceAutocompleteStructuredFormat.fromJson(structuredFormatting),
      terms: terms.map((term) => PlaceAutocompleteTerm.fromJson(term)).toList(),
      distanceMeters: distanceMeters,
      placeId: placeId,
      types: types,
    );
  }
}

class GooglePlaceResponse {
  GooglePlaceResponse({
    required this.predictions,
    required this.status,
    this.errorMessage,
    this.infoMessages,
  });
  final List<PlaceAutocompletePrediction> predictions;
  final PlaceAutocompleteStatus status;
  String? errorMessage;
  List<String>? infoMessages;

  factory GooglePlaceResponse.fromJson(Map<String, dynamic> data) {
    final predictions = data['predictions'] as List<dynamic>;
    final PlaceAutocompleteStatus status = switch (data['status']) {
      'OK' => PlaceAutocompleteStatus.OK,
      'ZERO_RESULTS' => PlaceAutocompleteStatus.ZERO_RESULTS,
      'INVALID_REQUEST' => PlaceAutocompleteStatus.INVALID_REQUEST,
      'OVER_QUERY_LIMIT' => PlaceAutocompleteStatus.OVER_QUERY_LIMIT,
      'REQUEST_DENIED' => PlaceAutocompleteStatus.REQUEST_DENIED,
      'UNKNOWN_ERROR' => PlaceAutocompleteStatus.UNKNOWN_ERROR,
      // TODO: Handle this case.
      Object() => throw UnimplementedError(),
      // TODO: Handle this case.
      null => throw UnimplementedError(),
    };

    String? errorMessage;
    List<String>? infoMessages;
    if (data['error_message'] != null) {
      errorMessage = data['error_message'] as String;
    }
    if (data['info_messages'] != null) {
      infoMessages = data['info_messages'] as List<String>;
    }
    return GooglePlaceResponse(
        predictions: predictions
            .map((prediction) => PlaceAutocompletePrediction.fromJson(
                prediction as Map<String, dynamic>))
            .toList(),
        status: status,
        errorMessage: errorMessage,
        infoMessages: infoMessages);
  }
}
