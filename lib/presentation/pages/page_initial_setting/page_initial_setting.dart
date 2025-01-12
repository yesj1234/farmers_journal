import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_profile/place_map.dart';
import 'package:farmers_journal/presentation/pages/page_profile/place_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:farmers_journal/presentation/pages/page_initial_setting/plant_selection.dart'
    show PlantSelection;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

class PageInitialSettingPlant extends StatefulWidget {
  const PageInitialSettingPlant({
    super.key,
    required this.selectedPlant,
    required this.onSelectPlant,
    required this.onChangePlant,
    required this.saveSetting,
  });
  final String selectedPlant;
  final void Function(String) onSelectPlant;
  final void Function(String) onChangePlant;
  final VoidCallback saveSetting;
  @override
  State<StatefulWidget> createState() => _PageInitialSettingPlantState();
}

class _PageInitialSettingPlantState extends State<PageInitialSettingPlant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('작물 선택'),
      ),
      body: SafeArea(
        child: Column(
          spacing: 10,
          children: [
            PlantSelection(
              onChange: widget.onChangePlant,
              onFieldSubmitted: widget.onSelectPlant,
            ),
            TextButton.icon(
              onPressed: () {
                widget.saveSetting();
              },
              label: Text("저장"),
              icon: Icon(Icons.save),
            )
          ],
        ),
      ),
    );
  }
}

class PageInitialSettingPlace extends StatefulWidget {
  const PageInitialSettingPlace(
      {super.key, required this.selectedPlace, required this.onPlaceSelected});
  final String selectedPlace;
  final void Function(String) onPlaceSelected;

  @override
  State<PageInitialSettingPlace> createState() =>
      _PageInitialSettingPlaceState();
}

class _PageInitialSettingPlaceState extends State<PageInitialSettingPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('작물 위치 설정'),
      ),
      body: SafeArea(
        child: Column(
          spacing: 10,
          children: [
            PlaceSearch(onSelect: widget.onPlaceSelected),
            widget.selectedPlace.isNotEmpty
                ? PlaceMap2(
                    finalAddress: widget.selectedPlace,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class PageInitialSetting2 extends ConsumerStatefulWidget {
  const PageInitialSetting2({super.key});

  @override
  ConsumerState<PageInitialSetting2> createState() => _PageViewExampleState();
}

class _PageViewExampleState extends ConsumerState<PageInitialSetting2>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;
  String selectedPlace = '';
  void onSelectPlace(String value) {
    setState(() {
      selectedPlace = value;
    });
  }

  String selectedPlant = '';
  void onChangePlant(String value) {
    selectedPlant = value;
  }

  void onSelectPlant(String value) {
    setState(() {
      selectedPlant = value;
    });
  }

  void _setPlantAndPlace() {
    ref
        .read(userControllerProvider.notifier)
        .setPlantAndPlace(plantName: selectedPlant, place: selectedPlace);
  }

  void onSaveSetting() async {
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
                      Text('Plant: $selectedPlant'),
                      Text('Place: $selectedPlace'),
                    ],
                  ),
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

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView(
          controller: _pageViewController,
          onPageChanged: _handlePageViewChanged,
          children: <Widget>[
            PageInitialSettingPlace(
                selectedPlace: selectedPlace, onPlaceSelected: onSelectPlace),
            PageInitialSettingPlant(
              selectedPlant: selectedPlant,
              onSelectPlant: onSelectPlant,
              onChangePlant: onChangePlant,
              saveSetting: onSaveSetting,
            ),
          ],
        ),
        PageIndicator(
          tabController: _tabController,
          currentPageIndex: _currentPageIndex,
          onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          isOnDesktopAndWeb: _isOnDesktopAndWeb,
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return true;
    }
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.surface,
            selectedColor: colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 2) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
