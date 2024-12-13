import 'package:farmers_journal/presentation/controller/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/data/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: const SafeArea(
        child: Center(
          child: CreateJournalForm(),
        ),
      ),
    );
  }
}

class CreateJournalForm extends ConsumerStatefulWidget {
  const CreateJournalForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateJournalFormState();
}

class _CreateJournalFormState extends ConsumerState<ConsumerStatefulWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const _DateForm(),
          const _TitleForm(),
          const SizedBox(
            height: 10,
          ),
          const _ContentForm(),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.save();
              final title = ref.read(newJournalTitleProvider);
              final content = ref.read(newJournalContentProvider);
              final date = ref.read(datePickedProvider);
              if (title != null && content != null && date != null) {
                ref.read(journalControllerProvider.notifier).createJournal(
                    title: title, content: content, date: date, image: '');
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

class _DatePickerWrapper extends ConsumerWidget {
  const _DatePickerWrapper({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(1980),
          lastDate: DateTime(2050),
        );
        if (pickedDate != null) {
          ref.read(datePickedProvider.notifier).updatePickedDate(pickedDate);
        }
      },
      child: child,
    );
  }
}

class _DateForm extends ConsumerWidget {
  const _DateForm({super.key});

  TextStyle get textStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedDate = ref.watch(datePickedProvider);

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
          const Align(
            alignment: Alignment.centerLeft,
            child: _DatePickerWrapper(
              child: SizedBox(
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
              child: Text(
                '${pickedDate?.year}. ${pickedDate?.month}. ${pickedDate?.day}.',
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleForm extends ConsumerWidget {
  const _TitleForm({super.key});
  TextStyle get textStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      child: TextFormField(
        onSaved: (value) => ref
            .read(newJournalTitleProvider.notifier)
            .updateJournalTitle(value),
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

class _ContentForm extends ConsumerWidget {
  const _ContentForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      height: MediaQuery.sizeOf(context).height / 3.1,
      child: Stack(
        children: [
          TextFormField(
            onSaved: (value) => ref
                .read(newJournalContentProvider.notifier)
                .updateJournalContent(value),
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
