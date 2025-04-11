import 'package:farmers_journal/src/data/providers.dart';
import 'package:farmers_journal/src/presentation/components/plant_selection.dart';
import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/src/presentation/controller/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// {@category Presentation}
class PagePlant extends ConsumerStatefulWidget {
  const PagePlant({super.key});
  @override
  ConsumerState<PagePlant> createState() => _PagePlantState();
}

class _PagePlantState extends ConsumerState<PagePlant> {
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
      body: PlantSelection(
        onChange: setPlant,
        autoFocus: true,
      ),
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
      final userRef = ref.read(userControllerProvider(null));
      await ref.read(userControllerProvider(null).notifier).setPlant(
          id: userRef.value!.plants[0].id, newPlantName: plant, code: code!);
      showSnackBar(context, '작물이 $plant로 변경되었습니다.');
      context.pop();
    }
  }
}
