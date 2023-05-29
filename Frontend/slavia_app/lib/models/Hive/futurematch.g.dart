// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'futurematch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FutureMatchAdapter extends TypeAdapter<FutureMatch> {
  @override
  final int typeId = 1;

  @override
  FutureMatch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FutureMatch(
      id: fields[0] as String,
      type: fields[1] as int,
      fixture_id: fields[2] as int,
      raw_date: fields[3] as String,
      day: fields[4] as int,
      year: fields[5] as int,
      month: fields[6] as int,
      hour: fields[7] as int,
      second: fields[8] as String,
      minutes: fields[9] as String,
      place: fields[10] as String,
      city: fields[11] as String,
      league: fields[12] as String,
      round: fields[13] as String,
      status_short: fields[14] as String,
      status_long: fields[15] as String,
      home_team_id: fields[16] as int,
      home_team_name: fields[17] as String,
      home_team_logo: fields[18] as String,
      away_team_id: fields[19] as int,
      away_team_name: fields[20] as String,
      away_team_logo: fields[21] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FutureMatch obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.fixture_id)
      ..writeByte(3)
      ..write(obj.raw_date)
      ..writeByte(4)
      ..write(obj.day)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.month)
      ..writeByte(7)
      ..write(obj.hour)
      ..writeByte(8)
      ..write(obj.second)
      ..writeByte(9)
      ..write(obj.minutes)
      ..writeByte(10)
      ..write(obj.place)
      ..writeByte(11)
      ..write(obj.city)
      ..writeByte(12)
      ..write(obj.league)
      ..writeByte(13)
      ..write(obj.round)
      ..writeByte(14)
      ..write(obj.status_short)
      ..writeByte(15)
      ..write(obj.status_long)
      ..writeByte(16)
      ..write(obj.home_team_id)
      ..writeByte(17)
      ..write(obj.home_team_name)
      ..writeByte(18)
      ..write(obj.home_team_logo)
      ..writeByte(19)
      ..write(obj.away_team_id)
      ..writeByte(20)
      ..write(obj.away_team_name)
      ..writeByte(21)
      ..write(obj.away_team_logo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FutureMatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
