// ignore_for_file: empty_constructor_bodies

import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'package:slavia_app/utils/api_services.dart';

class OnboardingItem {
  final String title, description, background;
  OnboardingItem({
    required this.title,
    required this.description,
    required this.background
  });
}

class SettingItem {
  final String title, icon;
  final int type;
  final void function;
  SettingItem({
    required this.title,
    required this.icon,
    required this.type,
    required this.function
  });
}

class ForumPost {
  final String id, user_id,username, title,text, tag;
  final int child_count, upvote,downvote;
  final DateTime date;
  ForumPost({
    required this.id,
    required this.user_id,
    required this.username,
    required this.title,
    required this.text,
    required this.child_count,
    required this.upvote,
    required this.downvote,
    required this.date,
    required this.tag
  });
}
class ForumTag {
  final String text;
  ForumTag({
    required this.text
  });
}

class ForumComment {
  final String id, user_id,username,text, parent_id;
  final int child_count, upvote,downvote;
  ForumComment({
    required this.id,
    required this.user_id,
    required this.parent_id,
    required this.username,
    required this.text,
    required this.child_count,
    required this.upvote,
    required this.downvote,
  });
}


class Video {
  final String videoID;

  final String thumbnail;

  final String title;

  final String description;

  final String publishedTime;

  final String  lengthVideo;

  final String viewCount;

  Video(
    {
      required this.videoID,
      required this.thumbnail,
      required this.title,
      required this.description,
      required this.publishedTime,
      required this.lengthVideo,
      required this.viewCount,
    }
  );

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoID: json["videoID"] as String,
      thumbnail: json["thumbnail"] as String,
      title: json["title"] as String,
      description:  json["description"] as String,
      publishedTime: json["publishedTime"] as String,
      lengthVideo: json["lengthVideo"] as String,
      viewCount: json["viewCount"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'videoID': videoID, 
    'thumbnail': thumbnail, 
    'title': title, 
    'description': description, 
    'publishedTime': publishedTime, 
    'lengthVideo': lengthVideo, 
    'viewCount': viewCount
  };

}
List<OnboardingItem> onboarding_items= [
  OnboardingItem(
    title: "Nejnovější informace o tvém klubu", 
    description: "Nalezneš zde všechny slávistické články i videa", 
    background: "assets/other/slide1.json"),
    OnboardingItem(
    title: "Všechny zápasy na jednom místě", 
    description: "Nadcházející i proběhlé, v aplikaci najdeš veškeré informace ke každému zápasu", 
    background: "assets/other/slide2.json"),
    OnboardingItem(
    title: "Živé zápasy s komentářem a časovou osou", 
    description: "", 
    background: "assets/other/slide3.json")
];
List<SettingItem> setting_items = [
  SettingItem(title: "", icon: "", type: 0, function: sortData()),
  SettingItem(title: "", icon: "", type: 0, function: sortData()),
  SettingItem(title: "", icon: "", type: 0, function: sortData()),
  SettingItem(title: "", icon: "", type: 0, function: sortData()),
  SettingItem(title: "", icon: "", type: 0, function: sortData()),
  SettingItem(title: "", icon: "", type: 0, function: sortData()),
  SettingItem(title: "", icon: "", type: 0, function: sortData()),
  SettingItem(title: "", icon: "", type: 0, function: sortData()),
  SettingItem(title: "", icon: "", type: 0, function: sortData())
  
];
List<ForumPost> forumPosts = [];
List<ForumPost> myForumPosts = [];
List<ForumPost> forumPosts_backup = [];
bool forumPost_enable = true;
List<String> forumTags = [];
List<Video> videos = [];
List<dynamic> tabList1 = [];
List<dynamic> tabList2 = [];
List<dynamic> tabList3 = [];
List<dynamic> tabList4 = [];
List<dynamic> tabList5 = [];
List<Match> listMatch = [];

Match? live_match = null;
var neco = null;
var nowMatchType = 1;
Map<String, String?>? payload = {};
Map<String, dynamic> data_homepage = {
  "bottom_index": "0",
  "tab_bar_index": '0',
};
bool updatedData = false;
bool clickedNotification = false;
String clickedNotificationData = "";
String clickedNotificationPath = "";
bool notificationAllow = false;
String pushData = "";
int matches_tabbar_index = 0;
bool showOnboardScreen = false;
List<Match> sortMatches = [];
List<dynamic> sortFutureMatches = [];
List<Match> sortMatches_B= [];
List<dynamic> sortFutureMatches_B = [];
List<Match> sortMatches_W = [];
List<dynamic> sortFutureMatches_W = [];
List<Match> sortMatches_U19 = [];
List<dynamic> sortFutureMatches_U19 = [];
class MatchData {
  final int fixture_id;
  final int type;
  final String league;
  final String place;
  final int home_team_id;
  final String home_team_name;
  final int home_team_goals;
  final String home_team_logo;
  final int away_team_id;
  final String away_team_name;
  final int away_team_goals;
  final String away_team_logo;
  final int year;
  final int month;
  final int day;
  final int hour;
  final String minutes;
  final bool winner;
  final bool home;





  MatchData({
    required this.fixture_id,
    required this.type,
    required this.league,
    required this.place,
    required this.home_team_id,
    required this.home_team_name,
    required this.home_team_goals,
    required this.home_team_logo,
    required this.away_team_id,
    required this.away_team_name,
    required this.away_team_goals,
    required this.away_team_logo,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minutes,
    required this.winner,
    required this.home,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      fixture_id: json["id"] as int,
      type: json["type"] as int,
      league: json["league"] as String,
      place: json["place"] as String,
      home_team_id: json["place"] as int,
      home_team_name: json["home_team_name"] as String,
      home_team_goals: json["home_team_goals"] as int,
      home_team_logo: json["home_team_logo"] as String,
      away_team_id: json["away_team_id"] as int,
      away_team_name: json["away_team_name"] as String,
      away_team_goals: json["away_team_goals"] as int,
      away_team_logo: json["away_team_logo"] as String,
      year: json["year"] as int,
      month: json["month"] as int,
      day: json["day"] as int,
      hour: json["hour"] as int,
      minutes: json["minutes"] as String,
      winner: json["winner"] as bool,
      home: json["home"] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': fixture_id,
    'type': type,
    'league': league,
    'place': place,
    'home_team_id': home_team_id,
    'home_team_name': home_team_name,
    'home_team_goals': home_team_goals,
    'home_team_logo': home_team_goals,
    'away_team_id': away_team_id,
    'away_team_name': away_team_name,
    'away_team_goals': away_team_goals,
    'away_team_logo': away_team_logo,
    'year': year,
    'month': month,
    'day': day
  };
}

//late MatchData matchdata;