import 'package:farmers_journal/data/providers.dart';
import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_initial_setting/place_autocomplete.dart';
import 'package:farmers_journal/presentation/components/plant_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

class PageInitialSetting extends ConsumerStatefulWidget {
  const PageInitialSetting({super.key});

  @override
  ConsumerState<PageInitialSetting> createState() => _PageInitialSettingState();
}

class _PageInitialSettingState extends ConsumerState<PageInitialSetting> {
  int _index = 0;

  // plant related states
  String? code;
  void _setCode(String? value) {
    final hsCodeRef = ref.read(hsCodeRepositoryProvider);
    hsCodeRef.whenData((hsCode) {
      code = hsCode.getHsCode(variety: plant);
    });
  }

  bool _isCode(String? value) {
    return value == null;
  }

  String place = '';
  void setPlace(value) {
    place = value;
  }

  //plant related states
  String plant = '';
  void setPlant(value) {
    plant = value;
    _setCode(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("초기 설정"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Stepper(
          currentStep: _index,
          onStepCancel: onStepCancel,
          onStepContinue: onStepContinue,
          onStepTapped: onStepTapped,
          steps: [
            Step(
              title: const Text("위치 설정"),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height,
                ),
                child: PlaceSetting(
                    sessionToken: Uuid().v4(), onChanged: setPlace),
              ),
              isActive: _index >= 0,
              state: _index == 0 ? StepState.editing : StepState.indexed,
            ),
            Step(
              title: const Text("작물 설정"),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height,
                ),
                child: PlantSelection(
                  onChange: setPlant,
                ),
              ),
              isActive: _index >= 1,
              state: _index == 1 ? StepState.editing : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  //internal functions
  Future<bool> _completeSetting(context) async {
    if (_isCode(code)) {
      showSnackBar(context, '$plant는 등록되지 않은 작물입니다. 검색 결과 중에 선택해주세요.');
      return false;
    } else {
      return await _showAlertDialog(context, () {
        ref
            .read(userControllerProvider.notifier)
            .setPlantAndPlace(plantName: plant, place: place, code: code!);
      });
    }
  }

  Future<bool> _showAlertDialog(context, cb) async {
    return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  '확정',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: '작물: ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: plant,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '위치:',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: place,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      '취소',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      '확정',
                      textAlign: TextAlign.end,
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

  //Stepper related callbacks
  void onStepCancel() {
    if (_index > 0) {
      setState(() {
        _index -= 1;
      });
    }
  }

  void onStepContinue() async {
    if (_index == 1) {
      bool isCompleted = await _completeSetting(context);
      if (isCompleted) {
        context.go('/');
      }
    }
    if (_index <= 0) {
      setState(() {
        _index += 1;
      });
    }
  }

  void onStepTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}

class PlaceSetting extends ConsumerStatefulWidget {
  const PlaceSetting(
      {super.key, required this.sessionToken, required this.onChanged});
  final String sessionToken;
  final void Function(String? value) onChanged;
  @override
  ConsumerState<PlaceSetting> createState() => _PlaceSetting();
}

class _PlaceSetting extends ConsumerState<PlaceSetting> {
  SearchController searchController = SearchController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: searchController,
      builder: (context, SearchController controller) {
        return Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SearchBar(
                controller: controller,
                onTap: () {
                  controller.openView();
                },
                onChanged: (value) {
                  controller.openView();
                  widget.onChanged(value);
                },
                leading: const Icon(Icons.search),
              ),
            ),
            isMapVisible
                ? FutureBuilder(
                    future: ref
                        .read(googleAPIProvider)
                        .geoCodingAPI(controller.text),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: PlaceMap(
                              lat: snapshot.data?.lat, lng: snapshot.data?.lng),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  )
                : const Flexible(
                    child: SizedBox.shrink(),
                  ),
          ],
        );
      },
      suggestionsBuilder: (context, SearchController controller) async {
        final predictedItems = await ref
            .read(googleAPIProvider)
            .googlePlaceAPI(controller.text, widget.sessionToken);
        return predictedItems.predictions
            .map(
              (prediction) => ListTile(
                title: Text(prediction.description),
                onTap: () {
                  controller.closeView(prediction.description);
                  widget.onChanged(prediction.description);
                  setState(() {
                    isMapVisible = true;
                  });
                },
              ),
            )
            .toList();
      },
    );
  }

  bool isMapVisible = false;
}
