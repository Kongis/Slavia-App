// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_import

import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:slavia_app/models/Hive/comment.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slavia_app/models/Hive/player_lineup.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:slavia_app/models/RowLineup.dart';
import 'package:slavia_app/models/event-model.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart' as tab;
import "package:hexcolor/hexcolor.dart";
import 'package:slavia_app/models/Hive/match.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slavia_app/models/timeline.dart';
//import 'package:timeline_tile/timeline_tile.dart';
import 'package:timelines/timelines.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slavia_app/utils/app_router.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MatchScreen extends StatefulWidget {
  //final MatchData match;
  final int fixture_id;
  /*final int type;
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
  final List<Event> event;*/

  MatchScreen({/*required this.match, */ required this.fixture_id});
  //const MatchScreen({super.key});
  /*required this.event,required this.type, required this.home, required this.winner, required this.league, required this.place, required this.home_team_id, required this.home_team_name, required this.home_team_goals , required this.home_team_logo, required this.away_team_id, required this.away_team_name, required this.away_team_goals,  required this.away_team_logo, required this.year, required this.month, required this.day, required this.hour, required this.minutes*/

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final data = _TimelineStatus.values;
  @override
  Widget build(BuildContext context) {
    TabController _tabController =
        TabController(initialIndex: 1, length: 3, vsync: this);
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future(
            () => false,
          );
        },
        child: Container(
          width: 100.w,
          height: 100.h,
          color: Colors.white,
          child: ValueListenableBuilder(
              valueListenable: Hive.box<Match>("match").listenable(),
              builder: (context, value, child) {
                var box_match = Hive.box<Match>("match");
                Match match = box_match.get(widget.fixture_id)!;
                var home_formation = match.home_formation;
                var away_formation = match.away_formation;
                var home_formation_column_count = 0;
                var away_formation_column_count = 0;
                var away_max_grid = 0;
                if (home_formation.length == 3) {}
                if (away_formation.length == 3) {}
                var home_count_column = match.home_formation.split("-");
                List<PlayerLineup> home_lineup = match.home_lineups;
                var away_count_column = match.away_formation.split("-");
                List<PlayerLineup> away_lineup = match.away_lineups;
                var element_index = 1;
                home_lineup.forEach((element) {
                  if (element.grid[0] == element_index.toString()) {
                    home_formation_column_count =
                        home_formation_column_count + 1;
                    element_index = element_index + 1;
                  }
                });
                element_index = 1;
                var index = 1;
                away_lineup.forEach((element) {
                  if (element.grid[0] == element_index.toString()) {
                    away_formation_column_count = int.parse(element.grid[0]);
                    element_index = element_index + 1;
                  }
                  if (int.parse(element.grid[0]) > away_max_grid) {
                    away_max_grid = int.parse(element.grid[0]);
                  }
                });
                var home = false;
                var type = 0; // 0 - Win, 1 - Lose, 2 - Draw
                if (match.home_team_id == 560) {
                  home = true;
                  if (match.home_team_goals > match.away_team_goals) {
                    type = 0;
                  } else if (match.home_team_goals < match.away_team_goals) {
                    type = 1;
                  } else if (match.home_team_goals == match.away_team_goals) {
                    type = 2;
                  }
                } else {
                  if (match.home_team_goals < match.away_team_goals) {
                    type = 0;
                  } else if (match.home_team_goals > match.away_team_goals) {
                    type = 1;
                  } else if (match.home_team_goals == match.away_team_goals) {
                    type = 2;
                  }
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Container(
                          height: 2.h,
                          child: Text(
                            match.league,
                            style: getFont(14.sp, "#00000", FontWeight.w600),
                          )),
                    ),
                    match.live == true
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Container(
                                child: Text(
                              "${match.elapsed}'  - ${match.status_long}",
                              style: getFont(11.sp, "#00000", FontWeight.w600),
                            )),
                          )
                        : Container(),
                    //SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 30.w,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(/*horizontal: 5.w*/),
                                child: Container(
                                    height: 8.h,
                                    width: 21.w,
                                    child: ExtendedImage.network(
                                      match.home_team_id == 560
                                          ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png"
                                          : match.home_team_logo,
                                      fit: BoxFit.fitHeight,
                                      timeLimit: Duration(seconds: 1),
                                      loadStateChanged:
                                          (ExtendedImageState state) {
                                        switch (state.extendedImageLoadState) {
                                          case LoadState.loading:
                                            _controller.reset();
                                            return SizedBox(
                                                height: 6.h,
                                                child: Center(
                                                  child: LoadingAnimationWidget
                                                      .waveDots(
                                                          color: Colors.red,
                                                          size: 20.sp),
                                                ));
                                            break;

                                          ///if you don't want override completed widget
                                          ///please return null or state.completedWidget
                                          //return null;
                                          //return state.completedWidget;
                                          case LoadState.completed:
                                            _controller.forward();
                                            return FadeIn(
                                                duration: Duration(seconds: 1),
                                                child: state.completedWidget);
                                          case LoadState.failed:
                                            _controller.reset();
                                            return GestureDetector(
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  CircularProgressIndicator(
                                                    color: Colors.green,
                                                  ),
                                                  Positioned(
                                                    bottom: 0.0,
                                                    left: 0.0,
                                                    right: 0.0,
                                                    child: Text(
                                                      "load image failed, click to reload",
                                                      textAlign:
                                                          TextAlign.center,
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
                                child: Text(
                                  match.home_team_name,
                                  textAlign: TextAlign.center,
                                  style:
                                      getFont(12.sp, "#00000", FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40.w,
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 2.h),
                                  child: Container(
                                      width: 28.w,
                                      height: 5.h,
                                      child: LayoutBuilder(
                                        builder: (p0, p1) {
                                          if (type == 0) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                //"#50C878" z //#C41E3A c
                                                Text(
                                                    match.home_team_goals
                                                        .toString(),
                                                    style: home
                                                        ? getFont(
                                                            18.sp,
                                                            "#50C878",
                                                            FontWeight.w800)
                                                        : getFont(
                                                            18.sp,
                                                            "#00000",
                                                            FontWeight.w800)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3.w),
                                                  child: Text(
                                                    "-",
                                                    style: getFont(
                                                        15.sp,
                                                        "#00000",
                                                        FontWeight.w800),
                                                  ),
                                                ),
                                                Text(
                                                    match.away_team_goals
                                                        .toString(),
                                                    style: home
                                                        ? getFont(
                                                            18.sp,
                                                            "#00000",
                                                            FontWeight.w800)
                                                        : getFont(
                                                            18.sp,
                                                            "#50C878",
                                                            FontWeight.w800)),
                                              ],
                                            );
                                          }
                                          if (type == 1) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    match.home_team_goals
                                                        .toString(),
                                                    style: home
                                                        ? getFont(
                                                            18.sp,
                                                            "#50C878",
                                                            FontWeight.w800)
                                                        : getFont(
                                                            18.sp,
                                                            "#00000",
                                                            FontWeight.w800)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3.w),
                                                  child: Text(
                                                    "-",
                                                    style: getFont(
                                                        15.sp,
                                                        "#00000",
                                                        FontWeight.w800),
                                                  ),
                                                ),
                                                Text(
                                                    match.away_team_goals
                                                        .toString(),
                                                    style: home
                                                        ? getFont(
                                                            18.sp,
                                                            "#00000",
                                                            FontWeight.w800)
                                                        : getFont(
                                                            18.sp,
                                                            "#50C878",
                                                            FontWeight.w800)),
                                              ],
                                            );
                                          }
                                          if (type == 2) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    match.home_team_goals
                                                        .toString(),
                                                    style: getFont(
                                                        18.sp,
                                                        "#00000",
                                                        FontWeight.w800)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3.w),
                                                  child: Text(
                                                    "-",
                                                    style: getFont(
                                                        15.sp,
                                                        "#00000",
                                                        FontWeight.w800),
                                                  ),
                                                ),
                                                Text(
                                                    match.away_team_goals
                                                        .toString(),
                                                    style: getFont(
                                                        18.sp,
                                                        "#00000",
                                                        FontWeight.w800)),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ))),
                              match.live == true
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Container(
                                          height: 2.h,
                                          child: Lottie.asset(
                                              'assets/other/live2.json',
                                              fit: BoxFit.fitHeight,
                                              frameRate: FrameRate.max)),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(/*horizontal: 5.w*/),
                                child: Container(
                                    height: 8.h,
                                    width: 21.w,
                                    child: ExtendedImage.network(
                                      match.away_team_id == 560
                                          ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png"
                                          : match.away_team_logo,
                                      fit: BoxFit.fitHeight,
                                      timeLimit: Duration(seconds: 1),
                                      loadStateChanged:
                                          (ExtendedImageState state) {
                                        switch (state.extendedImageLoadState) {
                                          case LoadState.loading:
                                            _controller.reset();
                                            return SizedBox(
                                                height: 6.h,
                                                child: Center(
                                                  child: LoadingAnimationWidget
                                                      .waveDots(
                                                          color: Colors.red,
                                                          size: 20.sp),
                                                ));
                                            break;

                                          ///if you don't want override completed widget
                                          ///please return null or state.completedWidget
                                          //return null;
                                          //return state.completedWidget;
                                          case LoadState.completed:
                                            _controller.forward();
                                            return FadeIn(
                                                duration: Duration(seconds: 1),
                                                child: state.completedWidget);
                                          case LoadState.failed:
                                            _controller.reset();
                                            return GestureDetector(
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  CircularProgressIndicator(
                                                    color: Colors.green,
                                                  ),
                                                  Positioned(
                                                    bottom: 0.0,
                                                    left: 0.0,
                                                    right: 0.0,
                                                    child: Text(
                                                      "load image failed, click to reload",
                                                      textAlign:
                                                          TextAlign.center,
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
                                child: Text(
                                  match.away_team_name,
                                  textAlign: TextAlign.center,
                                  style:
                                      getFont(12.sp, "#00000", FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                      width: 100.w,
                      height: 6.h,
                      child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        indicatorColor: Colors.green,
                        //padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        tabs: [
                          Container(
                            width: 21.w,
                            padding: EdgeInsets.only(top: 1.h),
                            height: 6.h,
                            child: Center(
                                child: Text(
                              "Časová Osa" /*"A-Tým"*/, /*style: getFont(10.sp, "#000000", FontWeight.w500),*/
                            )),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 1.h),
                            width: 21.w,
                            height: 5.h,
                            child: Center(
                                child: Text(
                              "Sestava" /*"B-Tým"*/, /*style: getFont(10.sp, "#000000", FontWeight.w500),*/
                            )),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 1.h),
                            width: 21.w,
                            height: 5.h,
                            child: Center(
                                child: Text(
                              "Komentáře" /*"B-Tým"*/, /*style: getFont(10.sp, "#000000", FontWeight.w500),*/
                            )),
                          ),
                        ],
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: tab.MaterialIndicator(
                            height: 0.5.h,
                            topLeftRadius: 0,
                            topRightRadius: 0,
                            bottomLeftRadius: 10,
                            bottomRightRadius: 10,
                            horizontalPadding: 3.w,
                            tabPosition: tab.TabPosition.top,
                            color: HexColor("#e4041f")),
                      ),
                    ),
                    Container(
                      child: Expanded(
                        //width: 100.w,
                        //height: 70.h,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                                width: 100.w,
                                height: 100.h,
                                child: Timeline.tileBuilder(
                                  theme: TimelineThemeData(
                                    direction: Axis.vertical,
                                    connectorTheme: ConnectorThemeData(
                                      space: 30.0,
                                      //thickness: 0.2.w,
                                    ),
                                  ),
                                  builder: TimelineTileBuilder.connected(
                                    itemCount: match.events.length,
                                    connectionDirection:
                                        ConnectionDirection.before,
                                    oppositeContentsBuilder: (context, index) {
                                      Event event = match.events[index];
                                      var assist = true;
                                      var player = event.player;
                                      if (event.assist == "") {
                                        assist = false;
                                      }
                                      if (event.player == null ||
                                          event.player == "") {
                                        player = "Neznámí";
                                      }
                                      if (match.home_team_id == event.team) {
                                        //direction = true;
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 1.h),
                                            child: Container(
                                              width: 40.w,
                                              height: 4.h,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0.w),
                                                  child: assist
                                                      ? event.type == "Góóól"
                                                          ? Container(
                                                              width: 20.w,
                                                              height: 3.h,
                                                              alignment: Alignment
                                                                  .center,
                                                              child: Text(
                                                                  "${player} asistence: ${event.assist}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: getFont(
                                                                      12.sp,
                                                                      "#000000",
                                                                      FontWeight
                                                                          .w600) /*,maxLines: 2,minFontSize: 4.sp, stepGranularity: 4.sp*/))
                                                          : Container(
                                                              width: 20.w,
                                                              height: 3.h,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  "${player} za ${event.assist}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: getFont(
                                                                      12.sp,
                                                                      "#000000",
                                                                      FontWeight
                                                                          .w600) /*,maxLines: 2,minFontSize: 4.sp, stepGranularity: 4.sp*/))
                                                      : Container(
                                                          width: 20.w,
                                                          height: 3.h,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "${player}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: getFont(
                                                                12.sp,
                                                                "#000000",
                                                                FontWeight
                                                                    .w600),
                                                          ))),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    contentsBuilder: (context, index) {
                                      Event event = match.events[index];
                                      var assist = true;
                                      var player = event.player;
                                      if (event.assist == "") {
                                        assist = false;
                                      }
                                      if (event.player == null ||
                                          event.player == "") {
                                        player = "Neznámí";
                                      }
                                      if (match.home_team_id != event.team) {
                                        //direction = true;
                                        return Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 1.h),
                                            child: Container(
                                              width: 40.w,
                                              height: 4.h,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 0.w),
                                                  child: assist
                                                      ? event.type == "Góóól"
                                                          ? Container(
                                                              width: 20.w,
                                                              height: 3.h,
                                                              alignment: Alignment
                                                                  .center,
                                                              child: Text(
                                                                  "${player} asistence: ${event.assist}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: getFont(
                                                                      12.sp,
                                                                      "#000000",
                                                                      FontWeight
                                                                          .w600) /*,maxLines: 2,minFontSize: 4.sp, stepGranularity: 4.sp*/))
                                                          : Container(
                                                              width: 20.w,
                                                              height: 3.h,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  "${player} za ${event.assist}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: getFont(
                                                                      12.sp,
                                                                      "#000000",
                                                                      FontWeight
                                                                          .w600) /*,maxLines: 2,minFontSize: 4.sp, stepGranularity: 4.sp*/))
                                                      : Container(
                                                          width: 20.w,
                                                          height: 3.h,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "${player}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: getFont(
                                                                12.sp,
                                                                "#000000",
                                                                FontWeight
                                                                    .w600),
                                                          ))),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    indicatorBuilder: (context, index) {
                                      Event event = match.events[index];
                                      var child;
                                      var type = 0;
                                      if (event.type == "Góóól") {
                                        type = 0;
                                      }
                                      if (event.type == "Žlutá karta") {
                                        type = 1;
                                      }
                                      if (event.type == "Červená karta") {
                                        type = 2;
                                      }
                                      if (event.type == "Střídání") {
                                        type = 3;
                                      }
                                      if (event.type == "Penalta") {
                                        type = 4;
                                      }
                                      switch (data[type]) {
                                        case _TimelineStatus.goal:
                                          child = Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.futbol,
                                                  color: Colors.black,
                                                  size: 18.sp,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 1.w),
                                                  child: Text(
                                                    "${event.time.toString()}'",
                                                    style: getFont(
                                                        10.sp,
                                                        "#000000",
                                                        FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                          return ContainerIndicator(
                                            size: 30.sp,
                                            //color: Colors.white,
                                            child: child,
                                          );
                                        case _TimelineStatus.yellowCard:
                                          child = Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.crop_portrait,
                                                  color: Colors.yellow,
                                                  size: 18.sp,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 1.w),
                                                  child: Text(
                                                    "${event.time.toString()}'",
                                                    style: getFont(
                                                        10.sp,
                                                        "#000000",
                                                        FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                          return ContainerIndicator(
                                            size: 30.sp,
                                            //color: Colors.white,
                                            child: child,
                                          );
                                        case _TimelineStatus.redCard:
                                          child = Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.crop_portrait,
                                                  color: Colors.red,
                                                  size: 18.sp,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 1.w),
                                                    child: Text(
                                                      "${event.time.toString()}'",
                                                      style: getFont(
                                                          10.sp,
                                                          "#000000",
                                                          FontWeight.w600),
                                                    ))
                                              ],
                                            ),
                                          );
                                          return ContainerIndicator(
                                            size: 30.sp,
                                            //color: Colors.transparent,
                                            child: child,
                                          );
                                        case _TimelineStatus.substitution:
                                          child = Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.repeat,
                                                  color: Colors.black,
                                                  size: 18.sp,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 1.w),
                                                  child: Text(
                                                    "${event.time.toString()}'",
                                                    style: getFont(
                                                        10.sp,
                                                        "#000000",
                                                        FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                          return ContainerIndicator(
                                            size: 30.sp,
                                            child: child,
                                          );
                                        case _TimelineStatus.penalty:
                                          child = Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.error,
                                                  color: Colors.black,
                                                  size: 18.sp,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 1.w),
                                                  child: Text(
                                                    "${event.time.toString()}'",
                                                    style: getFont(
                                                        10.sp,
                                                        "#000000",
                                                        FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                          return ContainerIndicator(
                                            size: 30.sp,
                                            child: child,
                                          );
                                      }
                                      child = Padding(
                                        padding: EdgeInsets.all(0),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3.0,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ),
                                      );
                                      return DotIndicator(
                                        size: 20.sp,
                                        color: Colors.green,
                                        child: child,
                                      );
                                    },
                                    connectorBuilder: (context, index, type) {
                                      return SizedBox(
                                          height: 3.h,
                                          child: SolidLineConnector(
                                            color: Colors.red,
                                          ));
                                    },
                                  ),
                                )),
                            match.home_formation != "Není známo"
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Stack(
                                            fit: StackFit.passthrough,
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Container(
                                                width: 90.w,
                                                height: 50.h,
                                                //color: Colors.green,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/fotball_field_2-1.jpg"),
                                                        fit: BoxFit.fitHeight)),
                                              ),
                                              //Container(width: 10.w, height: 10.h, color: Colors.red,),
                                              Container(
                                                width: 90.w,
                                                height: 50.h,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      home_formation_column_count,
                                                  itemBuilder:
                                                      (context, index) {
                                                    //var list = home_count_column.reversed.toList();
                                                    List<PlayerLineup>
                                                        row_lineup = [];
                                                    home_lineup.forEach(
                                                      (element) {
                                                        //var now_grid = home_count_column[(home_count_column.length - 1) - index];
                                                        if (element.grid[0] ==
                                                            (index + 1)
                                                                .toString()) {
                                                          row_lineup
                                                              .add(element);
                                                        }
                                                      },
                                                    );
                                                    return Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: RowLineup(
                                                          rowLineup: row_lineup,
                                                          home_color:
                                                              match.home_color,
                                                          away_color:
                                                              match.away_color,
                                                          home: true,
                                                          team_id: match
                                                              .home_team_id,
                                                        ));
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          Stack(
                                            fit: StackFit.passthrough,
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Container(
                                                width: 90.w,
                                                height: 50.h,
                                                //color: Colors.green,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/fotball_field_1.jpg"),
                                                        fit: BoxFit.fitHeight)),
                                              ),
                                              //Container(width: 10.w, height: 10.h, color: Colors.red,),
                                              Container(
                                                width: 90.w,
                                                height: 50.h,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      away_formation_column_count,
                                                  itemBuilder:
                                                      (context, index) {
                                                    print(away_max_grid);
                                                    List<PlayerLineup>
                                                        row_lineup = [];
                                                    away_lineup.forEach(
                                                      (element) {
                                                        //var now_grid = away_count_column[(away_count_column.length - 1) - index];
                                                        if (element.grid[0] ==
                                                            (away_formation_column_count -
                                                                    index)
                                                                .toString()) {
                                                          row_lineup
                                                              .add(element);
                                                        }
                                                      },
                                                    );
                                                    return Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: RowLineup(
                                                          rowLineup: row_lineup,
                                                          home_color:
                                                              match.home_color,
                                                          away_color:
                                                              match.away_color,
                                                          home: false,
                                                          team_id: match
                                                              .away_team_id,
                                                        ));
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          SizedBox(
                                            width: 100.w,
                                            //height: 100.h,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 50.w,
                                                  //color: Colors.green,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 50.w,
                                                        //height: 8.h,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 2.w),
                                                        child: Text(
                                                            "Domácí - náhradníci",
                                                            style: getFont(
                                                                16.sp,
                                                                "00000",
                                                                FontWeight
                                                                    .w700),
                                                            textAlign:
                                                                TextAlign.left),
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      Container(
                                                        child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: match
                                                              .home_substitutes
                                                              .length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            PlayerLineup
                                                                player =
                                                                match.home_substitutes[
                                                                    index];
                                                            return Container(
                                                              width: 40.w,
                                                              //height: 4.h,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3.w,
                                                                      vertical:
                                                                          0.5.h),
                                                              child: Text(
                                                                  "${player.number} - ${player.name}",
                                                                  style: getFont(
                                                                      14.sp,
                                                                      "00000",
                                                                      FontWeight
                                                                          .w500),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2.h,
                                                        width: 50.w,
                                                      )
                                                      /*Expanded(
                                                  child: ListView.builder(
                                                    itemCount: match.home_substitutes.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:(context, index) {
                                                      PlayerLineup player = match.home_substitutes[index];
                                                      return Container(
                                                        width: 40.w,
                                                        height: 2.h,
                                                        child: Text(player.name , style: getFont(10.sp, "00000", FontWeight.w500), textAlign: TextAlign.left),
                                                      );
                                                    },
                                                  )
                                                )*/
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  //color: Colors.red,
                                                  width: 50.w,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 50.w,
                                                        //height: 8.h,
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 2.w),
                                                        child: Text(
                                                            "Hosté - náhradníci",
                                                            style: getFont(
                                                                16.sp,
                                                                "00000",
                                                                FontWeight
                                                                    .w700),
                                                            textAlign: TextAlign
                                                                .right),
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      Container(
                                                        child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: match
                                                              .away_substitutes
                                                              .length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            PlayerLineup
                                                                player =
                                                                match.away_substitutes[
                                                                    index];
                                                            return Container(
                                                              width: 40.w,
                                                              //height: 4.h,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3.w,
                                                                      vertical:
                                                                          0.5.h),
                                                              child: Text(
                                                                  "${player.number} - ${player.name}",
                                                                  style: getFont(
                                                                      14.sp,
                                                                      "00000",
                                                                      FontWeight
                                                                          .w500),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2.h,
                                                        width: 50.w,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 100.w,
                                    height: 100.h,
                                    color: Colors.white,
                                    child: Center(
                                        child: Text(
                                      "Omlouváme se, data nejsou k dispozici",
                                      style: getFont(
                                          15.sp, "#00000", FontWeight.w500),
                                    )),
                                  ),
                            Container(
                                width: 100.w,
                                height: 100.h,
                                color: Colors.white,
                                child: ListView.builder(
                                  itemCount: match.comments.length,
                                  itemBuilder: (context, index) {
                                    Comment comment =
                                        match.comments.reversed.toList()[index];
                                    // event goal, important, yellowCard, video, time, change, redCardAfterYellow, expertComment
                                    var type = comment.type.substring(6);
                                    return Container(
                                      //height: 5.h,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1.w,
                                                  color: Colors.grey[300]!))),
                                      width: 100.w,
                                      //color: Colors.red,alert-outline
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.h, horizontal: 2.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width: 10.w,
                                                child: Text(
                                                  comment.time != 0
                                                      ? comment.extend_time == 0
                                                          ? "${comment.time}'"
                                                          : "${comment.time}+${comment.extend_time}'"
                                                      : "",
                                                  style: getFont(
                                                      14.sp,
                                                      "#00000",
                                                      FontWeight.w600),
                                                )),
                                            SizedBox(
                                                width: 10.w,
                                                child: type == "goal"
                                                    ? Icon(
                                                        Ionicons
                                                            .football_outline,
                                                        size: 18.sp,
                                                        color: Colors.black,
                                                      )
                                                    : type == "important"
                                                        ? Icon(
                                                            Ionicons
                                                                .alert_outline,
                                                            size: 18.sp,
                                                            color: Colors.black,
                                                          )
                                                        : type == "yellowCard"
                                                            ? Icon(
                                                                Ionicons
                                                                    .tablet_portrait_sharp,
                                                                size: 18.sp,
                                                                color: Colors
                                                                    .yellow,
                                                              )
                                                            : type == "change"
                                                                ? Icon(
                                                                    Ionicons
                                                                        .repeat_outline,
                                                                    size: 18.sp,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                : type ==
                                                                        "redCard"
                                                                    ? Icon(
                                                                        Ionicons
                                                                            .tablet_portrait_sharp,
                                                                        size: 18
                                                                            .sp,
                                                                        color: Colors
                                                                            .red,
                                                                      )
                                                                    : Container()),
                                            SizedBox(
                                              width: 76.w,
                                              child: Text(
                                                comment.description,
                                                style: getFont(15.sp, "#00000",
                                                    FontWeight.w500),
                                                softWrap: true,
                                                maxLines: null,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}

class _IndicatorExample extends StatelessWidget {
  const _IndicatorExample({Key? key, required this.number}) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 4,
          ),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

enum _TimelineStatus {
  goal,
  yellowCard,
  redCard,
  substitution,
  penalty,
}

class _EmptyContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      height: 10.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: Color(0xffe6e7e9),
      ),
    );
  }
}
