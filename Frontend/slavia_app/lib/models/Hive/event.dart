// ignore_for_file: non_constant_identifier_names


import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 3)
class Event extends HiveObject{
  Event({required this.id, required this.fixture_id, required this.time, required this.team, required this.player, required this.assist, required this.type});


  @HiveField(0)
  late String id;

  @HiveField(1)
  late int fixture_id;

  @HiveField(2)
  late int time;

  @HiveField(3)
  late int team;

  @HiveField(4)
  late String player;

  @HiveField(5)
  late String assist;

  @HiveField(6)
  late String type;

  /*@HiveField(4)
  late List<Map<String, dynamic>> a;*/

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"] as String,
      fixture_id: json["fixture_id"] as int,
      time: json["time"] as int,
      team:  json["team"] as int,
      player:  json["player"] as String,
      assist:  json["assist"] as String,
      type:  json["type"] as String,
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'fixture_id': fixture_id, 'time': time, 'team': team, 'player': player, 'assist': assist, 'type': type};

  @override 
  String toString() {
    return 'Event{id: $id, fixture_id: $fixture_id, time: $time, team: $team, player: $player, assist: $assist, type: $type}';
  }
  
}