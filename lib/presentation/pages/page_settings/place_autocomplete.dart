import 'package:farmers_journal/presentation/pages/page_settings/place_map.dart';
import 'package:farmers_journal/presentation/pages/page_settings/place_predictedItem.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/domain/model/places_autocomplete_response.dart';
import 'package:farmers_journal/data/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';

class PlaceAutoComplete2 extends StatefulWidget {
  const PlaceAutoComplete2(
      {super.key,
      required this.sessionToken,
      required this.place,
      required this.onChanged,
      required this.onSaved});
  final void Function(String?) onChanged;
  final void Function(String?) onSaved;
  final String sessionToken;
  final String? place;

  @override
  State<PlaceAutoComplete2> createState() => _PlaceAutoComplete2State();
}

class _PlaceAutoComplete2State extends State<PlaceAutoComplete2> {
  InputDecoration get inputDecoration => const InputDecoration(
        labelText: "위치 선택",
        hintText: "작물의 재배 위치를 검색해 보세요.",
        fillColor: Colors.transparent,
        isDense: true,
      );
  bool isPlaceFinal = false;
  String finalAddress = '';
  String? userInput;

  void _onChanged(String? value) {
    widget.onChanged(value);
    setState(() {
      isPlaceFinal = false;
      userInput = value;
    });
  }

  void _onSaved(String? value) {
    widget.onSaved(value);
    setState(() {
      finalAddress = value ?? '';
      isPlaceFinal = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      isPlaceFinal = widget.place!.isNotEmpty ? true : false;
      finalAddress = widget.place ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        spacing: 10,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null) {
                if (finalAddress.isNotEmpty) {
                  return null;
                }
                return 'Null not allowed';
              }
              if (value.isEmpty) {
                if (finalAddress.isNotEmpty) {
                  return null;
                }
                return "Empty value not allowed";
              }
              return null;
            },
            initialValue: finalAddress,
            textInputAction: TextInputAction.next,
            decoration: inputDecoration,
            onChanged: _onChanged,
            onSaved: _onSaved,
          ),
          isPlaceFinal
              ? Flexible(child: PlaceMap2(finalAddress: finalAddress))
              : userInput != ""
                  ? Flexible(
                      child: PredictedPlaces(
                          sessionToken: widget.sessionToken,
                          place: userInput,
                          onSaved: _onSaved),
                    )
                  : const SizedBox.shrink()
        ],
      ),
    );
  }
}

class PredictedPlaces extends ConsumerWidget {
  const PredictedPlaces(
      {super.key,
      required this.sessionToken,
      required this.place,
      required this.onSaved});

  final String sessionToken;
  final String? place;

  final void Function(String) onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref
            .read(googleAPIProvider)
            .googlePlaceAPI(place ?? '', sessionToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: [
                  for (PlaceAutocompletePrediction prediction
                      in snapshot.data!.predictions)
                    PlaceAutoCompletePredictionItem(
                      onTap: () {
                        onSaved(prediction.description);
                      },
                      description: prediction.description,
                    )
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }
          return const SizedBox.shrink();
        });
  }
}
