// ignore_for_file: unused_import, prefer_final_fields

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:slavia_app/models/match-model.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'package:slavia_app/utils/api_services.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:flutter_date_difference/flutter_date_difference.dart';
import 'package:flutter/services.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import "package:hexcolor/hexcolor.dart";
import 'package:slavia_app/models/post-model.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:slavia_app/models/video-model.dart';
import 'package:animate_do/animate_do.dart';


class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}



class _VideoScreenState extends State<VideoScreen> /*with AutomaticKeepAliveClientMixin*/ {


  Future<void> test() async{
    await Future.delayed(Duration(milliseconds: 200));
  }

  /*@override
  bool get wantKeepAlive => true;*/
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return FadeIn(
            duration: Duration(seconds: 1),
            child: Container(
              width: 100.w,
              height: 100.h,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    child: Container(
                      child: Text("Slavia TV", style: getFont(16.sp, "#00000", FontWeight.w600),),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 76.5.h,
                    child: CustomRefreshIndicator(
                      leadingScrollIndicatorVisible: false,
                            trailingScrollIndicatorVisible: false,
                            builder: MaterialIndicatorDelegate(
                              builder: (context, controller) {
                                return Icon(
                                  FontAwesomeIcons.futbol,
                                  color: HexColor("#e4041f"),
                                  size: 20,
                                );
                              },
                              scrollableBuilder: (context, child, controller) {
                                return Opacity(
                                  opacity: 1.0 - controller.value.clamp(0.0, 1.0),
                                  child: child,
                                );
                              },
                            ),
                            onRefresh:() async {
                              print("Hey");
                              await getVideos();
                            },
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 8.h),
                        itemCount: videos.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        itemBuilder: ((context, index) {
                          Video video = videos[index]; 
                          return ModelVideo(text: video.description, title: video.title, image: video.thumbnail, date: video.publishedTime, url: video.videoID);
                        })
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
    
    
    
    /*FutureBuilder(
      future: test(),
      builder: (context, snapshot) {
        if(ConnectionState.done == snapshot.connectionState) {
          return FadeIn(
            duration: Duration(seconds: 1),
            child: Container(
              width: 100.w,
              height: 100.h,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    child: Container(
                      child: Text("Slavia TV", style: getFont(16.sp, "#00000", FontWeight.w600),),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 76.5.h,
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 8.h),
                      itemCount: videos.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      itemBuilder: ((context, index) {
                        Video video = videos[index]; 
                        return ModelVideo(text: video.description, title: video.title, image: video.thumbnail, date: video.publishedTime, url: video.videoID);
                      })
                    ),
                  )
                ],
              ),
            ),
          );
        } 
        else {
          return Container(child: Center(child: Text("Loading")),);
        }
      },
    );*/
  }
}