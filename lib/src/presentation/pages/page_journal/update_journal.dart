import 'dart:typed_data';

import 'package:farmers_journal/src/domain/model/journal.dart';
import 'package:farmers_journal/src/presentation/components/journal_form_content.dart';
import 'package:farmers_journal/src/presentation/components/journal_form_date.dart';
import 'package:farmers_journal/src/presentation/components/journal_form_title.dart';
import 'package:farmers_journal/src/presentation/components/layout_images/layout_images.dart';
import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/src/presentation/components/styles/button.dart';
import 'package:farmers_journal/src/presentation/controller/journal/journal_form_controller.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/image_type.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmers_journal/src/presentation/controller/journal/journal_controller.dart';

/// {@category Presentation}
class UpdateJournalForm extends ConsumerStatefulWidget {
  const UpdateJournalForm({super.key, required this.id});
  final String? id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateJournalFormState();
}

class _UpdateJournalFormState extends ConsumerState<UpdateJournalForm> {
  late final Future<Journal> _journal;
  String? title;
  String? content;
  DateTime? date;
  List<ImageType> images = [];

  bool get isFormEmpty {
    return images.isEmpty &&
        titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _journal =
        ref.read(journalControllerProvider.notifier).getJournal(widget.id!);
    _journal.then((journal) {
      setState(() {
        titleController.text = journal.title ?? '';
        contentController.text = journal.content ?? '';
        date = journal.date;
        images = journal.images?.map((path) => UrlImage(path!)).toList() ?? [];
      });
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void onDatePicked(DateTime? value) {
    setState(() {
      date = value;
    });
  }

  void deleteImage(int id) {
    setState(() {
      images.removeAt(id);
      if (images.isEmpty) {
        images = [];
      }
    });
  }

  double? progress = 0;
  double totalTransferred = 0;
  Future<double> get totalBytesToUpload async {
    if (images.isEmpty) {
      return 0.0;
    }
    final futureBytes = images.map((img) {
      switch (img) {
        case UrlImage():
          return Future.value(Uint8List.fromList([0]));
        case XFileImage():
          return img.value.readAsBytes();
      }
    }).toList();
    final bytesList = await Future.wait(futureBytes);
    final bytes = bytesList.map((byte) => byte.length).toList();
    return bytes.fold<double>(0.0, (sum, byte) => sum + byte);
  }

  @override
  Widget build(BuildContext context) {
    final journalFormController = ref.watch(journalFormControllerProvider);
    return FutureBuilder(
      future: _journal,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                DateForm(
                  initialDate: date!,
                  datePicked: date,
                  onDatePicked: onDatePicked,
                ),
                images.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        width: MediaQuery.sizeOf(context).width - 42,
                        height: MediaQuery.sizeOf(context).height / 5,
                        child: CustomImageWidgetLayout(
                          images: images,
                          onDelete: deleteImage,
                          isEditMode: true,
                          isImagesHidden: false,
                        ),
                      ),
                TitleForm(
                  notValid: isFormEmpty,
                  controller: titleController,
                ),
                Expanded(
                  flex: 3,
                  child: ContentForm(
                    controller: contentController,
                    onImagePick: () async {
                      _formKey.currentState?.save();
                      try {
                        if (images.length >= 8) {
                          throw (Exception('사진은 최대 8장 까지 선택할 수 있습니다.'));
                        }
                        if (images.length >= 7) {
                          XFile? _image = await _imagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            images = [...images, XFileImage(_image!)];
                          });
                        } else {
                          List<XFile> _images = await _imagePicker
                              .pickMultiImage(limit: 8 - images.length);
                          setState(() {
                            images = [
                              ...images,
                              ..._images.map((file) => XFileImage(file))
                            ];
                          });
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showSnackBar(context, e.toString());
                        }
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: journalFormController.maybeWhen(
                      orElse: () {
                        return () async {
                          bool validated =
                              _formKey.currentState?.validate() ?? false;

                          if (validated) {
                            _formKey.currentState?.save();
                            try {
                              void Function(VoidCallback)? dialogSetState;
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      dialogSetState = setState;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                          value: progress,
                                        ),
                                      );
                                    });
                                  });
                              await ref
                                  .read(journalFormControllerProvider.notifier)
                                  .updateJournal(
                                      id: widget.id!,
                                      title: titleController.text,
                                      content: contentController.text,
                                      date: date ?? snapshot.data!.date!,
                                      images: images,
                                      progressCallback: (
                                          {int? transferred,
                                          int? totalBytes}) async {
                                        final total = await totalBytesToUpload;
                                        if (transferred != null &&
                                            totalBytes != null) {
                                          totalTransferred += transferred;
                                          double newProgress =
                                              totalTransferred / total;
                                          dialogSetState!(() {
                                            progress = newProgress.clamp(0, 1);
                                          });
                                        }
                                      })
                                  .then(
                                (_) {
                                  ref.invalidate(journalControllerProvider);
                                  if (context.mounted) {
                                    context.go('/main');
                                  }
                                },
                                onError: (e, st) {
                                  if (context.mounted) {
                                    showSnackBar(
                                      context,
                                      e.toString(),
                                    );
                                  }
                                },
                              );
                            } catch (error) {
                              if (context.mounted) {
                                showSnackBar(context, error.toString());
                              }
                            }
                          }
                        };
                      },
                      loading: null),
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
                )
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
