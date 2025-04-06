import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../models/emotion.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Statistics'),
      ),
      body: Consumer<EmotionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.entries.isEmpty) {
            return const Center(
              child: Text('No emotions recorded yet'),
            );
          }

          // Group emotions by type
          final emotionCounts = <String, int>{};
          for (final entry in provider.entries) {
            final emotion = predefinedEmotions.firstWhere(
              (e) => e.id == entry.emotionId,
              orElse: () => Emotion(
                id: entry.emotionId,
                name: entry.customEmotion ?? 'Unknown',
                emoji: entry.customEmoji ?? '❓',
                color: const Color(0xFF607D8B),
              ),
            );
            emotionCounts[emotion.name] =
                (emotionCounts[emotion.name] ?? 0) + 1;
          }

          // Sort emotions by frequency
          final sortedEmotions = emotionCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Most Common Emotions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ...sortedEmotions.map((entry) {
                        final emotion = predefinedEmotions.firstWhere(
                          (e) => e.name == entry.key,
                          orElse: () => Emotion(
                            id: 'custom',
                            name: entry.key,
                            emoji: '❓',
                            color: const Color(0xFF607D8B),
                          ),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                emotion.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(emotion.name),
                                    LinearProgressIndicator(
                                      value:
                                          entry.value / provider.entries.length,
                                      backgroundColor:
                                          emotion.color.withOpacity(0.1),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        emotion.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${entry.value}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Total entries: ${provider.entries.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Unique emotions: ${emotionCounts.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
