// ignore_for_file: non_constant_identifier_names, prefer_conditional_assignment

import 'dart:async';
import 'dart:io';
import 'package:slavia_app/models/Hive/comment.dart';
import 'package:slavia_app/models/Hive/player_lineup.dart';
import 'package:slavia_app/models/Hive/post.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:slavia_app/models/Local/LocalStorage.dart';




const serverAdress = "slavia.techbrick.cz";



Future<void> getPost() async {
    var updateDateBox = Hive.box("updatedData");
    var box_post = Hive.box("post");
    var updateDate= updateDateBox.get("post");
    var body = jsonEncode({"last_updated": updateDate});
    //var url = Uri.http('10.143.103.78:8000', 'api/app/getposts');
    var url = Uri.http(serverAdress, 'api/app/getposts');
    try {
      var response = await http.post(url,body: body, headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 5), onTimeout: () {
        return http.Response("Server not responding", 408);
      },);
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode} of Post');
        String responseBody = response.body;
        var jsonbody = json.decode(responseBody);
        var currentData = List<Post>.from(box_post.values.toList());
        if (jsonbody['response'] != []) {
        for (var y in jsonbody['response']) {
          var lenght = box_post.values.length;
          currentData.insert(lenght, Post(id: y["id"],date: y["date"], title: y["title"], text: y["text"], tag : y["tag"], image_url: y["image_url"], url: y["url"]));

        }
        }
        await box_post.clear();
        await box_post.addAll(currentData);
        DateTime now =  DateTime.now().toUtc();
        var date =  DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
        await updateDateBox.delete("post");
        await updateDateBox.put("post", date.toString()); 
        await sortData();
      }
      else {
        sortData();
      }
    } catch (e) {
      if(e is SocketException){
       //treat SocketException
       print("Socket exception: ${e.toString()}");
    }
    else if(e is TimeoutException){
       //treat TimeoutException
       print("Timeout exception: ${e.toString()}");
    }
    else print("Unhandled exception: ${e.toString()}");
    }/*on SocketException catch(e) {
      return null;
    }*/
  }



Future<void> getFutureMatch() async {
    var updateDateBox = Hive.box("updatedData");
    var box_futureMatch = await Hive.box("futurematch");//await Hive.openBox("post");
    var updateDate = updateDateBox.get("futurematch");
    var body = jsonEncode({"last_updated": updateDate});
    var url = Uri.http(serverAdress, 'api/app/getfuturematches');
    try {
    var response = await http.post(url,body: body, headers: {"Content-Type": "application/json"}).timeout(Duration(seconds: 2), onTimeout: () {
        return http.Response("Server not responding", 408);
      },);
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode} of FutureMastch');
      String responseBody = response.body;
      var jsonbody = json.decode(responseBody);
      for (var y in jsonbody['response']) {
        box_futureMatch.put(y["fixture_id"], FutureMatch(id: y["id"],type: y["type"], fixture_id: y["fixture_id"], raw_date: y['raw_date'],  day:int.parse(y["date"]["day"]), year: int.parse(y["date"]["year"]), month: int.parse(y["date"]["month"]), hour: int.parse(y["time"]["hour"]), second: y["time"]["second"].toString(), minutes: y["time"]["minutes"].toString(), place: y["place"], city: y["city"], league: y["league"], round: y["round"], status_short: y["status_short"],status_long: y["status_long"], home_team_id: y["home_team"]["id"], home_team_name: y["home_team"]["name"], home_team_logo: y["home_team"]["logo"], away_team_id: y["away_team"]["id"], away_team_name: y["away_team"]["name"], away_team_logo: y["away_team"]["logo"]));
      }
      DateTime now = DateTime.now().toUtc();
      var date = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
      await updateDateBox.delete("futurematch");
      await updateDateBox.put("futurematch", date.toString());
      await sortFutureMatch();
       await checkOutdatedMatch();
      //await Future.delayed(const Duration(milliseconds: 1000));
    }
    } catch (e) {
      if(e is SocketException){
       //treat SocketException
       print("Socket exception: ${e.toString()}");
    }
    else if(e is TimeoutException){
       //treat TimeoutException
       print("Timeout exception: ${e.toString()}");
    }
    else print("Unhandled exception: ${e.toString()}");
    }/*on SocketException catch(e) {
      return null;
    }*/
}

  Future<void> getMatches() async {
    var updateDateBox = Hive.box("updatedData");
    var box_match = Hive.box<Match>("match");
    var updateDate = updateDateBox.get("match");
    var body = jsonEncode({"last_updated": updateDate});
    var url = Uri.http(serverAdress, 'api/app/getmatches');
    try {
    var response = await http.post(url,body: body, headers: {"Content-Type": "application/json"}).timeout(Duration(seconds: 3),  onTimeout: () {
        print("Nejde");
        return http.Response("Server not responding", 408);
      },);
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode} of Match');
      String responseBody = response.body;
      var jsonbody = json.decode(responseBody);
        for (var x in jsonbody['response']) {
          try {
          var home_color = "fffff";
          var away_color = "fffff";
          var y = x['match'];
          var z = x['events'];
          var w = x['comments'];
          List<PlayerLineup> _listHomeLineup = [];
          List<PlayerLineup> _listHomeSubstitutes = [];
          List<PlayerLineup> _listAwayLineup = [];
          List<PlayerLineup> _listAwaySubstitutes = [];
          List<Comment> _listComments = [];
          List<Event> _listEvents = [];
          for (var c in w) {
            if (c["time"].toString() != ""){
            dynamic  raw_time = c["time"].toString().replaceAll(RegExp("'"), ""); 
            var extend_time = 0;
            var time = 0;
              if (raw_time.toString().contains("+")) {
                var times = raw_time.toString().split("+");
                extend_time = int.parse(times[1]);
                time = int.parse(times[0]);
                raw_time = int.parse(times[0]) + int.parse(times[1]);
                _listComments.add(Comment(id: c["id"], date: c["updated_date"], fixture_id: c["fixture_id"], raw_time: raw_time, time: time, description: c["description"], type: c["type"], extend_time: extend_time ));
              }
              else {
                time = int.parse(raw_time);
                _listComments.add(Comment(id: c["id"], date: c["updated_date"], fixture_id: c["fixture_id"], raw_time: int.parse(raw_time), time: time, description: c["description"], type: c["type"], extend_time: extend_time ));
              }
              //_listComments.add(Comment(id: c["id"], fixture_id: c["fixture_id"], raw_time: raw_time, time: raw_time, description: c["description"], type: c["type"], extend_time: extend_time ));
            }
            else {
              _listComments.add(Comment(id: c["id"], date: c["updated_date"], fixture_id: c["fixture_id"], raw_time: 0, time: 0, description: c["description"], type: c["type"], extend_time: 0 ));
            }
          }
          if (y["fixture_id"] == 1024726) {
           print(""); 
          }
          for (var e in z) {
            var player = e["event"]["player"];
            if (e["event"]["player"] == null) {
              player = "Neznámí";
            }
            var time = e["event"]["time"];
            if (e["event"]["time"].toString().contains("+")) {
              time = e["event"]["time"].toString().split("+")[0];
            }
            _listEvents.add(Event(id: e["id"], fixture_id: e["fixture_id"], time: int.parse(time.toString()), team: e["event"]["team"], player: player, assist: e["event"]["assist"], type: e["event"]["type"]));
          }
          if (y["home_team_formation"] != "Není známo") {
            home_color = y["home_team_color"];
            away_color = y["away_team_color"];
            for (var hl in y["home_team_lineups"]) {
              _listHomeLineup.add(PlayerLineup(id: hl["id"], name: hl["name"], number: hl["number"], position: hl["position"], grid: hl["grid"]));
            }
            for (var hs in y["home_team_substitutes"]) {
              _listHomeSubstitutes.add(PlayerLineup(id: hs["id"], name: hs["name"], number: hs["number"], position: hs["position"], grid: hs["grid"]));
            }
            for (var al in y["away_team_lineups"]) {
              _listAwayLineup.add(PlayerLineup(id: al["id"], name: al["name"], number: al["number"], position: al["position"], grid: al["grid"]));
            }
            for (var a in y["away_team_substitutes"]) {
              _listAwaySubstitutes.add(PlayerLineup(id: a["id"], name: a["name"], number: a["number"], position: a["position"], grid: a["grid"]));
            }
          }
          List<Comment> _sortListComments = _listComments;
          _sortListComments.sort((a, b) {
            var a_date = DateTime.parse(a.date);
            var b_date = DateTime.parse(b.date);
              return a.date.compareTo(b.date);
          },);
          await box_match.put(y["fixture_id"],Match(id: y["id"],type: y["type"], fixture_id: y["fixture_id"], day:int.parse(y["date"]["day"]), year: int.parse(y["date"]["year"]), month: int.parse(y["date"]["month"]), hour: int.parse(y["time"]["hour"]), second: y["time"]["second"].toString(), minutes: y["time"]["minutes"].toString(), place: y["place"], city: y["city"], league: y["league"], round: y["round"], status_short: y["status_short"],status_long: y["status_long"], home_team_id: y["home_team"]["id"], home_team_name: y["home_team"]["name"], home_team_logo: y["home_team"]["logo"], home_team_goals: y["home_team"]["goals"], away_team_id: y["away_team"]["id"], away_team_name: y["away_team"]["name"], away_team_logo: y["away_team"]["logo"], away_team_goals: y["away_team"]["goals"], events: _listEvents, live: y["live"], elapsed: y["elapsed"], comments: _sortListComments, home_formation: y["home_team_formation"], home_lineups: _listHomeLineup, home_substitutes: _listHomeSubstitutes, away_formation: y["away_team_formation"], away_lineups: _listAwayLineup, away_substitutes: _listAwaySubstitutes, home_color: home_color, away_color: away_color));
        } catch (e) {
          
        }
      } 
      DateTime now = DateTime.now().toUtc();
      var date = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
      updateDateBox.delete("match");
      updateDateBox.put("match", date.toString());
      await sortMatch();
    }
    } catch (e) {
      if(e is SocketException){
       //treat SocketException
       print("Socket exception: ${e.toString()}");
    }
    else if(e is TimeoutException){
       //treat TimeoutException
       print("Timeout exception: ${e.toString()}");
    }
    else print("Unhandled exception: ${e.toString()}");
    }/*on SocketException catch(e) {
      return null;
    }*/

  }



  Future<void> getVideos() async {
    var url = Uri.http(serverAdress, 'api/app/getvideos');
    try {
      var response = await http.get(url, headers: {"Content-Type": "application/json"}).timeout(Duration(seconds: 5), onTimeout: () {
          return http.Response("Server not responding", 408);
        },);
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode} of Video');
        String responseBody = response.body;
        var jsonbody = json.decode(responseBody);
        videos = [];
        for (var v in jsonbody['response']) {
          videos.add(Video(videoID: v['videoID'], thumbnail: v['thumbnail'], title: v['title'], description: v['description'], publishedTime: v['publishedTime'], lengthVideo: v['lengthVideo'], viewCount: v['viewCount']));
        }
      }
    } catch (e) {
      if(e is SocketException){
       //treat SocketException
       print("Socket exception: ${e.toString()}");
    }
    else if(e is TimeoutException){
       //treat TimeoutException
       print("Timeout exception: ${e.toString()}");
    }
    else print("Unhandled exception: ${e.toString()}");
    }/*on SocketException catch(e) {
      return null;
    }*/
  }

Future<void> getForumPost(int from, int to) async {
    var body = jsonEncode({"from": from, "to": to});
    var url = Uri.http(serverAdress, 'api/forum/posts');
    try {
      var response = await http.post(url,body: body, headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 2), onTimeout: () {
        forumPost_enable = false;
        return http.Response("Server not responding", 408);
      },);
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode} of Post');
        String responseBody = response.body;
        var jsonbody = json.decode(responseBody);
        if (jsonbody['response'] != []) {
        for (var y in jsonbody['response']) {
          var tag = y["tag"];
          if (tag != null) {
            if (forumTags.contains(tag) == false) {
              forumTags.add(tag);
            }
          }
          else {
            tag = "";
          }
          forumPosts.add(ForumPost(id: y["id"], user_id: y["user_id"], username: y["username"], title: y["title"], text: y["text"], child_count: y["child_count"], upvote: y["upvote"], downvote: y["downvote"], date: DateTime.parse(y["updated_date"]), tag: tag));
        }
        forumPosts_backup = forumPosts;
        }
      }
    } catch (e) {
      forumPost_enable = false;
      if(e is SocketException){
       //treat SocketException
       print("Socket exception: ${e.toString()}");
    }
    else if(e is TimeoutException){
       //treat TimeoutException
       print("Timeout exception: ${e.toString()}");
    }
    else print("Unhandled exception: ${e.toString()}");
    }/*on SocketException catch(e) {
      return null;
    }*/
  }
Future<List<ForumComment>> getForumComment(String parent_id) async {
    var body = jsonEncode({"parent_id": parent_id});
    var url = Uri.http(serverAdress, 'api/forum/comment');
    List<ForumComment> listComents = [];
    try {
      var response = await http.post(url,body: body, headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 2), onTimeout: () {
        return http.Response("Server not responding", 408);
      },);
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode} of Comment');
        String responseBody = response.body;
        var jsonbody = json.decode(responseBody);
        if (jsonbody['response'] != []) {
        for (var y in jsonbody['response']) {
          listComents.add(ForumComment(parent_id: y["parent_id"], id: y["id"], user_id: y["user_id"], username: y["username"], text: y["text"], child_count: y["child_count"], upvote: y["upvote"], downvote: y["downvote"]));
        }
        }
      }
    return listComents;
    } catch (e) {
      if(e is SocketException){
        return listComents;
       //treat SocketException
       print("Socket exception: ${e.toString()}");
    }
    else if(e is TimeoutException){
      return listComents;
       //treat TimeoutException
       print("Timeout exception: ${e.toString()}");
    }
    else return listComents; print("Unhandled exception: ${e.toString()}");
    }/*on SocketException catch(e) {
      return null;
    }*/
  }

  Future<void> createForumComment(String parent_id, String post_id, text) async {
    var user_setting = Hive.box("user_setting");
    var username = user_setting.get("username");
    var user_id = user_setting.get("user_id");
    var body = jsonEncode({"parent_id": parent_id, "post_id": post_id, "username": username, "user_id": user_id, "text": text});
    var url = Uri.http(serverAdress, 'api/forum/create_comment');
    try {
      var response = await http.post(url,body: body, headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 2), onTimeout: () {
        return http.Response("Server not responding", 408);
      },);
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode} of Create-Comment');
      }
    } catch (e) {
      if(e is SocketException){
       //treat SocketException
       print("Socket exception: ${e.toString()}");
    }
    else if(e is TimeoutException){
       //treat TimeoutException
       print("Timeout exception: ${e.toString()}");
    }
    else print("Unhandled exception: ${e.toString()}");
    }/*on SocketException catch(e) {
      return null;
    }*/
  }


  Future<void> createForumPost(String title, String text, String tag) async {
    var user_setting = Hive.box("user_setting");
    var username = user_setting.get("username");
    var user_id = user_setting.get("user_id");
    var body = jsonEncode({"user_id": user_id, "username": username, "title": title, "text": text, "tag": tag});
    var url = Uri.http(serverAdress, 'api/forum/create_post');
    try {
      var response = await http.post(url,body: body, headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 2), onTimeout: () {
        return http.Response("Server not responding", 408);
      },);
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode} of Create-Comment');
      }
    } catch (e) {
      if(e is SocketException){
       //treat SocketException
       print("Socket exception: ${e.toString()}");
    }
    else if(e is TimeoutException){
       //treat TimeoutException
       print("Timeout exception: ${e.toString()}");
    }
    else print("Unhandled exception: ${e.toString()}");
    }/*on SocketException catch(e) {
      return null;
    }*/
  }



  Future<void> sortData() async {
    var box_post = Hive.box("post");
    var box_match = Hive.box<Match>("match");
    tabList1 = [];
    tabList2 = [];
    tabList3 = [];
    tabList4 = [];
    tabList5 = [];
    tabList1.addAll(box_post.values
        .where((Post) => Post.tag == "A tým")
        .toList().reversed);
    tabList2.addAll(box_post.values
      .where((Post) => Post.tag == "B tým")
      .toList().reversed);
    tabList3.addAll(box_post.values
      .where((Post) => Post.tag == "Mládež")
      .toList().reversed);
    tabList4.addAll(box_post.values
      .where((Post) => Post.tag == "Ženy")
      .toList().reversed);
    tabList5.addAll(box_post.values
      .where((Post) => Post.tag == "Klub")
      .toList().reversed);
      Iterable<Match> live_match = box_match.values.where((Match) => Match.live == true);
  }

  Future<void> sortMatch() async {
    var box_match = Hive.box<Match>("match");
    List<Match> allUnsortedData = box_match.values.toList();
    List<Match> unsortedData = allUnsortedData.where((element) => element.type == nowMatchType).toList();
    unsortedData.sort((a, b) {
      var a_date = DateTime(a.year, a.month, a.day, a.hour, int.parse(a.minutes), 0);//DateTime.parse(a_rawDate);
      var b_date = DateTime(b.year, b.month, b.day, b.hour, int.parse(b.minutes), 0);
      return b_date.compareTo(a_date);
    });
    sortMatches = unsortedData;
    List<Match> searchLive = box_match.values.where((Match) => Match.live == true).toList();
    //print(searchLive.length);
    if (searchLive.length != 0) {
      live_match = searchLive[0];
    }
    else {
      live_match = null;
    }

  }
  Future<void> sortFutureMatch() async {
    var box_futurematch = Hive.box("futurematch");
    List<dynamic> allUnsortedData = box_futurematch.values.toList();
    List unsortedData = allUnsortedData.where((element) => element.type == nowMatchType).toList();
    unsortedData.sort((a, b) {
      var a_date = DateTime(a.year, a.month, a.day, a.hour, int.parse(a.minutes), 0);//DateTime.parse(a_rawDate);
      var b_date = DateTime(b.year, b.month, b.day, b.hour, int.parse(b.minutes), 0);//DateTime.parse(b_rawDate);
      return a_date.compareTo(b_date);
    });
    sortFutureMatches = unsortedData;

  }

  Future<void> sortForumPost(int index) async {
    if (index == 0) { 
      List<ForumPost> unsortedData = forumPosts;
      unsortedData.sort((a, b) {
        //var a_date = DateTime(a.year, a.month, a.day, a.hour, int.parse(a.minutes), 0);//DateTime.parse(a_rawDate);
        //var b_date = DateTime(b.year, b.month, b.day, b.hour, int.parse(b.minutes), 0);//DateTime.parse(b_rawDate);
        return b.date.compareTo(a.date);
      });
      forumPosts = unsortedData;
    }
  }
  Future<void> filterForumPost(List<String> tags) async {
      if (tags.length != 0) {
        var unsortedData = forumPosts_backup;
        //[560, 8618, 10923].any((x) => widget.home_team_id == x)
        //tags.any((element) => tag.tag == element)
        var data = unsortedData.where((element) => tags.contains(element.tag)).toList();
        /*unsortedData.where((tag) {
          if (tags.any((element) => tag.tag == element)) {
            return true;
          }
          else {
            return false;
          }
          //return tags.any((element) => tag.tag == element);
        });*/

        forumPosts = data;
    }
    else {
      forumPosts = forumPosts_backup;
    }
  }
  Future<void> sortTeamMatch(int index) async {
    if (index == 0) { 
      var box_match = Hive.box<Match>("match");
      List<Match> unsortedData = box_match.values.toList();
      sortMatches = unsortedData;
    }
  }

  Future<void> checkOutdatedMatch() async {
    var  box_futurematch = Hive.box("futurematch");
    List unsortedData = box_futurematch.values.toList();
    List<dynamic> outdatedMatchs = box_futurematch.values.where((element) {
      var now_date = DateTime.now();
      var date = DateTime.parse(element.raw_date);
      if (now_date.isAfter(date)){
        return true;
      }
      else {return false;}//now_date.isAfter(now_date);
    }).toList();
    if (outdatedMatchs.length != 0) {
      for (var o in outdatedMatchs) {
        await box_futurematch.delete(o.fixture_id);
      }
    }

  }