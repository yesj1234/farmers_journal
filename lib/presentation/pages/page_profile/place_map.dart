import 'package:farmers_journal/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// {@category Presentation}
class PlaceMap2 extends ConsumerWidget {
  const PlaceMap2({super.key, required this.finalAddress, this.initialValue});
  final String finalAddress;
  final String? initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.read(googleAPIProvider).geoCodingAPI(finalAddress),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data == null) {
              return const SizedBox.shrink();
            }
            return PlaceMap(lat: snapshot.data?.lat, lng: snapshot.data?.lng);
          }
          return const SizedBox.shrink();
        });
  }
}

class PlaceMap extends StatefulWidget {
  const PlaceMap({super.key, required this.lat, required this.lng});
  final num? lat;
  final num? lng;

  @override
  State<PlaceMap> createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width / 1.2,
        maxHeight: MediaQuery.sizeOf(context).height / 3,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat as double, widget.lng as double),
            zoom: 15.0,
          ),
        ),
      ),
    );
  }
}
