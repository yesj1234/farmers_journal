import 'dart:collection';
import 'dart:developer';

import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthView extends ConsumerStatefulWidget {
  const MonthView({super.key});

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
          calendarBuilders:
              CalendarBuilders(markerBuilder: (context, data, events) {
            if (events.isNotEmpty) {
              return Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${events.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
          }),
          locale: 'ko_KR',
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
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
