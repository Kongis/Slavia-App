// ignore_for_file: non_constant_identifier_names


import 'package:hive/hive.dart';

part 'player_lineup.g.dart';

@HiveType(typeId: 5)
class PlayerLineup extends HiveObject{
  PlayerLineup({required this.id, required this.name, required this.number,required this.position, required this.grid});


  @HiveField(0)
  late int id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int number;

  @HiveField(3)
  late dynamic position;

  @HiveField(4)
  late dynamic grid;

  /*@HiveField(4)
  late List<Map<String, dynamic>> a;*/

  factory PlayerLineup.fromJson(Map<String, dynamic> json) {
    return PlayerLineup(
      id: json["id"] as int,
      name: json["name"] as String,
      number: json["number"] as int,
      position: json["position"] as dynamic,
      grid:  json["grid"] as dynamic,
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'number': number,'position': position, 'grid': grid};

  @override 
  String toString() {
    return 'Event{id: $id, name: $name, number: $number, position:  $position, grid: $grid}';
  }
  
}