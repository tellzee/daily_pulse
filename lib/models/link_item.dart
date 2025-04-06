import 'package:intl/intl.dart';

class LinkItem {
  final String title;
  final String url;
  final String description;
  final DateTime timestamp;

  LinkItem({
    required this.title,
    required this.url,
    required this.description,
    required this.timestamp,
  });

  String get formattedTimestamp =>
      DateFormat('MMM dd, yyyy HH:mm').format(timestamp);
}
