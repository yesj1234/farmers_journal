import 'dart:developer';
import 'package:farmers_journal/data/providers.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_profile/place_map.dart';
import 'package:farmers_journal/presentation/pages/page_profile/place_predictedItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

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

  @override
  Widget build(BuildContext context) {
    final userRef = ref.watch(userControllerProvider);
    return Scaffold(
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
                  .read(userControllerProvider.notifier)
                  .setPlace(id: plantId, newPlantPlace: selectedPlace)
                  .then((_) {
                context.pop();
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
      body: SafeArea(
        child: Center(
          child: Column(
            spacing: 10,
            children: [
              PlaceSearch(
                onSelect: onSelect,
                autoFocus: true,
              ),
              selectedPlace.isNotEmpty
                  ? PlaceMap2(
                      finalAddress: selectedPlace,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
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
  });
  final void Function(String) onSelect;
  final bool autoFocus;

  @override
  ConsumerState<PlaceSearch> createState() => _PlaceSearchState();
}

class _PlaceSearchState extends ConsumerState<PlaceSearch> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          autoFocus: widget.autoFocus,
          onChanged: (value) {
            controller.openView();
          },
          leading: IconButton(
            onPressed: () {
              controller.openView();
            },
            icon: const Icon(Icons.search),
          ),
        );
      },
      viewHintText: '위치를 검색해 보세요.',
      viewOnSubmitted: (selectedPlace) {
        widget.onSelect(selectedPlace);
      },
      suggestionsBuilder: (context, controller) {
        return ref
            .read(googleAPIProvider)
            .googlePlaceAPI(controller.text, const Uuid().v4())
            .then(
          (response) {
            return response.predictions.map((prediction) {
              return PlaceAutoCompletePredictionItem(
                  onTap: () {
                    controller.closeView(prediction.description);
                    widget.onSelect(prediction.description);
                  },
                  description: prediction.description);
            }).toList();
          },
        );
      },
    );
  }
}
