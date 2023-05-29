// ignore_for_file: non_constant_identifier_names
import 'package:hive/hive.dart';

part 'post.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject{
  Post({required this.id, required this.date, required this.title, required this.text, required this.tag, required this.image_url, required this.url});


  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String date;
  
  @HiveField(2)
  late String title;

  @HiveField(3)
  late String text;

  @HiveField(4)
  late String tag;

  @HiveField(5)
  late String image_url;

  @HiveField(6)
  late String url;

  /*@HiveField(4)
  late List<Map<String, dynamic>> a;*/

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] as String,
      date: json["date"] as String,
      title: json["title"] as String,
      text:  json["text"] as String,
      tag: json["tag"] as String,
      image_url: json["image_url"] as String,
      url: json["url"] as String,
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'title': title, 'text': text, 'tag': tag, 'image_url': image_url, 'url': url};

  @override 
  String toString() {
    return 'Post{id: $id, date: $date, title: $title, text: $text, tag: $tag, image_url: $image_url, url: $url}';
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