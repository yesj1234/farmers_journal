import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:farmers_journal/domain/model/places_autocomplete_response.dart';
import 'package:farmers_journal/data/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceAutoComplete extends ConsumerStatefulWidget {
  const PlaceAutoComplete({super.key, required this.sessionToken});
  final String sessionToken;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaceAutoComplete();
}

class _PlaceAutoComplete extends ConsumerState<PlaceAutoComplete> {
  String? placeInitialValue;
  bool isPlaceFinal = false;
  String userInput = "";
  String finalAddress = "";
  final TextEditingController textEditingController = TextEditingController();

  InputDecoration get inputDecoration => const InputDecoration(
        labelText: "위치 검색",
        fillColor: Colors.transparent,
        isDense: true,
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void _onChanged(String value) async {
    userInput = value;
    setState(() {
      isPlaceFinal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final googlePlaceResponse =
        ref.watch(googlePlaceAPIProvider(userInput, widget.sessionToken));
    final Widget predictedPlaces = switch (googlePlaceResponse) {
      AsyncData(:final value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (PlaceAutocompletePrediction prediction in value.predictions)
              PlaceAutoCompletePredictionItem(
                onTap: () async {
                  textEditingController.text = prediction.description;
                  setState(() {
                    isPlaceFinal = true;
                    finalAddress = prediction.description;
                  });
                },
                description: prediction.description,
              )
          ],
        ),
      AsyncError() => const SizedBox.shrink(),
      _ => const SizedBox.shrink()
    };

    final geoCodingResponse = ref.watch(geoCodingAPIProvider(finalAddress));
    final Widget finalAddressMap = switch (geoCodingResponse) {
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: PlaceMap(lat: value.lat, lng: value.lng),
        ),
      AsyncError() => const SizedBox.shrink(),
      _ => const SizedBox.shrink()
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(children: [
        TextFormField(
          decoration: inputDecoration,
          onChanged: _onChanged,
          controller: textEditingController,
        ),
        isPlaceFinal
            ? finalAddressMap
            : userInput != ""
                ? predictedPlaces
                : const SizedBox.shrink()
      ]),
    );
  }
}

class PlaceAutoCompletePredictionItem extends StatelessWidget {
  const PlaceAutoCompletePredictionItem(
      {super.key, required this.onTap, required this.description});

  final VoidCallback onTap;
  final String description;

  Shadow get shadow => const Shadow(
        offset: Offset(0.5, 2),
        blurRadius: 30,
        color: Color.fromRGBO(0, 0, 0, 0.5),
      );

  TextStyle get textStyle =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.normal, shadows: [
        shadow,
      ]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(Icons.place, size: 30, shadows: [
              shadow,
            ]),
            const SizedBox(width: 5),
            Expanded(
              child: Text.rich(
                TextSpan(text: description),
                style: textStyle,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
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
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.5,
      height: MediaQuery.sizeOf(context).height / 3,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat as double, widget.lng as double),
          zoom: 15.0,
        ),
      ),
    );
  }
}
