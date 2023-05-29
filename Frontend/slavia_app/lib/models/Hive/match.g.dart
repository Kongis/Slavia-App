// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchAdapter extends TypeAdapter<Match> {
  @override
  final int typeId = 2;

  @override
  Match read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Match(
      id: fields[0] as String,
      type: fields[1] as int,
      fixture_id: fields[2] as int,
      day: fields[3] as int,
      year: fields[4] as int,
      month: fields[5] as int,
      hour: fields[6] as int,
      second: fields[7] as String,
      minutes: fields[8] as String,
      place: fields[9] as String,
      city: fields[10] as String,
      league: fields[11] as String,
      round: fields[12] as String,
      status_short: fields[13] as String,
      status_long: fields[14] as String,
      home_team_id: fields[15] as int,
      home_team_name: fields[16] as String,
      home_team_logo: fields[17] as String,
      home_team_goals: fields[18] as int,
      away_team_id: fields[19] as int,
      away_team_name: fields[20] as String,
      away_team_logo: fields[21] as String,
      away_team_goals: fields[22] as int,
      events: (fields[23] as List).cast<Event>(),
      live: fields[24] as bool,
      elapsed: fields[25] as String,
      comments: fields[26] == null ? [] : (fields[26] as List).cast<Comment>(),
      home_lineups:
          fields[27] == null ? [] : (fields[27] as List).cast<PlayerLineup>(),
      home_substitutes:
          fields[28] == null ? [] : (fields[28] as List).cast<PlayerLineup>(),
      home_formation: fields[29] == null ? 'Není známo' : fields[29] as String,
      away_lineups:
          fields[31] == null ? [] : (fields[31] as List).cast<PlayerLineup>(),
      away_substitutes:
          fields[32] == null ? [] : (fields[32] as List).cast<PlayerLineup>(),
      away_formation: fields[33] == null ? 'Není známo' : fields[33] as String,
      home_color: fields[30] == null ? 'ffffff' : fields[30] as String,
      away_color: fields[34] == null ? 'ffffff' : fields[34] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Match obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.fixture_id)
      ..writeByte(3)
      ..write(obj.day)
      ..writeByte(4)
      ..write(obj.year)
      ..writeByte(5)
      ..write(obj.month)
      ..writeByte(6)
      ..write(obj.hour)
      ..writeByte(7)
      ..write(obj.second)
      ..writeByte(8)
      ..write(obj.minutes)
      ..writeByte(9)
      ..write(obj.place)
      ..writeByte(10)
      ..write(obj.city)
      ..writeByte(11)
      ..write(obj.league)
      ..writeByte(12)
      ..write(obj.round)
      ..writeByte(13)
      ..write(obj.status_short)
      ..writeByte(14)
      ..write(obj.status_long)
      ..writeByte(15)
      ..write(obj.home_team_id)
      ..writeByte(16)
      ..write(obj.home_team_name)
      ..writeByte(17)
      ..write(obj.home_team_logo)
      ..writeByte(18)
      ..write(obj.home_team_goals)
      ..writeByte(19)
      ..write(obj.away_team_id)
      ..writeByte(20)
      ..write(obj.away_team_name)
      ..writeByte(21)
      ..write(obj.away_team_logo)
      ..writeByte(22)
      ..write(obj.away_team_goals)
      ..writeByte(23)
      ..write(obj.events)
      ..writeByte(24)
      ..write(obj.live)
      ..writeByte(25)
      ..write(obj.elapsed)
      ..writeByte(26)
      ..write(obj.comments)
      ..writeByte(27)
      ..write(obj.home_lineups)
      ..writeByte(28)
      ..write(obj.home_substitutes)
      ..writeByte(29)
      ..write(obj.home_formation)
      ..writeByte(30)
      ..write(obj.home_color)
      ..writeByte(31)
      ..write(obj.away_lineups)
      ..writeByte(32)
      ..write(obj.away_substitutes)
      ..writeByte(33)
      ..write(obj.away_formation)
      ..writeByte(34)
      ..write(obj.away_color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
