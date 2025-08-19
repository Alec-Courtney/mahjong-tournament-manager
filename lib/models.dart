import 'package:hive/hive.dart';
import 'package:mahjong_event_score/models/column_config.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
enum MahjongType {
  @HiveField(0)
  threePlayer,
  @HiveField(1)
  fourPlayer,
}

@HiveType(typeId: 1)
class Player extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String nickname;
  @HiveField(3)
  String? teamId;

  Player({
    required this.id,
    required this.name,
    required this.nickname,
    this.teamId,
  });
}

@HiveType(typeId: 2)
class Team extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<String> playerIds;

  Team({
    required this.id,
    required this.name,
    required this.playerIds,
  });
}

@HiveType(typeId: 3)
class Event extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  MahjongType mahjongType;
  @HiveField(3)
  bool isTeamCompetition;
  @HiveField(4)
  int totalScoreCheck;
  @HiveField(5)
  int originPoint;
  @HiveField(6)
  Map<int, int> positionPoints;
  @HiveField(7)
  List<ColumnConfig> playerColumns;
  @HiveField(8)
  bool isScoreCheckEnabled;

  Event({
    required this.id,
    required this.name,
    required this.mahjongType,
    required this.isTeamCompetition,
    required this.totalScoreCheck,
    required this.originPoint,
    required this.positionPoints,
    this.isScoreCheckEnabled = true,
    List<ColumnConfig>? playerColumns,
  }) : playerColumns = playerColumns ?? Event.defaultPlayerColumns();

  static List<ColumnConfig> defaultPlayerColumns() {
    return [
      ColumnConfig(columnName: '排名', dataKey: 'rank', isVisible: true),
      ColumnConfig(columnName: '选手', dataKey: 'name', isVisible: true),
      ColumnConfig(columnName: '总分', dataKey: 'totalScore', isVisible: true),
      ColumnConfig(columnName: '对局数', dataKey: 'gamesPlayed', isVisible: true),
      ColumnConfig(columnName: '一位率', dataKey: 'rank1Rate', isVisible: false),
      ColumnConfig(columnName: '二位率', dataKey: 'rank2Rate', isVisible: false),
      ColumnConfig(columnName: '三位率', dataKey: 'rank3Rate', isVisible: false),
      ColumnConfig(columnName: '四位率', dataKey: 'rank4Rate', isVisible: false),
      ColumnConfig(columnName: '避四率', dataKey: 'avoidFourthRate', isVisible: true),
      ColumnConfig(columnName: '连对率', dataKey: 'consecutiveTopTwoRate', isVisible: false),
      ColumnConfig(columnName: '平均顺位', dataKey: 'averageRank', isVisible: false),
    ];
  }
}

@HiveType(typeId: 4)
class GameRecord extends HiveObject {
  @HiveField(0)
  DateTime timestamp;
  @HiveField(1)
  int score;
  @HiveField(2)
  int placement;
  @HiveField(3)
  double calculatedScore;
  @HiveField(4)
  String playerId;
  @HiveField(5)
  String eventId;

  GameRecord({
    required this.timestamp,
    required this.score,
    required this.placement,
    required this.calculatedScore,
    required this.playerId,
    required this.eventId,
  });
}
