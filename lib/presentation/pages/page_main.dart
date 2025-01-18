// packages
import 'dart:collection';
import 'dart:developer';
import 'package:farmers_journal/presentation/components/card/day_view_card.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:table_calendar/table_calendar.dart';

//Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/data/providers.dart';

// custom components
import 'package:farmers_journal/presentation/components/button/button_create_post.dart';
import 'package:farmers_journal/presentation/components/button/button_status.dart';
import 'package:farmers_journal/presentation/components/button/button_filter_date.dart';
import 'package:farmers_journal/presentation/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/presentation/components/carousel/carousel.dart';

// enums
import 'package:farmers_journal/enums.dart';

// models
import 'package:farmers_journal/domain/model/journal.dart';

// utils
import 'package:farmers_journal/utils.dart';

class PageMain extends ConsumerWidget {
  const PageMain({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalRef = ref.watch(journalControllerProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          title: Text(
            '농업 일지',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10),
              const _TopNavTemp(),
              Divider(
                thickness: 0.5,
                indent: 10,
                endIndent: 10,
                color: Theme.of(context).primaryColor,
              ),
              journalRef.hasValue && journalRef.value!.isNotEmpty
                  ? const Align(
                      alignment: Alignment.centerRight,
                      child: ButtonFilterDate(),
                    )
                  : const SizedBox.shrink(),
              const Expanded(child: _Content()),
            ],
          ),
        ),
      ),
      floatingActionButton: ButtonCreatePost(
        onClick: () => context.go('/create'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _TopNavTemp extends ConsumerWidget {
  const _TopNavTemp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider);
    final journal = ref.watch(journalControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicHeight(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    user.value != null
                        ? user.value!.plants.isNotEmpty
                            ? ButtonStatus(
                                status: "작물",
                                statusValue: user.value?.plants[0].name,
                                statusIcon: Icons.eco,
                                statusIconColor: Colors.green,
                                onNavigateTap: () =>
                                    context.go('/main/statistics'),
                              )
                            : ButtonStatus(
                                status: "작물",
                                statusValue: '설정 필요',
                                statusIcon: Icons.eco,
                                statusIconColor: Colors.green,
                                onNavigateTap: () =>
                                    context.go('/initial_setting'),
                              )
                        : ButtonStatus(
                            status: "작물",
                            statusValue: '설정 필요',
                            statusIcon: Icons.eco,
                            statusIconColor: Colors.green,
                            onNavigateTap: () => context.go('/initial_setting'),
                          ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    ButtonStatus(
                      status: "일지",
                      statusValue: journal.value != null
                          ? '${journal.value?.length} 개'
                          : '0 개',
                      statusIcon: Icons.local_fire_department_sharp,
                      statusIconColor: Colors.red,
                      onNavigateTap: () => context.go('/main/statistics'),
                    )
                  ],
                ),
                const Spacer(),
                AvatarProfile(
                  width: 60,
                  height: 60,
                  onNavigateTap: () => context.go('/main/profile'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalControllerProvider);

    return journals.when(
      data: (data) {
        return _UserContent(journals: data);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) {
        return Center(
          child: Text(
            e.toString(),
          ),
        );
      },
    );
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
      children: [
        const Spacer(flex: 2),
        Image.asset("assets/icons/LogoTemp.png"),
        const SizedBox(
          height: 15,
        ),
        Text("일지를 작성해보세요", style: textStyle),
        const Spacer(flex: 3),
      ],
    );
  }
}

class _UserContent extends ConsumerWidget {
  const _UserContent({super.key, required this.journals});
  final List<Journal?> journals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFilter = ref.watch(dateFilterProvider);
    if (journals.isNotEmpty) {
      return switch (dateFilter) {
        DateView.day => const _DayView(),
        DateView.week => const _WeekView(),
        DateView.month => const _MonthView(),
      };
    } else {
      return const _DefaultContent();
    }
  }
}

class _DayView extends ConsumerStatefulWidget {
  const _DayView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayViewState();
}

class _DayViewState extends ConsumerState<ConsumerStatefulWidget> {
  late Future<Map<DateTime, List<Journal?>>> _sortedJournal;
  @override
  void initState() {
    super.initState();
    _sortedJournal =
        ref.read(journalControllerProvider.notifier).getDayViewJournals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _sortedJournal,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> children = [];
            for (var entry in snapshot.data!.entries) {
              children.add(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '${entry.key.month}월 ${entry.key.day}일',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              );
              for (var journal in entry.value) {
                if (journal != null) {
                  children.add(_DayViewCard(journal: journal));
                }
              }
            }
            return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 4.0),
                children: children);
          }
          return const SizedBox.shrink();
        });
  }
}

class _DayViewCard extends StatelessWidget {
  const _DayViewCard({super.key, required this.journal});
  final Journal journal;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Center(
        child: DayViewCard(
          verticalPadding: 0,
          journal: journal,
        ),
      ),
    );
  }
}

class _WeekView extends ConsumerStatefulWidget {
  const _WeekView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeekViewState();
}

class _WeekViewState extends ConsumerState<ConsumerStatefulWidget> {
  late Future<List<WeeklyGroup<Journal>>> _sortedJournals;

  @override
  void initState() {
    super.initState();
    _sortedJournals =
        ref.read(journalControllerProvider.notifier).getWeekViewJournals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _sortedJournals,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView(children: [
              for (var items in snapshot.data!)
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
                      height: 200,
                      child: MyCarousel(journals: items.items),
                    )
                  ],
                )
            ]);
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class _MonthView extends ConsumerStatefulWidget {
  const _MonthView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MonthViewState();
}

class _MonthViewState extends ConsumerState<ConsumerStatefulWidget> {
  late Future<LinkedHashMap<DateTime, List<Journal?>>> _linkedHashMap;
  @override
  void initState() {
    super.initState();
    _linkedHashMap =
        ref.read(journalControllerProvider.notifier).getMonthlyJournals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _linkedHashMap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(child: CalendarWidget(events: snapshot.data!));
          } else {
            return const SizedBox.shrink();
          }
        });
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
