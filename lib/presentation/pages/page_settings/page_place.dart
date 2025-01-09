import 'package:farmers_journal/domain/model/user.dart';

import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_settings/place_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class PagePlace extends ConsumerStatefulWidget {
  const PagePlace({super.key});
  @override
  ConsumerState<PagePlace> createState() => _PagePlaceState();
}

class _PagePlaceState extends ConsumerState<PagePlace> {
  BoxDecoration get floatingActionButtonDecoration => BoxDecoration(
        color: const Color.fromRGBO(184, 230, 185, 0.5),
        borderRadius: BorderRadius.circular(10),
      );

  TextStyle get floatingActionButtonTextStyle => const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      );
  late final Future<AppUser?> _user;
  final _formKey = GlobalKey<FormState>();
  String? plantId;
  String? plantPlace;
  String? newPlantPlace;

  @override
  void initState() {
    super.initState();
    _user = ref.read(userControllerProvider.notifier).build();
    _user.then((user) {
      setState(() {
        plantPlace = user?.plants.first.place ?? '';
        plantId = user?.plants.first.id ?? '';
      });
    });
  }

  void onChanged(String? value) {
    newPlantPlace = value;
  }

  void onSaved(String? value) {
    newPlantPlace = value;
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
                        Text('plant: ${newPlantPlace ?? plantPlace}'),
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

  void _updatePlace() {
    ref
        .read(userControllerProvider.notifier)
        .setPlace(id: plantId, newPlantPlace: newPlantPlace);
  }

  void onSubmitted() async {
    if (_formKey.currentState!.validate()) {
      await _showAlertDialog(context, () {
        _updatePlace();
      }).then((status) {
        if (status) {
          context.go('/main');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("위치 설정"),
                actions: [
                  TextButton(
                    onPressed: onSubmitted,
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Form(
                  key: _formKey,
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
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
