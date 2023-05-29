// ignore_for_file: unused_import, file_names, non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:slavia_app/screens/PostView.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/screens/MatchScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:slavia_app/utils/app_router.dart';
import 'package:go_router/go_router.dart';
class ModelFinishMatch extends ConsumerStatefulWidget {
  //const ModelPost({super.key});
  final int fixture_id;
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
  final List<Event> event;
  final int type; // 0 - Win, 1 - Lose, 2 - Draw
  //final VoidCallback showInfo;
  ModelFinishMatch({required this.fixture_id, required this.event, required this.type, required this.home, required this.winner, required this.league, required this.place, required this.home_team_id, required this.home_team_name, required this.home_team_goals , required this.home_team_logo, required this.away_team_id, required this.away_team_name, required this.away_team_goals,  required this.away_team_logo, required this.year, required this.month, required this.day, required this.hour, required this.minutes});

  @override
  ConsumerState<ModelFinishMatch> createState() => _ModelFinishMatchState();
}

class _ModelFinishMatchState extends ConsumerState<ModelFinishMatch> with TickerProviderStateMixin{
  @override
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouteProvider);
    //var eventList = event.where((Event) => Event.type == "Góóól");
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.type == 0) {
          return Padding(
            padding: EdgeInsets.only(top: 2.h, left: 2.w, right:  2.w, bottom: 2.h),
            child: Container(
              child: InkWell(
                onTap: (() {
                  router.goNamed("match_view", params: {'id': widget.fixture_id.toString()}/*extra: MatchData(fixture_id: widget.fixture_id, type: widget.type, home: widget.home, winner: widget.winner, league:  widget.league, place:  widget.place, home_team_id:  widget.home_team_id, home_team_name:  widget.home_team_name, home_team_goals:  widget.home_team_goals, home_team_logo:  widget.home_team_logo, away_team_id:  widget.away_team_id, away_team_name:  widget.away_team_name, away_team_goals:  widget.away_team_goals, away_team_logo:  widget.away_team_logo, year:  widget.year, month:  widget.month, day:  widget.day, hour:  widget.hour, minutes:  widget.minutes)*/);
                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: MatchScreen(type: widget.type, event: widget.event, home: widget.home, winner: widget.winner, league:  widget.league, place:  widget.place, home_team_id:  widget.home_team_id, home_team_name:  widget.home_team_name, home_team_goals:  widget.home_team_goals, home_team_logo:  widget.home_team_logo, away_team_id:  widget.away_team_id, away_team_name:  widget.away_team_name, away_team_goals:  widget.away_team_goals, away_team_logo:  widget.away_team_logo, year:  widget.year, month:  widget.month, day:  widget.day, hour:  widget.hour, minutes:  widget.minutes)));
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 100.w,
                  height: 15.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30.w,
                              height: 13.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Container(
                                      height: 8.h, 
                                      width: 21.w,
                                      child: ExtendedImage.network(
                                        [560, 8618, 10923].any((x) => widget.home_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.home_team_logo,
                                        fit: BoxFit.fitHeight, 
                                        timeLimit: Duration(seconds: 1),
                                        loadStateChanged: (ExtendedImageState state) {
                                          switch (state.extendedImageLoadState) {
                                            case LoadState.loading:
                                              _controller.reset();
                                              return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                            ///if you don't want override completed widget
                                            ///please return null or state.completedWidget
                                            //return null;
                                            //return state.completedWidget;
                                            case LoadState.completed:
                                              _controller.forward();
                                              return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                            case LoadState.failed:
                                              _controller.reset();
                                              return GestureDetector(
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: <Widget>[
                                                    CircularProgressIndicator(color: Colors.green,),
                                                    Positioned(
                                                      bottom: 0.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      child: Text(
                                                        "load image failed, click to reload",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  state.reLoadImage();
                                                },
                                              );
                                          }
                                        },
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Text(widget.home_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),textAlign: TextAlign.center, /*maxLines: 2,minFontSize: 4.sp, stepGranularity: 4.sp,*/), 
                                  )
                                ],
                              ),
                            ),
                            Container(
                              //color: Colors.red,
                              width: 36.w,
                              height: 12.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        /*Container(
                                          child: home ? Text("") : Text("data") 
                                        ),
                                        Container(
                                          child: ,
                                        )*/
                                        Text(widget.home_team_goals.toString(), style: widget.home ? getFont(18.sp, "#50C878", FontWeight.w800) : getFont(18.sp, "#00000", FontWeight.w800)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                                          child: Text("-", style: getFont(15.sp, "#00000", FontWeight.w600),),
                                        ),
                                        Text(widget.away_team_goals.toString(), style: widget.home ? getFont(18.sp, "#00000", FontWeight.w800) : getFont(18.sp, "#50C878", FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Container(
                                      //height: 2.h,
                                      //width: 1.w,
                                      padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 1.w),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[350],
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Text("Detaily", style: getFont(12.sp, "#FFFFFF", FontWeight.w600),),
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 30.w,
                              height: 13.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Container(
                                      height: 8.h, 
                                      width: 21.w,
                                      child: ExtendedImage.network(
                                        [560, 8618, 10923].any((x) => widget.away_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.away_team_logo,
                                        fit: BoxFit.fitHeight, 
                                        timeLimit: Duration(seconds: 1),
                                        loadStateChanged: (ExtendedImageState state) {
                                          switch (state.extendedImageLoadState) {
                                            case LoadState.loading:
                                              _controller.reset();
                                              return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                            ///if you don't want override completed widget
                                            ///please return null or state.completedWidget
                                            //return null;
                                            //return state.completedWidget;
                                            case LoadState.completed:
                                              _controller.forward();
                                              return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                            case LoadState.failed:
                                              _controller.reset();
                                              return GestureDetector(
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: <Widget>[
                                                    CircularProgressIndicator(color: Colors.green,),
                                                    Positioned(
                                                      bottom: 0.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      child: Text(
                                                        "load image failed, click to reload",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  state.reLoadImage();
                                                },
                                              );
                                          }
                                        },
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Text(widget.away_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),textAlign: TextAlign.center), 
                                  )
                  
                                ],
                              ),
                            ),
                          ],
                        ),
                  )
                )
              ),
            ),
          );
        }
        if (widget.type == 1) {
          return Padding(
            padding: EdgeInsets.only(top: 2.h, left: 2.w, right:  2.w, bottom: 2.h),
            child: Container(
              child: InkWell(
                onTap: (() {
                  router.goNamed("match_view", params: {'id': widget.fixture_id.toString()}/*extra: MatchData(fixture_id: widget.fixture_id, type: widget.type, home: widget.home, winner: widget.winner, league:  widget.league, place:  widget.place, home_team_id:  widget.home_team_id, home_team_name:  widget.home_team_name, home_team_goals:  widget.home_team_goals, home_team_logo:  widget.home_team_logo, away_team_id:  widget.away_team_id, away_team_name:  widget.away_team_name, away_team_goals:  widget.away_team_goals, away_team_logo:  widget.away_team_logo, year:  widget.year, month:  widget.month, day:  widget.day, hour:  widget.hour, minutes:  widget.minutes)*/);
                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: MatchScreen(type: widget.type, event: widget.event, home: widget.home, winner: widget.winner, league:  widget.league, place:  widget.place, home_team_id:  widget.home_team_id, home_team_name:  widget.home_team_name, home_team_goals:  widget.home_team_goals, home_team_logo:  widget.home_team_logo, away_team_id:  widget.away_team_id, away_team_name:  widget.away_team_name, away_team_goals:  widget.away_team_goals, away_team_logo:  widget.away_team_logo, year:  widget.year, month:  widget.month, day:  widget.day, hour:  widget.hour, minutes:  widget.minutes)));
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 100.w,
                  height: 15.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30.w,
                              height: 13.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Container(
                                      height: 8.h, 
                                      width: 21.w,
                                      child: ExtendedImage.network(
                                        [560, 8618, 10923].any((x) => widget.home_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.home_team_logo,
                                        fit: BoxFit.fitHeight, 
                                        timeLimit: Duration(seconds: 1),
                                        loadStateChanged: (ExtendedImageState state) {
                                          switch (state.extendedImageLoadState) {
                                            case LoadState.loading:
                                              _controller.reset();
                                              return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                            ///if you don't want override completed widget
                                            ///please return null or state.completedWidget
                                            //return null;
                                            //return state.completedWidget;
                                            case LoadState.completed:
                                              _controller.forward();
                                              return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                            case LoadState.failed:
                                              _controller.reset();
                                              return GestureDetector(
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: <Widget>[
                                                    CircularProgressIndicator(color: Colors.green,),
                                                    Positioned(
                                                      bottom: 0.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      child: Text(
                                                        "load image failed, click to reload",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  state.reLoadImage();
                                                },
                                              );
                                          }
                                        },
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: Text(widget.home_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),textAlign: TextAlign.center, /*maxLines: 2,minFontSize: 4.sp, stepGranularity: 4.sp,*/), 
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 36.w,
                              height: 12.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        /*Container(
                                          child: home ? Text("") : Text("data") 
                                        ),
                                        Container(
                                          child: ,
                                        )*/
                                        Text(widget.home_team_goals.toString(), style: widget.home ? getFont(18.sp, "#C41E3A", FontWeight.w800) : getFont(18.sp, "#00000", FontWeight.w800)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                                          child: Text("-", style: getFont(15.sp, "#00000", FontWeight.w600),),
                                        ),
                                        Text(widget.away_team_goals.toString(), style: widget.home ? getFont(18.sp, "#00000", FontWeight.w800) : getFont(18.sp, "#C41E3A", FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Container(
                                      //height: 2.h,
                                      //width: 1.w,
                                      padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 1.w),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[350],
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Text("Detaily", style: getFont(12.sp, "#FFFFFF", FontWeight.w600),),
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 30.w,
                              height: 13.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Container(
                                      height: 8.h, 
                                      width: 21.w,
                                      child: ExtendedImage.network(
                                       [560, 8618, 10923].any((x) => widget.away_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.away_team_logo,
                                        fit: BoxFit.fitHeight, 
                                        timeLimit: Duration(seconds: 1),
                                        loadStateChanged: (ExtendedImageState state) {
                                          switch (state.extendedImageLoadState) {
                                            case LoadState.loading:
                                              _controller.reset();
                                              return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                            ///if you don't want override completed widget
                                            ///please return null or state.completedWidget
                                            //return null;
                                            //return state.completedWidget;
                                            case LoadState.completed:
                                              _controller.forward();
                                              return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                            case LoadState.failed:
                                              _controller.reset();
                                              return GestureDetector(
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: <Widget>[
                                                    CircularProgressIndicator(color: Colors.green,),
                                                    Positioned(
                                                      bottom: 0.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      child: Text(
                                                        "load image failed, click to reload",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  state.reLoadImage();
                                                },
                                              );
                                          }
                                        },
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Text(widget.away_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),textAlign: TextAlign.center), 
                                  )
                  
                                ],
                              ),
                            ),
                          ],
                        ),
                  )
                )
              ),
            ),
          );
        }
        if (widget.type == 2) {
          return Padding(
            padding: EdgeInsets.only(top: 2.h, left: 2.w, right:  2.w, bottom: 2.h),
            child: Container(
              child: InkWell(
                onTap: (() {
                  router.goNamed("match_view", params: {'id': widget.fixture_id.toString()}/*extra: MatchData(fixture_id: widget.fixture_id,type: widget.type, home: widget.home, winner: widget.winner, league:  widget.league, place:  widget.place, home_team_id:  widget.home_team_id, home_team_name:  widget.home_team_name, home_team_goals:  widget.home_team_goals, home_team_logo:  widget.home_team_logo, away_team_id:  widget.away_team_id, away_team_name:  widget.away_team_name, away_team_goals:  widget.away_team_goals, away_team_logo:  widget.away_team_logo, year:  widget.year, month:  widget.month, day:  widget.day, hour:  widget.hour, minutes:  widget.minutes)*/);
                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: MatchScreen(type: widget.type, event: widget.event, home: widget.home, winner: widget.winner, league:  widget.league, place:  widget.place, home_team_id:  widget.home_team_id, home_team_name:  widget.home_team_name, home_team_goals:  widget.home_team_goals, home_team_logo:  widget.home_team_logo, away_team_id:  widget.away_team_id, away_team_name:  widget.away_team_name, away_team_goals:  widget.away_team_goals, away_team_logo:  widget.away_team_logo, year:  widget.year, month:  widget.month, day:  widget.day, hour:  widget.hour, minutes:  widget.minutes)));
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 100.w,
                  height: 15.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30.w,
                              height: 13.h,
                              //color: Colors.red,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Container(height: 8.h, width: 21.w,child: ExtendedImage.network(
                                      [560, 8618, 10923].any((x) => widget.home_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.home_team_logo,
                                      fit: BoxFit.fitHeight, 
                                      timeLimit: Duration(seconds: 1),
                                      loadStateChanged: (ExtendedImageState state) {
                                        switch (state.extendedImageLoadState) {
                                          case LoadState.loading:
                                            //_controller.reset();
                                            return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                            break;
                                          ///if you don't want override completed widget
                                          ///please return null or state.completedWidget
                                          //return null;
                                          //return state.completedWidget;
                                          case LoadState.completed:
                                            //_controller.forward();
                                            return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                          case LoadState.failed:
                                            //_controller.reset();
                                            return GestureDetector(
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  CircularProgressIndicator(color: Colors.green,),
                                                  Positioned(
                                                    bottom: 0.0,
                                                    left: 0.0,
                                                    right: 0.0,
                                                    child: Text(
                                                      "load image failed, click to reload",
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                state.reLoadImage();
                                              },
                                            );
                                        }
                                      },
                                    )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: SizedBox(height: 3.h, child: Text(widget.home_team_name, style: getFont(12.sp, "#00000", FontWeight.w700)/*,minFontSize: 8.sp, maxLines: 2, stepGranularity: 4.sp,textAlign: TextAlign.center*/),)
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 36.w,
                              height: 12.h,
                              //color: Colors.pink,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        /*Container(
                                          child: home ? Text("") : Text("data") 
                                        ),
                                        Container(
                                          child: ,
                                        )*/
                                        Text(widget.home_team_goals.toString(), style: getFont(18.sp, "#00000", FontWeight.w800)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                                          child: Text("-", style: getFont(18.sp, "#00000", FontWeight.w600),),
                                        ),
                                        Text(widget.away_team_goals.toString(), style: getFont(18.sp, "#00000", FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Container(
                                      //height: 2.h,
                                      //width: 1.w,
                                      padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 1.w),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[350],
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Text("Detaily", style: getFont(12.sp, "#FFFFFF", FontWeight.w600),),
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              //color: Colors.green,
                              width: 30.w,
                              height: 13.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Container(
                                      height: 8.h, 
                                      width: 21.w,
                                      child: ExtendedImage.network(
                                        [560, 8618, 10923].any((x) => widget.away_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.away_team_logo,
                                        fit: BoxFit.fitHeight, 
                                        timeLimit: Duration(seconds: 1),
                                        loadStateChanged: (ExtendedImageState state) {
                                          switch (state.extendedImageLoadState) {
                                            case LoadState.loading:
                                              _controller.reset();
                                              return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                            ///if you don't want override completed widget
                                            ///please return null or state.completedWidget
                                            //return null;
                                            //return state.completedWidget;
                                            case LoadState.completed:
                                              _controller.forward();
                                              return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                            case LoadState.failed:
                                              _controller.reset();
                                              return GestureDetector(
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: <Widget>[
                                                    CircularProgressIndicator(color: Colors.green,),
                                                    Positioned(
                                                      bottom: 0.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      child: Text(
                                                        "load image failed, click to reload",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  state.reLoadImage();
                                                },
                                              );
                                          }
                                        },
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: SizedBox(height: 3.h, child: Text(widget.away_team_name, style: getFont(12.sp, "#00000", FontWeight.w700)/*,minFontSize: 8.sp, maxLines: 2, stepGranularity: 4.sp,textAlign: TextAlign.center*/)), 
                                  )
                  
                                ],
                              ),
                            ),
                          ],
                        ),
                  )
                )
              ),
            ),
          );
        }
        else {return Container();}
      }
    );
  }
}

class ModelFutureMatch extends StatefulWidget {
  //const ModelPost({super.key});

  /*final String league;
  final String place;
  final String home_team_name;
  final String home_team_logo;
  final String away_team_name;
  final String away_team_logo;
  final int year;
  final int month;
  final int day;
  final int hour;
  final String minutes;*/
  final FutureMatch match;
  ModelFutureMatch({required this.match});

  @override
  State<ModelFutureMatch> createState() => _ModelFutureMatchState();
}

class _ModelFutureMatchState extends State<ModelFutureMatch> with TickerProviderStateMixin{
  @override
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 2.w, right:  2.w, bottom: 2.h),
      child: Container(
        child: InkWell(
          onTap: (() {
            AwesomeDialog(
              useRootNavigator: true,
              //width: 80.w,
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.noHeader,
              body: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: SizedBox(
                          width: 23.w,
                          height: 16.h,
                          child: Container(
                            //color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: ExtendedImage.network(
                                    [560, 8618, 10923].any((x) => widget.match.home_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.match.home_team_logo,
                                    handleLoadingProgress: true, 
                                    loadStateChanged: (ExtendedImageState state) {
                                      switch (state.extendedImageLoadState) {
                                        case LoadState.loading:
                                          _controller.reset();
                                          return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                        ///if you don't want override completed widget
                                        ///please return null or state.completedWidget
                                        //return null;
                                        //return state.completedWidget;
                                        case LoadState.completed:
                                          _controller.forward();
                                          return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                        case LoadState.failed:
                                          _controller.reset();
                                          return GestureDetector(
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: const <Widget>[
                                                CircularProgressIndicator(color: Colors.green,),
                                                Positioned(
                                                  bottom: 0.0,
                                                  left: 0.0,
                                                  right: 0.0,
                                                  child: Text(
                                                    "load image failed, click to reload",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              state.reLoadImage();
                                            },
                                          );
                                      }
                                    }, 
                                    fit: BoxFit.fitHeight, timeLimit: Duration(seconds: 1)
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: Text(widget.match.home_team_name,textAlign: TextAlign.center, style: getFont(13.sp, "#00000", FontWeight.w700),), 
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 28.w,
                        height: 15.h,
                        child: Container(
                          //color: Colors.black,
                          child: Column(
                            children: [
                              Text("${widget.match.league}", style: getFont(14.sp, "#36454F", FontWeight.w600),),
                              Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: Column(
                                  children: [
                                    Text("${widget.match.day}/${widget.match.month}/${widget.match.year}", style: getFont(12.sp, "#A9A9A9", FontWeight.w600),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: SizedBox(
                          width: 23.w,
                          height: 16.h,
                          child: Container(
                            //color: Colors.red,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: ExtendedImage.network(
                                    [560, 8618, 10923].any((x) => widget.match.away_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.match.away_team_logo,
                                    handleLoadingProgress: true, 
                                    loadStateChanged: (ExtendedImageState state) {
                                      switch (state.extendedImageLoadState) {
                                        case LoadState.loading:
                                          _controller.reset();
                                          return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                        ///if you don't want override completed widget
                                        ///please return null or state.completedWidget
                                        //return null;
                                        //return state.completedWidget;
                                        case LoadState.completed:
                                          _controller.forward();
                                          return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                        case LoadState.failed:
                                          _controller.reset();
                                          return GestureDetector(
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: const <Widget>[
                                                CircularProgressIndicator(color: Colors.green,),
                                                Positioned(
                                                  bottom: 0.0,
                                                  left: 0.0,
                                                  right: 0.0,
                                                  child: Text(
                                                    "load image failed, click to reload",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              state.reLoadImage();
                                            },
                                          );
                                      }
                                    }, 
                                    fit: BoxFit.fitHeight, timeLimit: Duration(seconds: 1)
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: Text(widget.match.away_team_name,textAlign: TextAlign.center,  style: getFont(13.sp, "#00000", FontWeight.w700),), 
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 36.w,
                        height: 10.h,
                        child: Container(
                          //color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 1.w),
                                child: SizedBox(child: Align(alignment: Alignment.centerLeft, child: Text("Začátek utkání:", style: getFont(12.sp, "#A9A9A9", FontWeight.w600),))),
                              ),
                              SizedBox(height: 2.h,),
                              Padding(
                                padding: EdgeInsets.only(left: 1.w),
                                child: Container(height: 4.h, child: Align(alignment: Alignment.topLeft, child: Text("Místo utkání",textAlign: TextAlign.left, style: getFont(12.sp, "#A9A9A9", FontWeight.w600),))),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 36.w,
                        height: 10.h,
                        child: Container(
                          //color: Colors.deepPurple,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 1.w),
                                    child: SizedBox(width: 38.w, child: Align(alignment: Alignment.centerRight, child: Text("${widget.match.hour} : ${widget.match.minutes}", style: getFont(12.sp, "#00000", FontWeight.w600),))),
                                  ),
                                  SizedBox(height: 2.h,),
                                  Padding(
                                    padding: EdgeInsets.only(right: 1.w),
                                    child: Container(height: 4.h,width: 38.w, child: Align(alignment: Alignment.topRight, child: AutoSizeText("${widget.match.place}", style: getFont(12.sp, "#00000", FontWeight.w600),textAlign: TextAlign.right, maxLines: 2,minFontSize: 6.sp, stepGranularity: 6.sp,))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ).show();
          }),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: 100.w,
            height: 15.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Text("${widget.match.league}", style: getFont(14.sp, "#36454F", FontWeight.w600),),
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Container(height: 8.h, width: 21.w,child: ExtendedImage.network(
                            [560, 8618, 10923].any((x) => widget.match.home_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.match.home_team_logo,
                            fit: BoxFit.fitHeight, 
                            timeLimit: Duration(seconds: 1),
                            loadStateChanged: (ExtendedImageState state) {
                              switch (state.extendedImageLoadState) {
                                case LoadState.loading:
                                  _controller.reset();
                                  return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                ///if you don't want override completed widget
                                ///please return null or state.completedWidget
                                //return null;
                                //return state.completedWidget;
                                case LoadState.completed:
                                  _controller.forward();
                                  return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                case LoadState.failed:
                                  _controller.reset();
                                  return GestureDetector(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        CircularProgressIndicator(color: Colors.green,),
                                        Positioned(
                                          bottom: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: Text(
                                            "load image failed, click to reload",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      state.reLoadImage();
                                    },
                                  );
                              }
                            },
                          )
                            
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(widget.match.home_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),), 
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(
                        width: 28.w,
                        height: 5.h,
                        child: Column(
                          children: [
                            Text("${widget.match.day}/${widget.match.month}/${widget.match.year}", style: getFont(12.sp, "#A9A9A9", FontWeight.w600),)
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Container(height: 8.h, width: 21.w,child: ExtendedImage.network(
                            [560, 8618, 10923].any((x) => widget.match.away_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : widget.match.away_team_logo,
                            fit: BoxFit.fitHeight, 
                            timeLimit: Duration(seconds: 1),
                            loadStateChanged: (ExtendedImageState state) {
                              switch (state.extendedImageLoadState) {
                                case LoadState.loading:
                                  _controller.reset();
                                  return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                                  break;
                                ///if you don't want override completed widget
                                ///please return null or state.completedWidget
                                //return null;
                                //return state.completedWidget;
                                case LoadState.completed:
                                  _controller.forward();
                                  return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                                case LoadState.failed:
                                  _controller.reset();
                                  return GestureDetector(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        CircularProgressIndicator(color: Colors.green,),
                                        Positioned(
                                          bottom: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: Text(
                                            "load image failed, click to reload",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      state.reLoadImage();
                                    },
                                  );
                                  break;
                              }
                            },
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(widget.match.away_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),), 
                        )

                      ],
                    ),
                  ],
                )
              ],
            ),
          )
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          /*Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            //height: 35.h,
            //width: 50.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  child: Container( child: Text(date, style: getFont(7.sp, "#ABB2B9", FontWeight.w500),),),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: AutoSizeText(text, style: getFont(10, "#00000", FontWeight.w500), maxLines: 4,),
                ),
              ],
            ) 
          ),*/
        ),
      ),
    );
  }
}