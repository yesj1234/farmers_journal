import 'package:farmers_journal/data/providers.dart';
import 'package:farmers_journal/presentation/components/plant_selection.dart';
import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PagePlant extends ConsumerStatefulWidget {
  const PagePlant({super.key});
  @override
  ConsumerState<PagePlant> createState() => _PagePlantState();
}

class _PagePlantState extends ConsumerState<PagePlant> {
  Future<bool> _showAlertDialog(context, cb) async {
    return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('확정'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('작물: $plant'),
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
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '작물 변경',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: onSave,
              child: const Text(
                '저장',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
      body: PlantSelection(onChange: setPlant),
    );
  }

  String plant = '';
  void setPlant(value) {
    plant = value;
    _setCode(value);
  }

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

  void onSave() async {
    if (_isCode(code)) {
      showSnackBar(context, '$plant는 등록되지 않은 작물입니다. 검색 결과 중에 선택해주세요.');
    } else {
      bool isCompleted = await _showAlertDialog(context, () async {
        final userRef = ref.read(userControllerProvider);
        await ref.read(userControllerProvider.notifier).setPlant(
            id: userRef.value!.plants[0].id, newPlantName: plant, code: code!);
      });
      if (isCompleted) {
        context.go('/main/profile');
      }
    }
  }
}
