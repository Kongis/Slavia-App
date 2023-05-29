// ignore_for_file: non_constant_identifier_names
import 'package:hive/hive.dart';

part 'futurematch.g.dart';

@HiveType(typeId: 1)
class FutureMatch extends HiveObject{
  FutureMatch({required this.id,required this.type, required this.fixture_id, required this.raw_date, required this.day, required this.year, required this.month, required this.hour, required this.second, 
  required this.minutes, required this.place, required this.city, required this.league, required this.round, required this.status_short, required this.status_long, 
  required this.home_team_id, required this.home_team_name, required this.home_team_logo, required this.away_team_id, required this.away_team_name, required this.away_team_logo});


  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late int type;

  @HiveField(2)
  late int fixture_id;
  
  @HiveField(3)
  late String raw_date;

  @HiveField(4)
  late int day;

  @HiveField(5)
  late int year;

  @HiveField(6)
  late int month;

  @HiveField(7)
  late int hour;

  @HiveField(8)
  late String second;

  @HiveField(9)
  late String minutes;

  @HiveField(10)
  late String place;

  @HiveField(11)
  late String city;

  @HiveField(12)
  late String league;

  @HiveField(13)
  late String round;

  @HiveField(14)
  late String status_short;

  @HiveField(15)
  late String status_long;

  @HiveField(16)
  late int home_team_id;

  @HiveField(17)
  late String home_team_name;

  @HiveField(18)
  late String home_team_logo;

  @HiveField(19)
  late int away_team_id;

  @HiveField(20)
  late String away_team_name;

  @HiveField(21)
  late String away_team_logo;

  /*@HiveField(4)
  late List<Map<String, dynamic>> a;*/

  factory FutureMatch.fromJson(Map<String, dynamic> json) {
    return FutureMatch(
      id: json["id"] as String,
      type: json["type"] as int,
      fixture_id: json["fixture_id"] as int,
      raw_date: json["raw_date"] as String,
      day: json["day"] as int,
      year:  json["year"] as int,
      month: json["month"] as int,
      hour: json["hour"] as int,
      second: json["second"] as String,
      minutes: json["minutes"] as String,
      place: json["place"] as String,
      city: json["city"] as String,
      league: json["league"] as String,
      round: json["round"] as String,
      status_short: json["status_short"] as String,
      status_long: json["status_long"] as String,
      home_team_id: json["home_team_id"] as int,
      home_team_name: json["home_team_name"] as String,
      home_team_logo: json["home_team_logo"] as String,
      away_team_id: json["away_team_id"] as int,
      away_team_name: json["away_team_name"] as String,
      away_team_logo: json["away_team_logo"] as String,

    );
  }
  Map<String, dynamic> toJson() => {'id': id,'type': type, 'fixture_id': fixture_id, 'raw_date': raw_date, 'day': day, 'year': year, 'month': month, 'hour': hour, 'second': second, 'minutes': minutes, 'place': place, 'city': city, 'league': league, 'round': round, 'status_short': status_short,'status_long': status_long, 'home_team_id': home_team_id, 'home_team_name': home_team_name, 'home_team_logo': home_team_logo, 'away_team_id': away_team_id, 'away_team_name': away_team_name, 'away_team_logo': away_team_logo};

  @override 
  String toString() {
    return 'FutureMatch{id: $id, type: $type, fixture_id: $fixture_id, raw_date: $raw_date, day: $day, year: $year, month: $month, hour: $hour, second: $second, minutes: $minutes, place: $place, city: $city, league: $league, round: $round, status_short: $status_short, status_long: $status_long, home_team_id: $home_team_id, home_team_name: $home_team_name, home_team_logo: $home_team_logo, away_team_id: $away_team_id, away_team_name: $away_team_name, away_team_logo: $away_team_logo}';
  }
}

/*
@HiveType(typeId: 0)
class Post extends HiveObject{
  Post({required this.id, required this.text, required this.likes, required this.tags, required this.image_url, required this.userdata});


  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String text;
  
  @HiveField(2)
  late String likes;

  @HiveField(3)
  late List tags;

  @HiveField(4)
  late String image_url;

  @HiveField(5)
  late List<User> userdata;
  /*@HiveField(4)
  late List<Map<String, dynamic>> a;*/

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] as String,
      text: json["text"] as String,
      likes: json["likes"] as String,
      tags:  json["tags"] as List,
      image_url: json["image_url"] as String,
      userdata: json["userdata"] as List<User>
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'likes': likes, 'tags': tags, 'image_url': image_url, 'userdata': userdata};

  @override 
  String toString() {
    return 'Post{id: $id, text: $text, likes: $likes, tags: $tags, image_url: $image_url, userdata: $userdata}';
  }
}
*/


// ignore_for_file: non_constant_identifier_names

/*class FutureMatch {

   final String id;  
   final int fixture_id;
   final int day;
   final int year;
   final int month;
   final int hour;
   final int second;
   final int minutes;
   final String place;
   final String city;
   final String league;
   final String round;
   final String status;
   final int home_team_id;
   final String home_team_name;
   final String home_team_logo;
   final int away_team_id;
   final String away_team_name;
   final String away_team_logo;



  FutureMatch({required this.id, required this.fixture_id, required this.day, required this.year, required this.month, required this.hour, required this.second, 
  required this.minutes, required this.place, required this.city, required this.league, required this.round, required this.status, 
  required this.home_team_id, required this.home_team_name, required this.home_team_logo, required this.away_team_id, required this.away_team_name, required this.away_team_logo});
}*/