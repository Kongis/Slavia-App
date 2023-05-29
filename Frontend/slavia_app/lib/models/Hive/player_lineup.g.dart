// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_lineup.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerLineupAdapter extends TypeAdapter<PlayerLineup> {
  @override
  final int typeId = 5;

  @override
  PlayerLineup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerLineup(
      id: fields[0] as int,
      name: fields[1] as String,
      number: fields[2] as int,
      position: fields[3] as dynamic,
      grid: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerLineup obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.grid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerLineupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
