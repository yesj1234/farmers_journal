import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/components/layout_images.dart';
import 'package:farmers_journal/presentation/components/styles/button.dart';
import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';

import 'package:farmers_journal/presentation/components/styles/text.dart';

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
  List<dynamic>? images;

  @override
  void initState() {
    super.initState();
    _journal =
        ref.read(journalControllerProvider.notifier).getJournal(widget.id!);
    _journal.then((journal) {
      setState(() {
        title = journal.title;
        content = journal.content;
        date = journal.createdAt;
        images = journal.images ?? [];
      });
    });
  }

  void onDatePicked(DateTime? value) {
    date = value;
  }

  void updateJournalTitle(String? value) {
    title = value;
  }

  void updateJournalContent(String? value) {
    content = value;
  }

  void pickImage() {
    _imagePicker.pickMultiImage().then((image) {
      setState(() => images = [...?images, ...image]);
    });
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
              children: [
                const SizedBox(height: 10),
                _DateForm(
                  datePicked: date,
                  onDatePicked: onDatePicked,
                ),
                images!.isEmpty
                    ? const SizedBox.shrink()
                    : Flexible(
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width / 1.1,
                          height: MediaQuery.sizeOf(context).height / 4,
                          child: ImageWidgetLayout(
                            images: images!.map((item) {
                              if (item is String) {
                                return UrlImage(item);
                              } else {
                                return XFileImage(item);
                              }
                            }).toList(),
                            onDelete: deleteImage,
                            isEditMode: true,
                          ),
                        ),
                      ),
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
                    onImagePick: pickImage,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState?.save();
                    final imagePaths = images?.map((image) {
                      if (image is XFile) return image.path;
                      return image as String;
                    }).toList();
                    await ref
                        .read(journalControllerProvider.notifier)
                        .updateJournal(
                            id: widget.id!,
                            title: title ?? '',
                            content: content ?? '',
                            date: date ?? snapshot.data!.createdAt!,
                            images: imagePaths as List<String?>? ??
                                snapshot.data!.images!);
                    if (context.mounted) {
                      context.go('/main');
                    }
                  },
                  style: onSaveButtonStyle,
                  child: ref.watch(journalControllerProvider).maybeWhen(
                        orElse: () => const Text("저장", style: onSaveTextStyle),
                        loading: () => const CircularProgressIndicator(),
                      ),
                ),
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
        onSaved: (value) => onUpdateJournalTitle(value),
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

class _ContentForm extends StatelessWidget {
  const _ContentForm(
      {super.key,
      required this.content,
      required this.onUpdateContent,
      required this.onImagePick});
  final String? content;

  final void Function(String?) onUpdateContent;
  final void Function() onImagePick;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      height: MediaQuery.sizeOf(context).height / 3.1,
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
    );
  }
}
