import 'package:hive/hive.dart';

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

  Event({
    required this.id,
    required this.name,
    required this.mahjongType,
    required this.isTeamCompetition,
    required this.totalScoreCheck,
    required this.originPoint,
    required this.positionPoints,
  });
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
