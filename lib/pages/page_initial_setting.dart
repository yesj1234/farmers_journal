import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:farmers_journal/model/places_autocomplete_response.dart';

class PlaceAutoComplete extends StatefulWidget {
  const PlaceAutoComplete({super.key, required this.sessionToken});
  final String sessionToken;

  @override
  State<StatefulWidget> createState() => _PlaceAutoComplete();
}

class _PlaceAutoComplete extends State<PlaceAutoComplete> {
  GooglePlaceResponse? placeData;

  InputDecoration get inputDecoration => const InputDecoration(
        hintText: "작물의 재배 위치를 검색해보세요",
        fillColor: Colors.transparent,
      );
  void _onChanged(String value) async {
    // call the places api here
    // required parameters
    String? key = dotenv.env['GOOGLE_MAPS_API_KEY'];
    String input = value;
    // Optional parameters

    String language = "ko";
    String sessionToken =
        widget.sessionToken; // to identify autocomplete session for billing
    Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:kr&language=$language&sessiontoken=$sessionToken&key=$key',
    );
    var response = await http.get(url);

    var googlePlaceResponseJson = response.body;

    var parsedJson = jsonDecode(googlePlaceResponseJson);
    var googlePlaceResponse = GooglePlaceResponse.fromJson(parsedJson);
    setState(() {
      placeData = googlePlaceResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Auto complete Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            TextField(
              decoration: inputDecoration,
              onChanged: _onChanged,
            ),
            placeData != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (PlaceAutocompletePrediction prediction
                          in placeData!.predictions)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.place_outlined),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(text: prediction.description),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

class PlaceSelection extends StatelessWidget {
  const PlaceSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Place");
  }
}

class PageInitialSetting extends StatefulWidget {
  const PageInitialSetting({super.key});

  @override
  State<PageInitialSetting> createState() => _PageInitialSetting();
}

class _PageInitialSetting extends State<PageInitialSetting> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(37.4779571, 126.9522871);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Initial Settings"),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.5,
          height: MediaQuery.sizeOf(context).height / 2,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 7.0,
            ),
          ),
        ),
      ),
    );
  }
}
