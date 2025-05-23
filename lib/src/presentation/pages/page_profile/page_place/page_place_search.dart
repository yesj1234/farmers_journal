import 'dart:async';

import 'package:farmers_journal/src/data/providers.dart';
import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/src/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/src/presentation/pages/page_profile/page_place/debounced_search_bar.dart';
import 'package:farmers_journal/src/presentation/pages/page_profile/page_place/place_map.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/model/places_autocomplete_response.dart'
    show GooglePlaceResponse;

/// {@category Presentation}
class PagePlaceSearch extends ConsumerStatefulWidget {
  const PagePlaceSearch(
      {super.key, required this.actionText, required this.actionIcon});
  final String actionText;
  final IconData actionIcon;
  @override
  ConsumerState<PagePlaceSearch> createState() => _PagePlaceSearchState();
}

class _PagePlaceSearchState extends ConsumerState<PagePlaceSearch> {
  String selectedPlace = '';
  void onSelect(String value) {
    setState(() {
      selectedPlace = value;
    });
  }

  num? placeLat;
  num? placeLng;
  void setLatLng(num? lat, num? lng) {
    placeLat = lat;
    placeLng = lng;
  }

  @override
  void initState() {
    super.initState();
    _handleLocationAuthorization();
  }

  Future<void> _handleLocationAuthorization() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final LocationSettings bestLocationSettings =
          LocationSettings(accuracy: LocationAccuracy.best);

      final bestPosition = await Geolocator.getCurrentPosition(
        locationSettings: bestLocationSettings,
      );

      placeLat = bestPosition.latitude;
      placeLng = bestPosition.longitude;

      if (kDebugMode) {
        debugPrint('-' * 10);
        debugPrint(bestPosition.latitude.toString());
        debugPrint(bestPosition.longitude.toString());
      }

      final placeMarks = await placemarkFromCoordinates(
          bestPosition.latitude, bestPosition.longitude);
      if (placeMarks.isNotEmpty) {
        final placeMark = placeMarks.first;
        if (kDebugMode) {
          final GeoLocatorHelper currentLocation = GeoLocatorHelper(
              lat: bestPosition.latitude, lng: bestPosition.longitude);
          await currentLocation.debugGeoLocation();
        }
        final address =
            '${placeMark.country} ${placeMark.administrativeArea} ${placeMark.name}';
        setState(() {
          selectedPlace = address;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRef = ref.watch(userControllerProvider(null));
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "위치 변경",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () async {
                final plantId = userRef.value?.plants[0].id;
                await ref
                    .read(userControllerProvider(null).notifier)
                    .setPlace(
                        id: plantId,
                        newPlantPlace: selectedPlace,
                        lat: placeLat,
                        lng: placeLng)
                    .then((_) {
                  if (context.mounted) {
                    showSnackBar(context, '위치가 $selectedPlace(으)로 변경되었습니다.');
                    context.pop();
                  }
                });
              },
              icon: Icon(
                widget.actionIcon,
                size: 20,
              ),
              iconAlignment: IconAlignment.end,
              label: Text(
                widget.actionText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.bottomRight,
                    image: Svg('assets/svgs/layer_1.svg'),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  spacing: 10,
                  children: [
                    PlaceSearch(
                      initialPlace: selectedPlace,
                      onSelect: onSelect,
                      autoFocus: true,
                    ),
                    selectedPlace.isNotEmpty
                        ? PlaceMap2(
                            finalAddress: selectedPlace,
                            setLatLng: setLatLng,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceSearch extends ConsumerStatefulWidget {
  const PlaceSearch({
    super.key,
    required this.onSelect,
    this.autoFocus = false,
    this.initialPlace = '',
  });
  final void Function(String) onSelect;

  final bool autoFocus;
  final String initialPlace;

  @override
  ConsumerState<PlaceSearch> createState() => _PlaceSearchState();
}

class _PlaceSearchState extends ConsumerState<PlaceSearch> {
  Future<Iterable<String>> searchPlace(String query) async {
    if (query.isEmpty) {
      return <String>[];
    }
    try {
      final response = await ref
          .read(googleAPIProvider)
          .googlePlaceAPI(query, const Uuid().v4());
      final results = response.predictions.map((prediction) {
        return prediction.description;
      }).toList();
      return results;
    } catch (e, _) {
      if (kDebugMode) {
        debugPrint(e.toString());
        return <String>[];
      }
    }
    return <String>[];
  }

  @override
  Widget build(BuildContext context) {
    return DebouncedSearchBar(
        hintText: '위치를 검색해 보세요.',
        onResultSelected: widget.onSelect,
        resultToString: (String result) => result,
        resultTitleBuilder: (String result) => Text(result),
        searchFunction: searchPlace);
  }
}

/// Helper class to debug location properties from geocoding response
/// import 'package:geocoding/geocoding.dart';
class GeoLocatorHelper {
  const GeoLocatorHelper({
    required this.lat,
    required this.lng,
  });
  final double lat;
  final double lng;

  static const properties = [
    'name',
    'street',
    'isoCountryCode',
    'country',
    'postalCode',
    'administrativeArea',
    'locality',
    'subLocality',
    'thoroughfare',
    'subThoroughfare'
  ];

  Future<void> debugGeoLocation() async {
    final placeMarks = await placemarkFromCoordinates(lat, lng);
    final placeMark = placeMarks.first;
    final values = [
      placeMark.name,
      placeMark.street,
      placeMark.isoCountryCode,
      placeMark.country,
      placeMark.postalCode,
      placeMark.administrativeArea,
      placeMark.locality,
      placeMark.subLocality,
      placeMark.thoroughfare,
      placeMark.subThoroughfare
    ];
    if (kDebugMode) {
      for (var property in properties.asMap().entries) {
        int idx = property.key;
        debugPrint('${property.value}: ${values[idx]}');
      }
    }
  }
}
