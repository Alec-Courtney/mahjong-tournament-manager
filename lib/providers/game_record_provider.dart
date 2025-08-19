import 'package:flutter/foundation.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/services/database_service.dart';

class GameRecordProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final String eventId;
  List<GameRecord> _gameRecords = [];

  List<GameRecord> get gameRecords => _gameRecords;

  GameRecordProvider(this.eventId) {
    loadGameRecords();
  }

  Future<void> loadGameRecords() async {
    final box = await _databaseService.gameRecordsBox;
    _gameRecords = box.values.where((record) => record.eventId == eventId).toList();
    notifyListeners();
  }

  Future<void> addGameRecord(GameRecord record) async {
    final box = await _databaseService.gameRecordsBox;
    // Hive does not support auto-incrementing keys, so we use a timestamp-based key
    await box.add(record);
    _gameRecords.add(record);
    notifyListeners();
  }
}
