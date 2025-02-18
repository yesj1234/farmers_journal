import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:farmers_journal/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/presentation/components/styles/button.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_form_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';

class UpdateJournalForm extends StatefulHookConsumerWidget {
  const UpdateJournalForm({super.key, required this.id});
  final String? id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateJournalFormState();
}

class _UpdateJournalFormState extends ConsumerState<UpdateJournalForm> {
  final ImagePicker _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late final Future<Journal> _journal;
  String? title;
  String? content;
  DateTime? date;
  List<ImageType>? images;
  bool get isFormEmpty {
    if (images == null || title == null || content == null) {
      return false;
    } else {
      return images!.isEmpty &&
          title!.trim().isEmpty &&
          content!.trim().isEmpty;
    }
  }

  @override
  void initState() {
    super.initState();
    _journal =
        ref.read(journalControllerProvider.notifier).getJournal(widget.id!);
    _journal.then((journal) {
      setState(() {
        title = journal.title;
        content = journal.content;
        date = journal.date;
        images = journal.images?.map((path) => UrlImage(path!)).toList() ?? [];
      });
    });
  }

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

  void deleteImage(int id) {
    setState(() {
      images?.removeAt(id);
      if (images!.isEmpty) {
        images = [];
      }
    });
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
                _DateForm(
                  datePicked: date,
                  onDatePicked: onDatePicked,
                ),
                images!.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        width: MediaQuery.sizeOf(context).width - 42,
                        height: MediaQuery.sizeOf(context).height / 5,
                        child: ImageWidgetLayout(
                          images: images ?? [],
                          onDelete: deleteImage,
                          isEditMode: true,
                        ),
                      ),
                _TitleForm(
                  title: title,
                  onUpdateJournalTitle: updateJournalTitle,
                  notValid: isFormEmpty,
                ),
                Expanded(
                  flex: 3,
                  child: _ContentForm(
                    content: content,
                    onUpdateContent: updateJournalContent,
                    onImagePick: () async {
                      List<XFile> _images = await _imagePicker.pickMultiImage(
                          limit: 8 - images!.length);
                      setState(() {
                        images = [
                          ...images!,
                          ..._images.map((file) => XFileImage(file))
                        ];
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: journalFormController.maybeWhen(
                      orElse: () {
                        return () async {
                          final bool isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (isValid) {
                            _formKey.currentState?.save();
                            try {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                          color:
                                              Theme.of(context).primaryColor),
                                    );
                                  });
                              await ref
                                  .read(journalFormControllerProvider.notifier)
                                  .updateJournal(
                                      id: widget.id!,
                                      title: title ?? '',
                                      content: content ?? '',
                                      date: date ?? snapshot.data!.date!,
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
  final void Function(DateTime?) onDatePicked;
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
            color: Colors.transparent,
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
      {super.key,
      required this.title,
      required this.onUpdateJournalTitle,
      required this.notValid});
  final String? title;
  final void Function(String?) onUpdateJournalTitle;
  final bool notValid;
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
        onSaved: (value) => onUpdateJournalTitle(value),
        validator: (_) {
          if (notValid && title!.isEmpty) {
            return '비어 있는 일지를 만들 수 없습니다.';
          } else {
            return null;
          }
        },
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
            overflow: TextOverflow.ellipsis,
            maxLines: null,
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
          tag.isLoading
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: tag.value!,
                ),
          Expanded(
              child: Stack(
            children: [
              TextFormField(
                initialValue: content,
                onChanged: (value) => onUpdateContent(value),
                onSaved: (value) => onUpdateContent(value),
                decoration: const InputDecoration(
                  hintText: '글쓰기 시작',
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
                maxLines: null,
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
          ))
        ],
      ),
    );
  }
}
