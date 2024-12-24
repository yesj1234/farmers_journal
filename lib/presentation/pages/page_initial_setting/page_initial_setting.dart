import 'package:farmers_journal/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/presentation/pages/page_initial_setting/place_autocomplete.dart'
    show PlaceAutoComplete;
import 'package:farmers_journal/presentation/pages/page_initial_setting/plant_selection.dart'
    show PlantSelection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

class PageInitialSetting extends ConsumerStatefulWidget {
  const PageInitialSetting({super.key});

  @override
  ConsumerState<PageInitialSetting> createState() => _PageInitialSettingState();
}

class _PageInitialSettingState extends ConsumerState<PageInitialSetting> {
  TextStyle get floatingActionButtonTextStyle => const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );

  bool isPlaceSelected = false;

  final _formKey = GlobalKey<FormState>();
  String? place;
  String? plant;
  void onPlaceSelected(value) {
    place = value;
    setState(() {
      isPlaceSelected = true;
    });
  }

  void _setPlantAndPlace() {
    ref
        .read(userControllerProvider.notifier)
        .setPlantAndPlace(plantName: plant ?? '', place: place ?? '');
  }

  void onPlantSelected(value) async {
    plant = value;

    await _showDeleteAlertDialog(context, () {
      _setPlantAndPlace();
    }).then((status) {
      if (status) {
        context.go('/main');
      }
    });
  }

  Future<bool> _showDeleteAlertDialog(context, cb) async {
    return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('확정', style: TextStyle(color: Colors.red)),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Plant: $plant'),
                      Text('Place: $place'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    child: const Text(
                      '확정',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      cb();
                    },
                  )
                ],
              );
            }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Initial setting page"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              isPlaceSelected
                  ? Center(
                      child: PlantSelection(
                        onFieldSubmitted: onPlantSelected,
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              Expanded(
                child: PlaceAutoComplete(
                  sessionToken: const Uuid().v4(),
                  onFieldSubmitted: onPlaceSelected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
