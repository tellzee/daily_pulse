import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/emotion.dart';
import '../providers/emotion_provider.dart';
import '../models/emotion_entry.dart';
import 'emotion_selection_screen.dart';
import 'statistics_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<EmotionEntry> _getEntriesForDay(
      List<EmotionEntry> allEntries, DateTime day) {
    return allEntries.where((entry) {
      return entry.timestamp.year == day.year &&
          entry.timestamp.month == day.month &&
          entry.timestamp.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Pulse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<EmotionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchEntries(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final selectedDayEntries =
              _getEntriesForDay(provider.entries, _selectedDay);

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                eventLoader: (day) {
                  return _getEntriesForDay(provider.entries, day);
                },
                calendarStyle: const CalendarStyle(
                  markersMaxCount: 1,
                  markerDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(color: Colors.grey),
                  ),
                  formatButtonTextStyle: const TextStyle(color: Colors.black87),
                  formatButtonShowsNext: false,
                  titleCentered: true,
                  leftChevronIcon: const Icon(Icons.chevron_left),
                  rightChevronIcon: const Icon(Icons.chevron_right),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black87),
                  weekendStyle: TextStyle(color: Colors.black87),
                ),
              ),
              const Divider(),
              Expanded(
                child: selectedDayEntries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No emotions recorded for ${DateFormat.yMMMd().format(_selectedDay)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            if (isSameDay(_selectedDay, DateTime.now()))
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EmotionSelectionScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Track Your Mood'),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: selectedDayEntries.length,
                        itemBuilder: (context, index) {
                          final entry = selectedDayEntries[index];
                          final emotion = predefinedEmotions.firstWhere(
                            (e) => e.id == entry.emotionId,
                            orElse: () => Emotion(
                              id: entry.emotionId,
                              name: entry.customEmotion ?? 'Unknown',
                              emoji: entry.customEmoji ?? '❓',
                              color: const Color(0xFF607D8B),
                            ),
                          );

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Text(
                                    emotion.emoji,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  title: Text(emotion.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (entry.reason != null) ...[
                                        Text(entry.reason!),
                                        const SizedBox(height: 4),
                                      ],
                                      Text(
                                        DateFormat.jm().format(entry.timestamp),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_note),
                                        onPressed: () =>
                                            _showNoteDialog(context, entry),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () =>
                                            provider.deleteEntry(entry.id),
                                      ),
                                    ],
                                  ),
                                ),
                                if (entry.note != null &&
                                    entry.note!.isNotEmpty) ...[
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Note:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        RichText(
                                          text: TextSpan(
                                            children: _buildTextSpans(entry.note!, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmotionSelectionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNoteDialog(BuildContext context, EmotionEntry entry) {
    final textController = TextEditingController(text: entry.note);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add/Edit Note'),
        content: TextField(
          controller: textController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Write your thoughts...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<EmotionProvider>().updateNote(
                    entry.id,
                    textController.text,
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, BuildContext context) {
    final urlPattern = RegExp(
      r'((https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-._~:\/?#[\]@!$&\'()*+,;=]*)?)',
      caseSensitive: false,
    );

    final matches = urlPattern.allMatches(text);
    int lastMatchEnd = 0;
    final spans = <TextSpan>[];

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: Theme.of(context).textTheme.bodyText2,
        ));
      }

      final url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launch(url.startsWith('http') ? url : 'http://$url');
          },
      ));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: Theme.of(context).textTheme.bodyText2,
      ));
    }

    return spans;
  }
}
