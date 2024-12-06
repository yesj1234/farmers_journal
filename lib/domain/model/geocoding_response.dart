import 'package:farmers_journal/enums.dart';

class GeocodingResponse {
  final List<dynamic> results;
  final ResponseStatus status;

  GeocodingResponse({required this.results, required this.status});

  factory GeocodingResponse.fromJson(Map<String, dynamic> data) {
    List<dynamic> results = data['results'] as List<dynamic>;
    ResponseStatus status = switch (data['status']) {
      'OK' => ResponseStatus.OK,
      'ZERO_RESULTS' => ResponseStatus.ZERO_RESULTS,
      'INVALID_REQUEST' => ResponseStatus.INVALID_REQUEST,
      'OVER_QUERY_LIMIT' => ResponseStatus.OVER_QUERY_LIMIT,
      'REQUEST_DENIED' => ResponseStatus.REQUEST_DENIED,
      'UNKNOWN_ERROR' => ResponseStatus.UNKNOWN_ERROR,
      // TODO: Handle this case.
      Object() => throw UnimplementedError(),
      // TODO: Handle this case.
      null => throw UnimplementedError(),
    };

    return GeocodingResponse(
        results: results
            .map((result) => GeocodingResponseResult.fromJson(result))
            .toList(),
        status: status);
  }
}

class GeocodingResponseResult {
  GeocodingResponseResult({
    required this.types,
    required this.formattedAddress,
    required this.geometry,
  });

  final List<dynamic>? types;
  final String? formattedAddress;
  final Geometry geometry;

  factory GeocodingResponseResult.fromJson(Map<String, dynamic> data) {
    List<dynamic> types = data['types'] as List<dynamic>;
    String formattedAddress = data['formatted_address'] as String;
    Map<String, dynamic> geometry = data['geometry'] as Map<String, dynamic>;
    return GeocodingResponseResult(
        types: types,
        formattedAddress: formattedAddress,
        geometry: Geometry.fromJson(geometry));
  }
}

class Geometry {
  Geometry({
    required this.location,
    required this.locationType,
    required this.viewPort,
  });

  final MyLatLng? location;
  final LocationType locationType;
  final ViewPort viewPort;

  factory Geometry.fromJson(Map<String, dynamic> data) {
    Map<String, dynamic> location = data['location'] as Map<String, dynamic>;
    LocationType locationType = data['location_type'] as LocationType;
    Map<String, dynamic> viewPort = data['viewport'] as Map<String, dynamic>;

    return Geometry(
        location: MyLatLng.fromJson(location),
        locationType: locationType,
        viewPort: ViewPort.fromJson(viewPort));
  }
}

class ViewPort {
  ViewPort({required this.northEast, required this.southWest});
  final MyLatLng northEast;
  final MyLatLng southWest;

  factory ViewPort.fromJson(Map<String, dynamic> data) {
    Map<String, dynamic> northEast = data['northeast'] as Map<String, dynamic>;
    Map<String, dynamic> southWest = data['southwest'] as Map<String, dynamic>;
    return ViewPort(
        northEast: MyLatLng.fromJson(northEast),
        southWest: MyLatLng.fromJson(southWest));
  }
}

class MyLatLng {
  MyLatLng({required this.lat, required this.lng});

  final num lat;
  final num lng;

  factory MyLatLng.fromJson(Map<String, dynamic> data) {
    num lat = data['lat'] as num;
    num lng = data['lng'] as num;
    return MyLatLng(lat: lat, lng: lng);
  }
}

typedef LocationType = String;
