import 'package:farmers_journal/presentation/pages/page_profile/place_map.dart';
import 'package:farmers_journal/presentation/pages/page_profile/place_predicted_item.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/domain/model/places_autocomplete_response.dart';
import 'package:farmers_journal/data/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@category Presentation}
/// A widget for place autocomplete functionality with map preview.
///
/// This widget provides a text field for location input, shows autocomplete
/// predictions as the user types, and displays a map once a place is selected.
class PlaceAutoComplete2 extends StatefulWidget {
  /// Creates a [PlaceAutoComplete2] widget.
  ///
  /// The [sessionToken] is required for Google Places API session management.
  /// The [place] is the initial place value, if any.
  /// The [onChanged] callback is triggered when input changes.
  /// The [onSaved] callback is triggered when a place is confirmed.
  /// The [autoFocus] defaults to false and controls initial field focus.
  const PlaceAutoComplete2({
    super.key,
    required this.sessionToken,
    required this.place,
    required this.onChanged,
    required this.onSaved,
    this.autoFocus = false,
  });

  final void Function(String?) onChanged;
  final void Function(String?) onSaved;
  final String sessionToken;
  final String? place;
  final bool autoFocus;

  @override
  State<PlaceAutoComplete2> createState() => _PlaceAutoComplete2State();
}

/// The state for [PlaceAutoComplete2], managing input and selection logic.
class _PlaceAutoComplete2State extends State<PlaceAutoComplete2> {
  /// Decoration for the text input field.
  InputDecoration get inputDecoration => const InputDecoration(
        labelText: "위치 선택", // "Select Location" in Korean
        hintText:
            "작물의 재배 위치를 검색해 보세요.", // "Search for crop cultivation location"
        fillColor: Colors.transparent,
        isDense: true,
      );

  bool isPlaceFinal = false; // Tracks if a place has been confirmed
  String finalAddress = ''; // Stores the confirmed address
  String? userInput; // Tracks current user input

  /// Handles changes in text input.
  void _onChanged(String? value) {
    widget.onChanged(value);
    setState(() {
      isPlaceFinal = false;
      userInput = value;
    });
  }

  /// Handles saving of a selected place.
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
      isPlaceFinal = widget.place!.isNotEmpty;
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
        spacing: 10, // Spacing between column children
        children: [
          TextFormField(
            autofocus: widget.autoFocus,
            validator: (value) {
              if (value == null) {
                return finalAddress.isNotEmpty ? null : 'Null not allowed';
              }
              if (value.isEmpty) {
                return finalAddress.isNotEmpty
                    ? null
                    : "Empty value not allowed";
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
              ? Flexible(
                  child: PlaceMap2(
                      finalAddress:
                          finalAddress)) // Show map when place is final
              : userInput != "" && userInput != null
                  ? Flexible(
                      child: PredictedPlaces(
                        sessionToken: widget.sessionToken,
                        place: userInput,
                        onSaved: _onSaved,
                      ),
                    ) // Show predictions while typing
                  : const SizedBox.shrink(), // Hide when no input
        ],
      ),
    );
  }
}

/// A widget displaying a list of predicted places based on user input.
///
/// Uses Google Places API via Riverpod to fetch and display autocomplete suggestions.
class PredictedPlaces extends ConsumerWidget {
  /// Creates a [PredictedPlaces] widget.
  ///
  /// The [sessionToken] is required for API session management.
  /// The [place] is the current user input to query predictions for.
  /// The [onSaved] callback is triggered when a prediction is selected.
  const PredictedPlaces({
    super.key,
    required this.sessionToken,
    required this.place,
    required this.onSaved,
  });

  final String sessionToken;
  final String? place;
  final void Function(String) onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      // Fetch place predictions from Google Places API
      future:
          ref.read(googleAPIProvider).googlePlaceAPI(place ?? '', sessionToken),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Hide while loading
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
                      onSaved(prediction.description); // Save selected place
                    },
                    description: prediction.description,
                  ),
              ],
            );
          } else {
            return const SizedBox.shrink(); // Hide if no data
          }
        }
        return const SizedBox.shrink(); // Default case
      },
    );
  }
}
