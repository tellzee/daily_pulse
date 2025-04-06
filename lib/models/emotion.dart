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
  Emotion(
    id: 'happy',
    name: 'Happy',
    emoji: '😊',
    color: const Color(0xFFFFD93D),
  ),
  Emotion(
    id: 'excited',
    name: 'Excited',
    emoji: '🤩',
    color: const Color(0xFFFF8400),
  ),
  Emotion(
    id: 'peaceful',
    name: 'Peaceful',
    emoji: '😌',
    color: const Color(0xFF4CAF50),
  ),
  Emotion(
    id: 'sad',
    name: 'Sad',
    emoji: '😢',
    color: const Color(0xFF2196F3),
  ),
  Emotion(
    id: 'angry',
    name: 'Angry',
    emoji: '😠',
    color: const Color(0xFFFF5252),
  ),
  Emotion(
    id: 'tired',
    name: 'Tired',
    emoji: '😫',
    color: const Color(0xFF9E9E9E),
  ),
  Emotion(
    id: 'anxious',
    name: 'Anxious',
    emoji: '😰',
    color: const Color(0xFF9C27B0),
  ),
  Emotion(
    id: 'loved',
    name: 'Loved',
    emoji: '🥰',
    color: const Color(0xFFE91E63),
  ),
  Emotion(
    id: 'other',
    name: 'Other',
    emoji: '❓',
    color: const Color(0xFF607D8B),
    isCustom: true,
  ),
];
