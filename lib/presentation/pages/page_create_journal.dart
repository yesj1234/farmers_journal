import 'package:farmers_journal/presentation/controller/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class PageCreateJournal extends StatelessWidget {
  const PageCreateJournal({super.key});
  TextStyle get textStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("일지 쓰기"),
      ),
      body: SafeArea(
        child: Center(
          child: CreateJournalForm(),
        ),
      ),
    );
  }
}

class CreateJournalForm extends HookConsumerWidget {
  CreateJournalForm({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datePicked = useState<DateTime>(DateTime.now());
    final newJournalTitle = useState<String>('');
    final newJournalContent = useState<String>('');
    void updatePickedDate(DateTime? pickedDate) {
      datePicked.value = pickedDate ?? DateTime.now();
    }

    void updateJournalTitle(String? title) {
      newJournalTitle.value = title?.isNotEmpty == true ? title! : '';
    }

    void updateJournalContent(String? content) {
      newJournalContent.value = content?.isNotEmpty == true ? content! : '';
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          _DateForm(
            datePicked: datePicked.value,
            onDatePicked: updatePickedDate,
          ),
          _TitleForm(
            title: newJournalTitle.value,
            onUpdateJournalTitle: updateJournalTitle,
          ),
          const SizedBox(
            height: 10,
          ),
          _ContentForm(
            content: newJournalContent.value,
            onUpdateContent: updateJournalContent,
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.save();
              await ref.read(journalControllerProvider.notifier).createJournal(
                  title: newJournalContent.value,
                  content: newJournalContent.value,
                  date: datePicked.value,
                  image: '');
              if (context.mounted) {
                context.go('/main');
              }
            },
            child: const Text("Save"),
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
      {super.key, required this.content, required this.onUpdateContent});
  final String? content;
  final void Function(String?) onUpdateContent;
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
            decoration: const InputDecoration(
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
            minLines: 10,
            maxLines: 10,
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
