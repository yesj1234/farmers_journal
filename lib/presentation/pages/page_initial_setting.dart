import 'package:flutter/material.dart';
import 'package:farmers_journal/presentation/components/place_autocomplete.dart'
    show PlaceAutoComplete;
import 'package:farmers_journal/presentation/components/plant_selection.dart'
    show PlantSelection;
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

/// TODO:
/// 1. Animate adding the PlantSelection being added.
/// 2. Implement the searching logic of the plant selection.
/// 3. Implement the onComplete callback of the initialSetting page.
/// for example, setting the user's location and plant.

class PageInitialSetting extends StatefulWidget {
  const PageInitialSetting({super.key});

  @override
  State<PageInitialSetting> createState() => _PageInitialSettingState();
}

class _PageInitialSettingState extends State<PageInitialSetting> {
  TextStyle get floatingActionButtonTextStyle => const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );

  ElevatedButton get floatingActionButton => ElevatedButton(
        onPressed: () => setState(() {
          if (isPlaceSelected) {
            context.go('/main');
          }
          isPlaceSelected = true;
        }),
        style: const ButtonStyle(
          fixedSize: WidgetStatePropertyAll(
            Size(200, 50),
          ),
        ),
        child: Text(
          isPlaceSelected ? "완료" : "다음",
          style: floatingActionButtonTextStyle,
        ),
      );

  bool isPlaceSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Initial setting page"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            isPlaceSelected
                ? const Center(child: PlantSelection())
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            Expanded(
              child: PlaceAutoComplete(sessionToken: const Uuid().v4()),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
