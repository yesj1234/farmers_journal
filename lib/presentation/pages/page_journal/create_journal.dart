import 'dart:developer';

import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/components/styles/text.dart';
import 'package:farmers_journal/presentation/components/styles/button.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_form_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';

class CreateJournalForm extends StatefulHookConsumerWidget {
  const CreateJournalForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateJournalFormState();
}

class _CreateJournalFormState extends ConsumerState<ConsumerStatefulWidget> {
  final ImagePicker _imagePicker = ImagePicker();

  DateTime? date = DateTime.now();
  String? title;
  String? content;
  List<XFile> images = [];
  void onDatePicked(DateTime? value) {
    setState(() {
      date = value;
    });
  }

  void updateJournalTitle(String? value) {
    title = value;
  }

  void updateJournalContent(String? value) {
    content = value;
  }

  Future<List<XFile>> _pickImage() {
    return _imagePicker.pickMultiImage();
  }

  void deleteImage(int id) {
    setState(() {
      images.removeAt(id);
      if (images.isEmpty) {
        images = [];
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final journalFormController = ref.watch(journalFormControllerProvider);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          _DateForm(
            datePicked: date,
            onDatePicked: onDatePicked,
          ),
          images.isNotEmpty
              ? Flexible(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.1,
                    height: MediaQuery.sizeOf(context).height / 4,
                    child: ImageWidgetLayout(
                      images: images.map((item) => XFileImage(item)).toList(),
                      isEditMode: true,
                      onDelete: deleteImage,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 5),
          _TitleForm(
            title: title,
            onUpdateJournalTitle: updateJournalTitle,
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: _ContentForm(
              content: content,
              onUpdateContent: updateJournalContent,
              onImagePick: () async {
                List<XFile> _images = await _pickImage();
                if (_images.length + images.length > 8) {
                  showSnackBar(context, '사진은 8장 이상을 넘을 수 없습니다.');
                } else {
                  setState(() {
                    images = [...images, ..._images];
                  });
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: journalFormController.maybeWhen(
              loading: null,
              orElse: () {
                return () async {
                  _formKey.currentState?.save();
                  try {
                    await ref
                        .read(journalFormControllerProvider.notifier)
                        .createJournal(
                            title: title ?? '',
                            content: content ?? '',
                            date: date ?? DateTime.now(),
                            images: images)
                        .then(
                      (_) {
                        context.go('/main');
                      },
                      onError: (e, st) => showSnackBar(
                        context,
                        e.toString(),
                      ),
                    );
                  } catch (error) {
                    showSnackBar(context, error.toString());
                  }
                };
              },
            ),
            style: onSaveButtonStyle,
            child: journalFormController.maybeWhen(
                orElse: () => const Text("저장", style: onSaveTextStyle),
                loading: () => const CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class _DatePickerWrapper extends StatelessWidget {
  const _DatePickerWrapper(
      {super.key, required this.child, required this.onDatePicked});
  final ValueChanged<DateTime?> onDatePicked;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(1980),
          lastDate: DateTime(2050),
        );
        if (pickedDate != null) {
          onDatePicked(pickedDate);
        }
      },
      child: child,
    );
  }
}

class _DateForm extends StatelessWidget {
  const _DateForm(
      {super.key, required this.datePicked, required this.onDatePicked});
  final DateTime? datePicked;
  final ValueChanged<DateTime?> onDatePicked;
  TextStyle get textStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.2,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _DatePickerWrapper(
              onDatePicked: onDatePicked,
              child: const SizedBox(
                width: 35,
                child: Icon(
                  Icons.calendar_month,
                  size: 25,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _DatePickerWrapper(
              onDatePicked: onDatePicked,
              child: Text(
                '${datePicked?.year}. ${datePicked?.month}. ${datePicked?.day}.',
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleForm extends StatelessWidget {
  const _TitleForm(
      {super.key, required this.title, required this.onUpdateJournalTitle});
  final String? title;
  final void Function(String?) onUpdateJournalTitle;
  TextStyle get textStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      child: TextFormField(
        initialValue: title,
        onChanged: (value) => onUpdateJournalTitle(value),
        style: textStyle,
        decoration: const InputDecoration(
          hintText: '제목',
          fillColor: Colors.white,
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContentForm extends ConsumerWidget {
  const _ContentForm(
      {super.key,
      required this.content,
      required this.onUpdateContent,
      required this.onImagePick});
  final String? content;

  final void Function(String?) onUpdateContent;
  final void Function() onImagePick;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userControllerProvider);
    AsyncValue<Widget> tag = userRef.whenData((appUser) {
      if (appUser!.plants.isNotEmpty) {
        return FittedBox(
          fit: BoxFit.fitWidth,
          child: Text.rich(
            TextSpan(
              text: '${appUser.plants.first.name}, ',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: appUser.plants.first.place,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      height: MediaQuery.sizeOf(context).height / 3.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tag.isLoading ? const SizedBox.shrink() : tag.value!,
          Expanded(
            child: Stack(
              children: [
                TextFormField(
                  initialValue: content,
                  onChanged: (value) => onUpdateContent(value),
                  decoration: const InputDecoration(
                    hintText: '글쓰기 시작...',
                    fillColor: Colors.white,
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  minLines: 5,
                  maxLines: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      onImagePick();
                    },
                    icon: const Icon(Icons.camera_alt_rounded, size: 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
