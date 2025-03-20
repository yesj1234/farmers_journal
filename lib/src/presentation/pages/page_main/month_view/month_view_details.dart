import 'package:farmers_journal/src/presentation/controller/journal/journal_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../day_view/animated_day_view.dart';

/// {@category Presentation}
class MonthViewDetails extends StatefulWidget {
  const MonthViewDetails({super.key, required this.initialDate});
  final DateTime initialDate;

  @override
  State<MonthViewDetails> createState() => _MonthViewDetailsState();
}

class _MonthViewDetailsState extends State<MonthViewDetails> {
  late final PageController _pageController;
  late DateTime currentDate;
  int currentIndex = 999;
  String get appBarTitle =>
      '${currentDate.year}년 ${currentDate.month}월 ${currentDate.day}일';
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    currentDate = widget.initialDate;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/create', extra: currentDate),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _handlePageChanged,
        itemBuilder: (BuildContext context, int index) {
          if (index == currentIndex) {
            return MonthViewDetailPageBuilder(date: currentDate);
          }
          if (index > (_pageController.page ?? currentIndex)) {
            return MonthViewDetailPageBuilder(
                date: currentDate.add(const Duration(days: 1)));
          } else {
            return MonthViewDetailPageBuilder(
                date: currentDate.subtract(const Duration(days: 1)));
          }
        },
      ),
    );
  }

  void _handlePageChanged(dynamic index) {
    // moving left
    if (index < currentIndex) {
      setState(() {
        currentIndex -= 1;
        currentDate = currentDate.subtract(const Duration(days: 1));
      });
      return;
    }

    // moving right
    if (index > currentIndex) {
      setState(() {
        currentIndex += 1;
        currentDate = currentDate.add(const Duration(days: 1));
      });
      return;
    }
  }
}

class MonthViewDetailPageBuilder extends ConsumerWidget {
  const MonthViewDetailPageBuilder({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalRef = ref.watch(journalControllerProvider);

    const Widget emptyJournals = Center(
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FittedBox(
              child: Text(
                "입력 항목 없음",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Flexible(
            child: FittedBox(
              child: Text(
                '이 날은 현재 일기 입력 항목이 없습니다.',
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return journalRef.maybeWhen(
        data: (value) {
          final items = value
              .where((journal) =>
                  journal!.date!.year == date.year &&
                  journal.date!.month == date.month &&
                  journal.date!.day == date.day)
              .map((journal) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: AnimatedDayViewCard(journal: journal!),
                  ))
              .toList();
          return items.isEmpty ? emptyJournals : ListView(children: items);
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        orElse: () => emptyJournals);
  }
}
