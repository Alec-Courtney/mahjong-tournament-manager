import 'package:hive/hive.dart';
import 'package:mahjong_event_score/models.dart';

class DatabaseService {
  // Open boxes
  Future<Box<Event>> get eventsBox => Hive.openBox<Event>('events');
  Future<Box<Player>> get playersBox => Hive.openBox<Player>('players');
  Future<Box<Team>> get teamsBox => Hive.openBox<Team>('teams');
  Future<Box<GameRecord>> get gameRecordsBox => Hive.openBox<GameRecord>('gameRecords');

  // Add methods for CRUD operations here
}
