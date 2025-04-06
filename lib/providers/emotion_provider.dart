import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../models/emotion_entry.dart';

class EmotionProvider with ChangeNotifier {
  Database? _db;
  List<EmotionEntry> _entries = [];
  bool _isLoading = false;
  String? _error;
  final _uuid = Uuid();

  List<EmotionEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  EmotionProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      _isLoading = true;
      notifyListeners();

      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'emotions.db');

      _db = await openDatabase(
        path,
        version: 3,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE emotion_entries(
              id TEXT PRIMARY KEY,
              emotionId TEXT NOT NULL,
              reason TEXT,
              timestamp TEXT NOT NULL,
              customEmotion TEXT,
              customEmoji TEXT,
              note TEXT
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            // Add columns for custom emotions
            await db.execute(
                'ALTER TABLE emotion_entries ADD COLUMN customEmotion TEXT');
            await db.execute(
                'ALTER TABLE emotion_entries ADD COLUMN customEmoji TEXT');
          }
          if (oldVersion < 3) {
            // Add column for notes
            await db
                .execute('ALTER TABLE emotion_entries ADD COLUMN note TEXT');
          }
        },
      );

      await fetchEntries();
    } catch (e) {
      _error = 'Failed to initialize database: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEntries() async {
    try {
      _isLoading = true;
      notifyListeners();

      final List<Map<String, dynamic>> maps =
          await _db?.query('emotion_entries', orderBy: 'timestamp DESC') ?? [];

      _entries = maps.map((map) => EmotionEntry.fromMap(map)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch entries: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmotionEntry({
    required String emotionId,
    String? reason,
    String? customEmotion,
    String? customEmoji,
    String? note,
  }) async {
    try {
      final entry = EmotionEntry(
        id: _uuid.v4(),
        emotionId: emotionId,
        reason: reason,
        timestamp: DateTime.now(),
        customEmotion: customEmotion,
        customEmoji: customEmoji,
        note: note,
      );

      await _db?.insert(
        'emotion_entries',
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await fetchEntries();
    } catch (e) {
      _error = 'Failed to add entry: $e';
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      await _db?.delete(
        'emotion_entries',
        where: 'id = ?',
        whereArgs: [id],
      );

      await fetchEntries();
    } catch (e) {
      _error = 'Failed to delete entry: $e';
      notifyListeners();
    }
  }

  Future<void> updateNote(String id, String note) async {
    try {
      await _db?.update(
        'emotion_entries',
        {'note': note},
        where: 'id = ?',
        whereArgs: [id],
      );

      await fetchEntries();
    } catch (e) {
      _error = 'Failed to update note: $e';
      notifyListeners();
    }
  }
}
