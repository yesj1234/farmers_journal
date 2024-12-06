// packages
import 'dart:collection';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/data/firestore_service.dart';
import 'package:farmers_journal/data/providers.dart';

// custom components
import 'package:farmers_journal/presentation/components/button/button_create_post.dart';
import 'package:farmers_journal/presentation/components/button/button_status.dart';
import 'package:farmers_journal/presentation/components/button/button_filter_date.dart';
import 'package:farmers_journal/presentation/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';
import 'package:farmers_journal/presentation/components/carousel/carousel.dart';

// enums
import 'package:farmers_journal/enums.dart';

// models
import 'package:farmers_journal/domain/model/journal.dart';

// utils
import 'package:farmers_journal/utils.dart';

/// TODO:
///  - 1. Apply font. Pretandard
///  - 2. Connect FireStore(?) image provider for button profile avatar component.
///  - 3. Make the page responsive.
///  - 4. Connect Database. :: _Content should change based on the user's journal status.
///  - 5. Think of the properties that should be resolved to each child components. => Needs modeling first.
///  - 6. Add onTap / onClick callback to profile image directing to the profile setting page.
class PageMain extends ConsumerWidget {
  const PageMain({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _TopNavTemp(),
              Align(
                alignment: Alignment.centerRight,
                child: ButtonFilterDate(),
              ),
              Expanded(child: _Content()),
            ],
          ),
        ),
      ),
      floatingActionButton: ButtonCreatePost(
        onClick: () => context.go('/main/create'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _TopNavTemp extends StatelessWidget {
  const _TopNavTemp();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "농사 일지",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        IntrinsicHeight(
          child: SizedBox(
            height: 55,
            child: Row(
              children: [
                ButtonStatus(
                  status: "작물",
                  statusValue: "포도(캠벨얼리)",
                  statusEmoji: "assets/icons/Grapes.png",
                  onNavigateTap: () => context.go('/main/statistics'),
                ),
                const VerticalDivider(
                  thickness: 2,
                ),
                ButtonStatus(
                  status: "기록일수",
                  statusValue: "0 일",
                  statusEmoji: "assets/icons/Fire.png",
                  onNavigateTap: () => context.go('/main/statistics'),
                ),
                const Spacer(),
                AvatarProfile(
                  width: 50,
                  height: 50,
                  onNavigateTap: () => context.go('/main/settings'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

/// TODO
/// 1. Fetch user data from firestore => StatefulWidget.
/// 2. Based on the content status of the user show DefaultContent or the CardView and Consider the responsiveness.
/// 3. Add sorting buttons.
class _Content extends StatelessWidget {
  final bool _isEmpty = false; // To be replaced to fetching logic.

  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget child = _isEmpty ? const _DefaultContent() : _UserContent();

    return Center(child: child);
  }
}

class _DefaultContent extends StatelessWidget {
  const _DefaultContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/icons/LogoTemp.png"),
        const SizedBox(
          height: 15,
        ),
        Text("일지를 작성해보세요", style: textStyle),
      ],
    );
  }
}

class _UserContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFilter = ref.watch(dateFilterProvider);

    Widget child = switch (dateFilter) {
      DateView.day => const _DayView(),
      DateView.week => const _WeekView(),
      DateView.month => const _MonthView(),
    };
    return child;
  }
}

class _DayView extends ConsumerWidget {
  const _DayView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalProvider);

    return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 4.0),
        children: switch (journals) {
          AsyncData(:final value) => [
              for (var journal in value)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Center(
                    child: CardSingle(
                      journal: journal,
                    ),
                  ),
                )
            ],
          AsyncError() => [const Text("Oops! Something went wrong")],
          _ => [const CircularProgressIndicator()]
        });
  }
}

class _WeekView extends ConsumerWidget {
  const _WeekView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalProvider);
    final Widget child = switch (journals) {
      AsyncData(:final value) => LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          List<WeeklyGroup<Journal>> sortedJournals =
              CustomDateUtils.groupItemsByWeek(value);
          return ListView(
            children: [
              for (var items in sortedJournals)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        items.weekLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 200, child: MyCarousel(journals: items.items))
                  ],
                )
            ],
          );
        }),
      AsyncError() => const Text("Something went wrong"),
      _ => const CircularProgressIndicator()
    };
    return child;
  }
}

class _MonthView extends ConsumerWidget {
  const _MonthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalProvider);
    final Widget widget = switch (journals) {
      AsyncData(:final value) => Builder(builder: (BuildContext context) {
          final linkedHashMap = CustomDateUtils.getMonthlyJournal(value);

          return Center(child: CalendarWidget(events: linkedHashMap));
        }),
      AsyncError() => const Text("Error"),
      _ => const CircularProgressIndicator()
    };
    return widget;
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key, required this.events});
  final LinkedHashMap<DateTime, List<Journal?>> events;

  @override
  State<StatefulWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Journal?>> _selectedEvents;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Journal?> _getEventsForDay(DateTime day) {
    DateTime formattedDate = CustomDateUtils.formatDate(day);
    return widget.events[formattedDate] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'ko_KR',
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: _getEventsForDay,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ValueListenableBuilder<List<Journal?>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text('${value[index]?.title}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${value[index]?.content}'),
                        ),
                      );
                    });
              }),
        )
      ],
    );
  }
}
