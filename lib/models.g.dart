// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 1;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      id: fields[0] as String,
      name: fields[1] as String,
      nickname: fields[2] as String,
      teamId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.nickname)
      ..writeByte(3)
      ..write(obj.teamId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamAdapter extends TypeAdapter<Team> {
  @override
  final int typeId = 2;

  @override
  Team read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Team(
      id: fields[0] as String,
      name: fields[1] as String,
      playerIds: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Team obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.playerIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 3;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      name: fields[1] as String,
      mahjongType: fields[2] as MahjongType,
      isTeamCompetition: fields[3] as bool,
      totalScoreCheck: fields[4] as int,
      originPoint: fields[5] as int,
      positionPoints: (fields[6] as Map).cast<int, int>(),
      isScoreCheckEnabled: fields[8] as bool,
      playerColumns: (fields[7] as List?)?.cast<ColumnConfig>(),
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.mahjongType)
      ..writeByte(3)
      ..write(obj.isTeamCompetition)
      ..writeByte(4)
      ..write(obj.totalScoreCheck)
      ..writeByte(5)
      ..write(obj.originPoint)
      ..writeByte(6)
      ..write(obj.positionPoints)
      ..writeByte(7)
      ..write(obj.playerColumns)
      ..writeByte(8)
      ..write(obj.isScoreCheckEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameRecordAdapter extends TypeAdapter<GameRecord> {
  @override
  final int typeId = 4;

  @override
  GameRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameRecord(
      timestamp: fields[0] as DateTime,
      score: fields[1] as int,
      placement: fields[2] as int,
      calculatedScore: fields[3] as double,
      playerId: fields[4] as String,
      eventId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GameRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.placement)
      ..writeByte(3)
      ..write(obj.calculatedScore)
      ..writeByte(4)
      ..write(obj.playerId)
      ..writeByte(5)
      ..write(obj.eventId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MahjongTypeAdapter extends TypeAdapter<MahjongType> {
  @override
  final int typeId = 0;

  @override
  MahjongType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MahjongType.threePlayer;
      case 1:
        return MahjongType.fourPlayer;
      default:
        return MahjongType.threePlayer;
    }
  }

  @override
  void write(BinaryWriter writer, MahjongType obj) {
    switch (obj) {
      case MahjongType.threePlayer:
        writer.writeByte(0);
        break;
      case MahjongType.fourPlayer:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MahjongTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
