import 'dart:collection';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// A widget that displays a calendar view of journal entries grouped by month.
///
/// This widget retrieves and displays journal entries in a monthly calendar format,
/// allowing users to view and select specific days to see their corresponding journal entries.
class MonthView extends ConsumerStatefulWidget {
  /// Creates a [MonthView] widget.
  const MonthView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MonthViewState();
}

/// The state class for [MonthView].
class _MonthViewState extends ConsumerState<ConsumerStatefulWidget> {
  /// A future that retrieves journal entries organized by month.
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

/// A widget that displays a calendar and allows users to interact with journal entries.
class CalendarWidget extends StatefulWidget {
  /// Creates a [CalendarWidget] widget.
  const CalendarWidget({super.key, required this.events});

  /// A map of journal entries grouped by date.
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

  /// Retrieves the journal entries for a specific day.
  List<Journal?> _getEventsForDay(DateTime day) {
    DateTime formattedDate = CustomDateUtils.formatDate(day);
    return widget.events[formattedDate] ?? [];
  }

  /// Handles selection of a day in the calendar.
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
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            markerBuilder: (context, data, events) {
              if (events.isNotEmpty) {
                return Align(
                  alignment: Alignment.topRight,
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
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
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${value[index]?.content}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
