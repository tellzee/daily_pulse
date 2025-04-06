import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class JournalEntry {
  final String id;
  final String content;
  final DateTime date;
  final String mood;
  final List<String> tags;
  final int wordCount;

  JournalEntry({
    required this.id,
    required this.content,
    required this.date,
    required this.mood,
    required this.tags,
    required this.wordCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'mood': mood,
      'tags': tags.join(','),
      'wordCount': wordCount,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
      tags: (map['tags'] as String)
          .split(',')
          .where((tag) => tag.isNotEmpty)
          .toList(),
      wordCount: map['wordCount'] ?? 0,
    );
  }
}

class JournalProvider with ChangeNotifier {
  Database? _db;
  List<JournalEntry> _entries = [];
  bool _isLoading = false;
  String _error = '';
  final _uuid = const Uuid();

  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String get error => _error;

  JournalProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'journal.db');

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE journal_entries(
              id TEXT PRIMARY KEY,
              content TEXT,
              date TEXT,
              mood TEXT,
              tags TEXT,
              wordCount INTEGER
            )
          ''');
        },
      );

      await fetchEntries();
    } catch (e) {
      _error = 'Error initializing database: $e';
      notifyListeners();
    }
  }

  Future<void> fetchEntries() async {
    if (_db == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<Map<String, dynamic>> maps = await _db!.query(
        'journal_entries',
        orderBy: 'date DESC',
        limit: 50,
      );

      _entries = maps.map((map) => JournalEntry.fromMap(map)).toList();
      _error = '';
    } catch (e) {
      _error = 'Error fetching entries: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry(String content, String mood, List<String> tags) async {
    if (_db == null) return;

    try {
      final entry = JournalEntry(
        id: _uuid.v4(),
        content: content,
        date: DateTime.now(),
        mood: mood,
        tags: tags,
        wordCount: content.split(' ').where((word) => word.isNotEmpty).length,
      );

      await _db!.insert(
        'journal_entries',
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _entries.insert(0, entry);
      notifyListeners();
    } catch (e) {
      _error = 'Error adding entry: $e';
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String id) async {
    if (_db == null) return;

    try {
      await _db!.delete(
        'journal_entries',
        where: 'id = ?',
        whereArgs: [id],
      );

      _entries.removeWhere((entry) => entry.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Error deleting entry: $e';
      notifyListeners();
    }
  }

  Future<void> updateEntry(JournalEntry entry) async {
    if (_db == null) return;

    try {
      await _db!.update(
        'journal_entries',
        entry.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );

      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error updating entry: $e';
      notifyListeners();
    }
  }
}
