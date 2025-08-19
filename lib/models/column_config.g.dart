// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColumnConfigAdapter extends TypeAdapter<ColumnConfig> {
  @override
  final int typeId = 5;

  @override
  ColumnConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColumnConfig(
      columnName: fields[0] as String,
      dataKey: fields[1] as String,
      isVisible: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ColumnConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.columnName)
      ..writeByte(1)
      ..write(obj.dataKey)
      ..writeByte(2)
      ..write(obj.isVisible);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
