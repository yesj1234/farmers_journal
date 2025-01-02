import 'package:farmers_journal/domain/model/user.dart';
import 'package:farmers_journal/presentation/pages/page_settings/profile_banner.dart';
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
  String? plantName;
  String? newPlantName;

  @override
  void initState() {
    super.initState();
    _user = ref.read(userControllerProvider.notifier).build();
    _user.then((user) {
      setState(() {
        plantName = user?.plants.first.name ?? '';
        plantId = user?.plants.first.id ?? '';
      });
    });
  }

  void onChanged(value) {
    newPlantName = value;
  }

  void onSaved(value) {
    _formKey.currentState?.save();
    newPlantName = value;
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
                        Text('plant: $newPlantName'),
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

  void _updatePlant() {
    ref
        .read(userControllerProvider.notifier)
        .setPlant(id: plantId, newPlantName: newPlantName);
  }

  void onSubmitted() async {
    await _showAlertDialog(context, () {
      _updatePlant();
    }).then((status) {
      if (status) {
        context.go('/main');
      }
    });
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
                title: const Text("작물 변경"),
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
                      const ProfileBanner(),
                      const SizedBox(height: 40),
                      _ProfilePlantForm(
                          onSaved: onSaved,
                          onChanged: onChanged,
                          plantName: plantName),
                    ],
                  ),
                ),
              ),
              floatingActionButton: Container(
                width: 300,
                height: 50,
                decoration: floatingActionButtonDecoration,
                child: Center(
                  child: Text(
                    "변경사항 저장",
                    style: floatingActionButtonTextStyle,
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class _ProfilePlantForm extends StatelessWidget {
  const _ProfilePlantForm({
    super.key,
    required this.plantName,
    required this.onSaved,
    required this.onChanged,
  });
  final String? plantName;
  final void Function(String?) onSaved;
  final void Function(String?) onChanged;
  TextStyle get titleTextStyle => const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      );

  InputDecoration get inputDecoration => const InputDecoration(
        filled: false,
        hintStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("작물 선택", style: titleTextStyle),
        TextFormField(
          initialValue: plantName,
          onChanged: (value) => onChanged(value),
          onSaved: (value) => onSaved(value),
          decoration: inputDecoration.copyWith(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 40),
          ),
        ),
      ],
    );
  }
}
