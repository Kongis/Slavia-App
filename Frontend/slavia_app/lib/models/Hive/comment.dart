// ignore_for_file: non_constant_identifier_names


import 'package:hive/hive.dart';

part 'comment.g.dart';

@HiveType(typeId: 4)
class Comment extends HiveObject{
  Comment({required this.id, required this.date, required this.fixture_id, required this.raw_time,required this.time, required this.description, required this.type, required this.extend_time});


  @HiveField(0)
  late String id;

  @HiveField(1)
  late String date;

  @HiveField(2)
  late int fixture_id;

  @HiveField(3, defaultValue: 0, )
  late int raw_time;

  @HiveField(4, defaultValue: 0)
  late int time;

  @HiveField(5)
  late String description;

  @HiveField(6)
  late String type;

  @HiveField(7, defaultValue: 0)
  late int extend_time;

  /*@HiveField(4)
  late List<Map<String, dynamic>> a;*/

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"] as String,
      date: json["date"] as String,
      fixture_id: json["fixture_id"] as int,
      raw_time: json["raw_time"] as int,
      time: json["time"] as int,
      description:  json["description"] as String,
      type:  json["type"] as String,
      extend_time:  json["extend_time"] as int,
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'fixture_id': fixture_id, 'raw_time': raw_time,'time': time, 'description': description, 'type': type, 'extend_time': extend_time};

  @override 
  String toString() {
    return 'Event{id: $id,date $date, fixture_id: $fixture_id, raw_time: $raw_time,time:  $time, description: $description, type: $type}, extend_time: $extend_time';
  }
  
}