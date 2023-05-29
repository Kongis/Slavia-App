// ignore_for_file: non_constant_identifier_names
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/models/Hive/comment.dart';
import 'package:slavia_app/models/Hive/player_lineup.dart';
import 'package:hive/hive.dart';

part 'match.g.dart';

@HiveType(typeId: 2)
class Match extends HiveObject{
  Match({required this.id,required this.type, required this.fixture_id, required this.day, required this.year, required this.month, required this.hour, required this.second, 
  required this.minutes, required this.place, required this.city, required this.league, required this.round, required this.status_short, required this.status_long, 
  required this.home_team_id, required this.home_team_name, required this.home_team_logo, required this.home_team_goals, required this.away_team_id, required this.away_team_name, required this.away_team_logo, 
  required this.away_team_goals, required this.events, required this.live, required this.elapsed, required this.comments, required this.home_lineups, required this.home_substitutes, 
  required this.home_formation, required this.away_lineups, required this.away_substitutes, required this.away_formation, required this.home_color, required this.away_color});


  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late int type;

  @HiveField(2)
  late int fixture_id;
  
  @HiveField(3)
  late int day;

  @HiveField(4)
  late int year;

  @HiveField(5)
  late int month;

  @HiveField(6)
  late int hour;

  @HiveField(7)
  late String second;

  @HiveField(8)
  late String minutes;

  @HiveField(9)
  late String place;

  @HiveField(10)
  late String city;

  @HiveField(11)
  late String league;

  @HiveField(12)
  late String round;

  @HiveField(13)
  late String status_short;

  @HiveField(14)
  late String status_long;

  @HiveField(15)
  late int home_team_id;

  @HiveField(16)
  late String home_team_name;

  @HiveField(17)
  late String home_team_logo;

  @HiveField(18)
  late int home_team_goals;

  @HiveField(19)
  late int away_team_id;

  @HiveField(20)
  late String away_team_name;

  @HiveField(21)
  late String away_team_logo;

  @HiveField(22)
  late int away_team_goals;

  @HiveField(23)
  late List<Event> events;

  @HiveField(24)
  late bool live;

  @HiveField(25)
  late String elapsed;

  @HiveField(26, defaultValue: [])
  late List<Comment> comments;

  @HiveField(27,  defaultValue: [], )
  late List<PlayerLineup> home_lineups;

  @HiveField(28, defaultValue: [])
  late List<PlayerLineup> home_substitutes;

  @HiveField(29, defaultValue: "Není známo")
  late String home_formation;

  @HiveField(30, defaultValue: "ffffff")
  late String home_color;

  @HiveField(31, defaultValue: [])
  late List<PlayerLineup> away_lineups;

  @HiveField(32, defaultValue: [])
  late List<PlayerLineup> away_substitutes;

  @HiveField(33, defaultValue: "Není známo")
  late String away_formation;

  @HiveField(34, defaultValue: "ffffff")
  late String away_color;
  /*@HiveField(4)
  late List<Map<String, dynamic>> a;*/

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json["id"] as String,
      type: json["type"] as int,
      fixture_id: json["fixture_id"] as int,
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
      home_team_goals: json["home_team_goals"] as int,
      away_team_id: json["away_team_id"] as int,
      away_team_name: json["away_team_name"] as String,
      away_team_logo: json["away_team_logo"] as String,
      away_team_goals: json["away_team_goals"] as int,
      events: json["events"] as List<Event>,
      live: json["live"] as bool,
      elapsed: json["elapsed"] as String,
      comments: json['comments'] as List<Comment>,
      home_lineups: json['home_lineups'] as List<PlayerLineup>, 
      home_substitutes: json['home_substitutes'] as List<PlayerLineup>,
      home_formation: json["home_formation"] as String,
      home_color: json["home_color"] as String,
      away_lineups: json['away_lineups'] as List<PlayerLineup>, 
      away_substitutes: json['away_substitutes'] as List<PlayerLineup>,
      away_formation: json["away_formation"] as String,
      away_color: json["away_color"] as String,


    );
  }
  Map<String, dynamic> toJson() => {'id': id,'type': type, 'fixture_id': fixture_id, 'day': day, 'year': year, 'month': month, 'hour': hour, 'second': second, 'minutes': minutes, 'place': place, 'city': city, 'league': league, 'round': round, 'status_short': status_short,'status_long': status_long, 'home_team_id': home_team_id, 'home_team_name': home_team_name, 'home_team_logo': home_team_logo, 'home_team_goals': home_team_goals, 'away_team_id': away_team_id, 'away_team_name': away_team_name, 'away_team_logo': away_team_logo, 'away_team_goals': away_team_goals, 'events': events, 'live': live, 'elapsed': elapsed, 'comments': comments, 'home_lineups': home_lineups, 'home_substitutes': home_substitutes, 'home_formation': home_formation, 'away_lineups': away_lineups, 'away_substitutes': away_substitutes, 'away_formation': away_formation, 'home_color': home_color, 'away_color': away_color};

  @override 
  String toString() {
    return 'Match{id: $id, type: $type, fixture_id: $fixture_id, day: $day, year: $year, month: $month, hour: $hour, second: $second, minutes: $minutes, place: $place, city: $city, league: $league, round: $round, status_short: $status_short, status_long: $status_long, home_team_id: $home_team_id, home_team_name: $home_team_name, home_team_logo: $home_team_logo, home_team_goals: $home_team_goals, away_team_id: $away_team_id, away_team_name: $away_team_name, away_team_logo: $away_team_logo, away_teams_goals: $away_team_goals, events: $events, live: $live, elapsed: $elapsed, comments: $comments, home_lineups: $home_lineups, home_substitutes: $home_substitutes, home_formation: $home_formation, away_lineups: $away_lineups, away_substitutes: $away_substitutes, away_formation: $away_formation, home_color: $home_color, away_color: $away_color';
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