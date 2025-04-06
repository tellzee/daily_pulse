import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../models/emotion.dart';

class EmotionSelectionScreen extends StatelessWidget {
  const EmotionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling?'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: predefinedEmotions.length,
        itemBuilder: (context, index) {
          final emotion = predefinedEmotions[index];
          return _EmotionCard(emotion: emotion);
        },
      ),
    );
  }
}

class _EmotionCard extends StatelessWidget {
  final Emotion emotion;

  const _EmotionCard({required this.emotion});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: emotion.color.withOpacity(0.2),
      child: InkWell(
        onTap: () {
          if (emotion.isCustom) {
            _showCustomEmotionDialog(context);
          } else {
            _showReasonDialog(context);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emotion.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              emotion.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCustomEmotionDialog(BuildContext context) async {
    String? customEmotion;
    String? customEmoji;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Emotion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'How are you feeling?',
                hintText: 'Enter your emotion',
              ),
              onChanged: (value) => customEmotion = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Emoji (optional)',
                hintText: 'Enter an emoji',
              ),
              onChanged: (value) => customEmoji = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (customEmotion?.isNotEmpty == true) {
                Navigator.pop(context);
                _showReasonDialog(
                  context,
                  customEmotion: customEmotion,
                  customEmoji: customEmoji,
                );
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Future<void> _showReasonDialog(
    BuildContext context, {
    String? customEmotion,
    String? customEmoji,
  }) async {
    String? reason;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          customEmotion != null
              ? 'Why are you feeling $customEmotion?'
              : 'Why are you feeling ${emotion.name.toLowerCase()}?',
        ),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Reason (optional)',
            hintText: 'Enter your reason',
          ),
          onChanged: (value) => reason = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EmotionProvider>().addEmotionEntry(
                    emotionId: emotion.id,
                    reason: reason,
                    customEmotion: customEmotion,
                    customEmoji: customEmoji,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    customEmotion != null
                        ? 'Added $customEmotion to your emotions'
                        : 'Added ${emotion.name.toLowerCase()} to your emotions',
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
