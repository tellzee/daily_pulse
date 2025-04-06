class EmotionEntry {
  final String id;
  final String emotionId;
  final String? reason;
  final DateTime timestamp;
  final String? customEmotion;
  final String? customEmoji;
  final String? note;

  EmotionEntry({
    required this.id,
    required this.emotionId,
    this.reason,
    required this.timestamp,
    this.customEmotion,
    this.customEmoji,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emotionId': emotionId,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
      'customEmotion': customEmotion,
      'customEmoji': customEmoji,
      'note': note,
    };
  }

  factory EmotionEntry.fromMap(Map<String, dynamic> map) {
    return EmotionEntry(
      id: map['id'],
      emotionId: map['emotionId'],
      reason: map['reason'],
      timestamp: DateTime.parse(map['timestamp']),
      customEmotion: map['customEmotion'],
      customEmoji: map['customEmoji'],
      note: map['note'],
    );
  }
}
