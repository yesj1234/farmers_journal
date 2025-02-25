import 'package:farmers_journal/presentation/pages/page_profile/place_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// A layout widget that provides a form for selecting and setting a plant's location.
///
/// The [LayoutSetPlace] widget contains a form with an auto-complete input field
/// for selecting a location. It integrates with [PlaceAutoComplete2] to provide
/// location suggestions dynamically
/// ### Example usage:
/// ```dart
/// LayoutSetPlace(
///   formKey: GlobalKey<FormState>(),
///   onChanged: (value) => print('Place changed: \$value'),
///   onSaved: (value) => print('Place saved: \$value'),
///   plantPlace: 'Garden',
/// )
/// ```

class LayoutSetPlace extends StatelessWidget {
  const LayoutSetPlace(
      {super.key,
      required this.formKey,
      required this.onChanged,
      required this.onSaved,
      required this.plantPlace});
  final GlobalKey<FormState> formKey;
  final void Function(String?) onChanged;
  final void Function(String?) onSaved;
  final String? plantPlace;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Flexible(
            child: PlaceAutoComplete2(
              sessionToken: const Uuid().v4(),
              onChanged: onChanged,
              onSaved: onSaved,
              place: plantPlace,
            ),
          ),
        ],
      ),
    );
  }
}
