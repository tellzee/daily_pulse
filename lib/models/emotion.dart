import 'package:flutter/material.dart';

class Emotion {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  final bool isCustom;

  const Emotion({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    this.isCustom = false,
  });
}

// Predefined emotions with their properties
final List<Emotion> predefinedEmotions = [
  const Emotion(
      id: 'happy', name: 'Happy', emoji: '😊', color: Color(0xFFFFD700)),
  const Emotion(id: 'sad', name: 'Sad', emoji: '😢', color: Color(0xFF1E90FF)),
  const Emotion(
      id: 'angry', name: 'Angry', emoji: '😡', color: Color(0xFFFF4500)),
  const Emotion(
      id: 'surprised',
      name: 'Surprised',
      emoji: '😲',
      color: Color(0xFF32CD32)),
  const Emotion(
      id: 'calm', name: 'Calm', emoji: '😌', color: Color(0xFF8A2BE2)),
  const Emotion(
      id: 'excited', name: 'Excited', emoji: '🤩', color: Color(0xFFFF69B4)),
  const Emotion(
      id: 'bored', name: 'Bored', emoji: '😒', color: Color(0xFF808080)),
  const Emotion(
      id: 'nervous', name: 'Nervous', emoji: '😬', color: Color(0xFF4682B4)),
  const Emotion(
      id: 'confused', name: 'Confused', emoji: '😕', color: Color(0xFFDAA520)),
  const Emotion(
      id: 'grateful', name: 'Grateful', emoji: '🙏', color: Color(0xFF00FA9A)),
  const Emotion(
    id: 'peaceful',
    name: 'Peaceful',
    emoji: '😌',
    color: Color(0xFF4CAF50),
  ),
  const Emotion(
    id: 'tired',
    name: 'Tired',
    emoji: '😫',
    color: Color(0xFF9E9E9E),
  ),
  const Emotion(
    id: 'anxious',
    name: 'Anxious',
    emoji: '😰',
    color: Color(0xFF9C27B0),
  ),
  const Emotion(
    id: 'loved',
    name: 'Loved',
    emoji: '🥰',
    color: Color(0xFFE91E63),
  ),
  const Emotion(
    id: 'other',
    name: 'Other',
    emoji: '❓',
    color: Color(0xFF607D8B),
    isCustom: true,
  ),
  const Emotion(
      id: 'scared', name: 'Scared', emoji: '😱', color: Color(0xFFDC143C)),
  const Emotion(
      id: 'embarrassed',
      name: 'Embarrassed',
      emoji: '😳',
      color: Color(0xFFFFA07A)),
  const Emotion(
      id: 'lonely', name: 'Lonely', emoji: '😔', color: Color(0xFF778899)),
  const Emotion(
      id: 'hopeful', name: 'Hopeful', emoji: '🌈', color: Color(0xFF7CFC00)),
  const Emotion(
      id: 'frustrated',
      name: 'Frustrated',
      emoji: '😤',
      color: Color(0xFFB22222)),
  const Emotion(
      id: 'in_love', name: 'In Love', emoji: '🥰', color: Color(0xFFFF1493)),
  const Emotion(id: 'shy', name: 'Shy', emoji: '🙈', color: Color(0xFFFFB6C1)),
  const Emotion(
      id: 'relieved',
      name: 'Relieved',
      emoji: '😮‍💨',
      color: Color(0xFF40E0D0)),
  const Emotion(
      id: 'lazy', name: 'Lazy', emoji: '🛌', color: Color(0xFFB0C4DE)),
];
