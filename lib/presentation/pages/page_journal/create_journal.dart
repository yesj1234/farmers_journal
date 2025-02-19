import 'package:farmers_journal/presentation/components/journal_form_content.dart';
import 'package:farmers_journal/presentation/components/journal_form_date.dart';
import 'package:farmers_journal/presentation/components/journal_form_title.dart';
import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/components/styles/button.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_form_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';

// TODO: Refactoring needed. Merge create journal and update journal page.
class CreateJournalForm extends StatefulHookConsumerWidget {
  const CreateJournalForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateJournalFormState();
}

class _CreateJournalFormState extends ConsumerState<ConsumerStatefulWidget> {
  bool get isFormEmpty {
    return images.isEmpty &&
        titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty;
  }

  final ImagePicker _imagePicker = ImagePicker();

  DateTime? date = DateTime.now();

  List<XFile> images = [];

  void onDatePicked(DateTime? value) {
    setState(() {
      date = value;
    });
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  void deleteImage(int id) {
    setState(() {
      images.removeAt(id);
    });
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final journalFormController = ref.watch(journalFormControllerProvider);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        spacing: 10,
        children: [
          DateForm(
            datePicked: date,
            onDatePicked: onDatePicked,
          ),
          images.isNotEmpty
              ? SizedBox(
                  width: MediaQuery.sizeOf(context).width - 42,
                  height: MediaQuery.sizeOf(context).height / 5,
                  child: CustomImageWidgetLayout(
                    images: images.map((item) => XFileImage(item)).toList(),
                    isEditMode: true,
                    onDelete: deleteImage,
                  ),
                )
              : const SizedBox.shrink(),
          TitleForm(
            controller: titleController,
            notValid: isFormEmpty,
          ),
          Expanded(
            flex: 3,
            child: ContentForm(
              controller: contentController,
              onImagePick: () async {
                List<XFile> _images =
                    await _imagePicker.pickMultiImage(limit: 8 - images.length);
                setState(() {
                  images = [...images, ..._images];
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: journalFormController.maybeWhen(
              loading: null,
              orElse: () {
                return () async {
                  _formKey.currentState?.validate();
                  if (!isFormEmpty) {
                    _formKey.currentState?.save();
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      );

                      await ref
                          .read(journalFormControllerProvider.notifier)
                          .createJournal(
                              title: titleController.text ?? '',
                              content: contentController.text ?? '',
                              date: date ?? DateTime.now(),
                              images: images)
                          .then(
                        (_) {
                          ref.invalidate(journalControllerProvider);
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
                  }
                };
              },
            ),
            style: onSaveButtonStyle.copyWith(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).primaryColor),
              fixedSize: WidgetStatePropertyAll(
                Size.fromWidth(MediaQuery.sizeOf(context).width - 32),
              ),
            ),
            child: const Text(
              "저장",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
