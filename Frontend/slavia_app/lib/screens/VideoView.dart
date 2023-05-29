// ignore_for_file: unused_import, prefer_final_fields

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:slavia_app/models/match-model.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:flutter_date_difference/flutter_date_difference.dart';
import 'package:flutter/services.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import "package:hexcolor/hexcolor.dart";
import 'package:slavia_app/models/post-model.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slavia_app/utils/app_router.dart';
import 'package:go_router/go_router.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
class VideoView extends ConsumerStatefulWidget {
  final String? videoID;
  const VideoView({super.key, required this.videoID});

  @override
  ConsumerState<VideoView> createState() => _VideoView();
}

class _VideoView extends ConsumerState<VideoView> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;



  /*YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: widget.videoID,
    // ignore: prefer_const_constructors 
    flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
    ),
  );*/

  @override
  void initState() {
    /*String url = widget.videoID!;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: url,
      autoPlay: true,
      params: const YoutubePlayerParams(
        enableCaption: false,
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      )
    ); */
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoID!,
      flags: const YoutubePlayerFlags(
        useHybridComposition: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: false,
        controlsVisibleAtStart: true,
      ),
    );/*..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;*/
  }
  /*void deactivate() {
    _controller.dispose();
    super.deactivate();
  }*/

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouteProvider);
    return WillPopScope(
      onWillPop: () {
        router.goNamed("video");
        return Future(() => false,);
      },
      child: YoutubePlayerBuilder(       
        player: YoutubePlayer(
          controller: _controller,
        ), 
        builder: ((context, player) {
          return Container(
            width: 100.w,
            height: 100.h,
            color: Colors.black,
            child: player,
          );
        })
      ),
    );
    
    /*WillPopScope(
      onWillPop: () {
      //context.goNamed("video");
        return Future(() => true,);
      },
      child: *//*Scaffold(
        appBar: (
          AppBar(
            leading: GestureDetector(child: Icon(Icons.arrow_back_ios, color: Colors.black,), onTap: () {
              router.goNamed("posts");
            //router.goNamed("video");
        },),
          )
        ),
        body: Center(
          child: Text("Ahoj"),
        )
        
        /*YoutubePlayerScaffold(
          autoFullScreen: true,
          aspectRatio: 16 / 9,
          builder: ((context, player) {
            return Container(
              width: 100.w,
              height: 100.h,
              color: Colors.black,
              child: Center(
                child: player,
              ),
            );
          }), 
          controller: _controller
        ),*/
      );*/
    //);
  }
}