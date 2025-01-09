import 'dart:developer';
import 'package:farmers_journal/data/providers.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_settings/place_map.dart';
import 'package:farmers_journal/presentation/pages/page_settings/place_predictedItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class PageTemp extends ConsumerStatefulWidget {
  const PageTemp(
      {super.key, required this.actionText, required this.actionIcon});
  final String actionText;
  final IconData actionIcon;
  @override
  ConsumerState<PageTemp> createState() => _PageTempState();
}

class _PageTempState extends ConsumerState<PageTemp> {
  String selectedPlace = '';
  void onSelect(String value) {
    setState(() {
      selectedPlace = value;
    });
  }

  Future<bool> _showAlertDialog(context, cb) async {
    return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('확정'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('plant: $selectedPlace'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        cb();
                      },
                      child: const Text('확정'),
                    )
                  ]);
            }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final userRef = ref.watch(userControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("작물 위치 설정"),
        actions: [
          TextButton.icon(
            onPressed: () {
              final plantId = userRef.value?.plants[0].id;
              _showAlertDialog(context, () {
                ref
                    .read(userControllerProvider.notifier)
                    .setPlace(id: plantId, newPlantPlace: selectedPlace);
              }).then((v) {
                if (v) {
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
      body: SafeArea(
        child: Center(
          child: Column(
            spacing: 10,
            children: [
              PlaceSearch(onSelect: onSelect),
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
  const PlaceSearch({super.key, required this.onSelect});
  final void Function(String) onSelect;

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
          onChanged: (value) {
            controller.openView();
          },
          leading: IconButton(
              onPressed: () {
                controller.openView();
              },
              icon: const Icon(Icons.search)),
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
            .then((response) {
          return response.predictions.map((prediction) {
            return PlaceAutoCompletePredictionItem(
                onTap: () {
                  controller.closeView(prediction.description);
                  widget.onSelect(prediction.description);
                },
                description: prediction.description);
          }).toList();
        });
      },
    );
  }
}
