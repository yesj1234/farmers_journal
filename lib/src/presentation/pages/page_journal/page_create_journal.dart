import 'dart:typed_data';

import 'package:farmers_journal/src/presentation/components/journal_form_content.dart';
import 'package:farmers_journal/src/presentation/components/journal_form_date.dart';
import 'package:farmers_journal/src/presentation/components/journal_form_title.dart';
import 'package:farmers_journal/src/presentation/components/layout_images/layout_images.dart';
import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';

import 'package:farmers_journal/src/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/src/presentation/controller/journal/journal_form_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/image_type.dart';

// TODO: Refactoring needed. Merge create journal and update journal page.

/// {@category Presentation}
class PageCreateJournal extends ConsumerStatefulWidget {
  const PageCreateJournal({super.key, this.initialDate});
  final DateTime? initialDate;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageCreateJournal();
}

class _PageCreateJournal extends ConsumerState<PageCreateJournal> {
  bool get isFormEmpty {
    return images.isEmpty &&
        titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  late final DateTime date;

  List<XFile> images = [];

  void onDatePicked(DateTime value) {
    setState(() {
      date = value;
    });
  }

  void deleteImage(int id) {
    setState(() {
      images.removeAt(id);
    });
    _formKey.currentState?.validate();
  }

  @override
  void initState() {
    super.initState();
    date = widget.initialDate ?? DateTime.now();
  }

  double? progress = 0;
  double totalTransferred = 0;
  Future<double> get totalBytesToUpload async {
    final futureBytes = images.map((img) => img.readAsBytes()).toList();
    List<Uint8List> bytesList = await Future.wait(futureBytes);
    final bytes = bytesList.map((byte) => byte.length).toList();
    return bytes.fold<double>(0.0, (sum, byte) => sum + byte);
  }

  @override
  Widget build(BuildContext context) {
    final journalFormController = ref.watch(journalFormControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop('/main')),
        actions: [
          TextButton(
            onPressed: () {
              journalFormController.maybeWhen(
                loading: null,
                orElse: () async {
                  _formKey.currentState?.validate();
                  if (!isFormEmpty) {
                    _formKey.currentState?.save();
                    try {
                      void Function(VoidCallback)? dialogSetState;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, setState) {
                            dialogSetState =
                                setState; // store the reference to dialogSetState.
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                                value: progress,
                              ),
                            );
                          });
                        },
                      );

                      await ref
                          .read(journalFormControllerProvider.notifier)
                          .createJournal(
                              title: titleController.text,
                              content: contentController.text,
                              date: date,
                              images: images,
                              progressCallback: (
                                  {int? transferred, int? totalBytes}) async {
                                final total = await totalBytesToUpload;
                                if (transferred != null && totalBytes != null) {
                                  totalTransferred += transferred;
                                  double newProgress = totalTransferred / total;
                                  dialogSetState!(() {
                                    progress = newProgress.clamp(
                                        0, 1); // Ensure it stays within 0-1
                                  });
                                }
                              })
                          .then(
                        (_) {
                          ref.invalidate(journalControllerProvider);
                          if (context.mounted) {
                            context.pop();
                            context.pop();
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
                },
              );
            },
            child: const Text(
              "완료",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        title: Text(
          "일지 쓰기",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: LayoutBuilder(builder: (context, viewport) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewport.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Column(
                      spacing: 10,
                      children: [
                        DateForm(
                          initialDate: date,
                          datePicked: widget.initialDate ?? date,
                          onDatePicked: onDatePicked,
                        ),
                        images.isNotEmpty
                            ? SizedBox(
                                width: MediaQuery.sizeOf(context).width - 42,
                                height: images.length <= 5
                                    ? MediaQuery.sizeOf(context).height / 5
                                    : MediaQuery.sizeOf(context).height / 2.5,
                                child: CustomImageWidgetLayout(
                                  images: images
                                      .map((item) => XFileImage(item))
                                      .toList(),
                                  onDelete: deleteImage,
                                  isEditMode: true,
                                  isImagesHidden: false,
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
                              _formKey.currentState?.save();
                              try {
                                if (images.length >= 8) {
                                  throw (Exception('사진은 최대 8장 까지 선택할 수 있습니다.'));
                                }
                                if (images.length >= 7) {
                                  XFile? _image = await _imagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  setState(() {
                                    images = [...images, _image!];
                                  });
                                } else {
                                  List<XFile> _images = await _imagePicker
                                      .pickMultiImage(limit: 8 - images.length);
                                  setState(() {
                                    images = [...images, ..._images];
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
