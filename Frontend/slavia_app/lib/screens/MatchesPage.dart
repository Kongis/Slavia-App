// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_local_variable, unused_field

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:slavia_app/models/Match_Shimmer.dart';
import 'package:slavia_app/models/match-model.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'package:slavia_app/screens/MatchScreen.dart';
import 'package:slavia_app/utils/api_services.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:flutter_date_difference/flutter_date_difference.dart';
import 'package:flutter/services.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import "package:hexcolor/hexcolor.dart";
import 'package:slavia_app/models/post-model.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:page_transition/page_transition.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timelines/timelines.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> with TickerProviderStateMixin{

  final List<String> items = [
  'Slavia A-Tým',
  'Slavia B-Tým',
  'Slavia Ženy',
  
  //'Item3',
  //'Item4',
];
  
  @override
  late final TabController _tabController = TabController(length: 2, vsync: this, initialIndex: matches_tabbar_index);
  @override
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }
  String? selectedValue_sort = "Slavia A-Tým";
  @override
  Widget build(BuildContext context) {
          late FutureMatch main_match;
          //Match? live_main_match = live_match;
          DateTime c;
          DateTime d;
          Duration def;
          late int days;
          late int hours;
          late int minutes;
          late int seconds;
          if (sortFutureMatches.length != 0) {
          main_match = sortFutureMatches[0];
          //Match? live_main_match = live_match;
          c = DateTime(main_match.year, main_match.month, main_match.day, main_match.hour, int.parse(main_match.minutes), 0);
          d = DateTime.now();
          def = c.difference(d);
          days = def.inDays;
          hours = def.inHours % 24;
          minutes = def.inMinutes % 60;
          seconds = def.inSeconds % 60;
          }
          //print(live_main_match!.elapsed  + "        0000000000000");
          //if (snapshot.connectionState == ConnectionState.done) {
            return sortFutureMatches.length != 0 || sortMatches.length != 0 ? FadeIn(
              duration: Duration(seconds: 2),
              child: Container(
                color: Colors.white,
                width: 100.w,
                height: 100.h,
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
                  onRefresh: () => Future.delayed(const Duration(seconds: 2)),
                  child: ListView(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      live_match == null ?
                      sortFutureMatches.length != 0 ?
                      Padding(
                        padding: EdgeInsets.only(top: 0.h),
                        child: Container(
                          width: 100.w,
                          height: 20.h,
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              DateUtils.isSameDay(DateTime.parse(main_match.raw_date), DateTime.now()) ?
                              context.goNamed("match_view", params: {'id': main_match.fixture_id.toString()})
                              :
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
                                                      [560, 8618, 10923].any((x) => main_match.home_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : main_match.home_team_logo ,
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
                                                    child: Text(main_match.home_team_name,textAlign: TextAlign.center, style: getFont(13.sp, "#00000", FontWeight.w700),), 
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
                                                Text("${main_match.league}", style: getFont(14.sp, "#36454F", FontWeight.w600),),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 2.h),
                                                  child: Column(
                                                    children: [
                                                      Text("${main_match.day}/${main_match.month}/${main_match.year}", style: getFont(12.sp, "#A9A9A9", FontWeight.w600),)
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
                                                      [560, 8618, 10923].any((x) => main_match.away_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : main_match.away_team_logo ,
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
                                                    child: Text(main_match.away_team_name,textAlign: TextAlign.center,  style: getFont(13.sp, "#00000", FontWeight.w700),), 
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
                                                      child: SizedBox(width: 38.w, child: Align(alignment: Alignment.centerRight, child: Text("${main_match.hour} : ${main_match.minutes}", style: getFont(12.sp, "#00000", FontWeight.w600),))),
                                                    ),
                                                    SizedBox(height: 2.h,),
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 1.w),
                                                      child: Container(height: 4.h,width: 38.w, child: Align(alignment: Alignment.topRight, child: AutoSizeText("${main_match.place}", style: getFont(12.sp, "#00000", FontWeight.w600),textAlign: TextAlign.right, maxLines: 2,minFontSize: 6.sp, stepGranularity: 6.sp,))),
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
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  child: Container(height: 2.h, child: Text(main_match.league, style: getFont(14.sp, "#00000", FontWeight.w600),)),
                                ),
                                //SizedBox(height: 2.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 30.w,
                                      height: 12.h,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(/*horizontal: 5.w*/),
                                            child: Container(height: 8.h, width: 21.w,child: ExtendedImage.network(
                                              [560, 8618, 10923].any((x) => main_match.home_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : main_match.home_team_logo ,
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
                                            )),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 2.h),
                                            child: Text(main_match.home_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),), 
                                          )
                                              
                                        ],
                                      ),
                                    ),
                                    //Container(child: Container(height: 5.h, width: 36.w,color: Colors.black,),),
                                    SizedBox(
                                      width: 40.w,
                                      height: 12.h,
                                      child: Column(
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(/*horizontal: 2.w*/),
                                            child: Center(
                                              child: Container(
                                                height: 5.h,
                                                child: TimerCountdown(
                                                  format: CountDownTimerFormat.daysHoursMinutesSeconds,
                                                  timeTextStyle: getFont(12.sp, "#00000", FontWeight.w700),
                                                  descriptionTextStyle: getFont(12.sp, "#00000", FontWeight.w600),
                                                  spacerWidth: 2.w,
                                                  daysDescription: "D",
                                                  hoursDescription: "H",
                                                  minutesDescription: "MIN",
                                                  secondsDescription: "SEC",
                                                  endTime: DateTime.now().add(
                                                    Duration(
                                                      days: days,
                                                      hours: hours,
                                                      minutes: minutes,
                                                      seconds: seconds
                                                      
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 1.h),
                                            child: Text("${main_match.day}/${main_match.month}/${main_match.year}", style: getFont(10.sp, "#00000", FontWeight.w600),),
                                          ),
                                          DateUtils.isSameDay(DateTime.parse(main_match.raw_date), DateTime.now()) ?
                                          Padding(
                                            padding: EdgeInsets.only(top: 1.h),
                                            child: Container(
                                              //height: 2.h,
                                              //width: 1.w,
                                              padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 1.w),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                              ),
                                              child: Text("Dnes", style: getFont(12.sp, "#FFFFFF", FontWeight.w600),),
                                            )
                                          )
                                          :
                                          Container()
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                      height: 12.h,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(/*horizontal: 5.w*/),
                                            child: Container(height: 8.h, width: 21.w,child: ExtendedImage.network(
                                              [560, 8618, 10923].any((x) => main_match.away_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : main_match.away_team_logo, 
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
                                            )),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 2.h),
                                            child: Text(main_match.away_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),), 
                                          )
                                        ],
                                      ),
                                    )
                            
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ) 
                      :

                      Container(
                        height: 20.h,
                        width: 100.w,
                        //color: Colors.red,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 30.w,
                                  //color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 3.h,),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 8.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle
                                            //borderRadius: BorderRadius.circular(100)
                                          ),
                                        )
                                      ),
                                      SizedBox(height: 2.h,),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.grey[300],
                                          height: 2.h,
                                          width: 14.w,
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 40.w,
                                  //color: Colors.blue,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 2.h,),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.grey[300],
                                          height: 2.h,
                                          width: 25.w,
                                        )
                                      ),
                                      SizedBox(height: 3.h,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                              height: 4.h,
                                              width: 4.w,
                                            )
                                          ),
                                          SizedBox(width: 4.w,),
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                              height: 1.h,
                                              width: 4.w,
                                            )
                                          ),
                                          SizedBox(width: 4.w,),
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                              height: 4.h,
                                              width: 4.w,
                                            )
                                          ),
                                        ],
                                      ),
                                      /*Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.grey[300],
                                          height: 2.h,
                                          width: 25.w,
                                        )
                                      ),*/
                                      
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 30.w,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 3.h,),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 8.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle
                                            //borderRadius: BorderRadius.circular(100)
                                          ),
                                        )
                                      ),
                                      SizedBox(height: 2.h,),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.grey[300],
                                          height: 2.h,
                                          width: 14.w,
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //SizedBox(height: 2.h,),
                          ],
                        ),
                      )
                      :
                      ValueListenableBuilder(
                        valueListenable: Hive.box<Match>("match").listenable(),
                        builder: (context, value, child) {
                          Match? live_main_match = live_match!;
                          
                          return Padding(
                            padding: EdgeInsets.only(top: 0.h),
                            child: Container(
                              width: 100.w,
                              height: 20.h,
                              color: Colors.white,
                              child: InkWell(
                                onTap: (() {
                                Match data = live_main_match;
                                List<Event> event = data.events;
                                var home = false;
                                var win = false;
                                var type = 0; // 0 - Win, 1 - Lose, 2 - Draw
                                if ([560, 8618, 10923].any((x) => data.home_team_id == x)) {
                                  home = true;
                                  if (data.home_team_goals > data.away_team_goals){
                                    type = 0;
                                  }
                                  else if (data.home_team_goals < data.away_team_goals) {
                                    type = 1;
                                  }
                                  else if (data.home_team_goals == data.away_team_goals) {
                                    type = 2;
                                  }
                                }
                                else {
                                  if (data.home_team_goals < data.away_team_goals){
                                    type = 0;
                                  }
                                  else if (data.home_team_goals > data.away_team_goals) {
                                    type = 1;
                                  }
                                  else if (data.home_team_goals == data.away_team_goals) {
                                    type = 2;
                                  }
                                }
                                context.goNamed("match_view", params: {'id': data.fixture_id.toString()});
                              
                                }),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1.h),
                                      child: Container(height: 2.h, child: Text(live_main_match.league, style: getFont(14.sp, "#00000", FontWeight.w600),)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 0.h),
                                      child: Container(height: 2.h, child: Text("${live_main_match.elapsed}'  - ${live_main_match.status_long}", style: getFont(11.sp, "#00000", FontWeight.w600),)),
                                    ),
                                    //SizedBox(height: 2.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 30.w,
                                          height: 12.h,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(/*horizontal: 5.w*/),
                                                child: Container(height: 8.h, width: 21.w,child: ExtendedImage.network(
                                                  [560, 8618, 10923].any((x) => live_main_match.home_team_id == x) ? "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : live_main_match.home_team_logo,
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
                                                child: Text(live_main_match.home_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),), 
                                              )
                                                                          
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40.w,
                                          height: 12.h,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 3.h),
                                            child: Container(color: Colors.transparent,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  //Text(main_match.elapsed, style: getFont(8.sp, "#00000", FontWeight.w800)),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(live_main_match.home_team_goals.toString(), style: getFont(18.sp, "#00000", FontWeight.w800)),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                                                            child: Text("-", style: getFont(18.sp, "#00000", FontWeight.w800),),
                                                          ),
                                                          Text(live_main_match.away_team_goals.toString(), style: getFont(18.sp, "#00000", FontWeight.w800)),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 4.h),
                                                    child: Container(height: 2.h, child: Lottie.asset('assets/other/live2.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30.w,
                                          height: 12.h,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(/*horizontal: 5.w*/),
                                                child: Container(height: 8.h, width: 21.w,child: ExtendedImage.network(
                                                  [560, 8618, 10923].any((x) => live_main_match.away_team_id == x) ?/*live_main_match.away_team_id == 560 */ "https://upload.wikimedia.org/wikipedia/commons/9/90/Slavia-symbol-nowordmark-RGB.png" : live_main_match.away_team_logo,
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
                                                child: Text(live_main_match.away_team_name, style: getFont(12.sp, "#00000", FontWeight.w700),), 
                                              )
                                            ],
                                          ),
                                        )
                                  
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                      Center(
                        child: SizedBox(
                                //padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
                                //color: Colors.red,
                                /*decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red)
                                ),*/
                                width: 50.w,
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    //alignedDropdown: true,
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      isDense: true,
                                      hint: Text(
                                        'Vybrat tým',
                                        style: getFont(14.sp, "#ABB2B9", FontWeight.w600)
                                      ),
                                      items: items.map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: getFont(13.sp, "#ABB2B9", FontWeight.w600)
                                        ),
                                      )).toList(),
                                      value: selectedValue_sort,
                                      onChanged: (value) async {
                                        selectedValue_sort = value as String;
                                          if (selectedValue_sort == items[0]) {
                                            nowMatchType = 1;
                                            await sortMatch();
                                            await sortFutureMatch();
                                            //await sortForumPost(0);
                                          }
                                          if (selectedValue_sort == items[1]) {
                                            nowMatchType = 2;
                                            await sortMatch();
                                            await sortFutureMatch();
                                          }
                                          if (selectedValue_sort == items[2]) {
                                            nowMatchType = 3;
                                            await sortMatch();
                                            await sortFutureMatch();
                                            //await sortForumPost(0);
                                          }
                                        setState(() {});
                                      },
                                      iconStyleData: IconStyleData(
                                        icon: Icon(Ionicons.chevron_down_outline, size: 17.sp, color: HexColor("#ABB2B9"),)
                                      ),
                                      buttonStyleData: ButtonStyleData(
                                        width: 5.w,
                                        height: 4.h,
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                            border: Border.all(
                                              color: HexColor("#ABB2B9"),
                                            ),
                                        )
                                        //height: 20,
                                        //width: 70,
                                      ),
                                      menuItemStyleData: MenuItemStyleData(
                                        height: 5.h,
                                        padding: null
                                        //padding: EdgeInsets.only(left: 2.w),
                                        
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 20.h,
                                        width: 28.w,
                                        padding: null,
                                        //padding: EdgeInsets.only(left: 2.w),
                                        //scrollPadding: EdgeInsets.only(left: 2.w),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          //color: Colors.redAccent,
                                        ),
                                        //elevation: 8,
                                        offset: Offset(1.w, -1.h),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness: MaterialStateProperty.all(6),
                                          thumbVisibility: MaterialStateProperty.all(true),
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0.h, vertical: 1.h),
                        width: 100.w,
                        height: 6.h,
                        child: Center(
                          child: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            indicatorColor: Colors.green,
                            
                            //padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            tabs: [
                              Container(
                                width: 23.w,
                                padding: EdgeInsets.only(top: 1.h),
                                height: 5.h,
                                child: Center(child: Text("Nadcházející"/*"A-Tým"*/, /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 1.h),
                                width: 23.w,
                                height: 5.h,
                                child: Center(child: Text("Proběhlé"/*"B-Tým"*/, /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                              ),
                            ],
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: MaterialIndicator(
                              height: 0.5.h,
                              topLeftRadius: 0,
                              topRightRadius: 0,
                              bottomLeftRadius: 10,
                              bottomRightRadius: 10,
                              horizontalPadding: 3.w,
                              tabPosition: TabPosition.top,
                              color: HexColor("#e4041f")
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100.w,
                                height: 100.h,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                              width: 100.w,
                              height: 100.h,
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
                                onRefresh:() async{
                                  await getMatches();
                                  await getFutureMatch();
                                },
                                child: sortFutureMatches.length > 1 ?
                                ListView.builder(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  itemCount: sortFutureMatches.length == 0 ? 0 : sortFutureMatches.length - 1,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    List<dynamic> futureMatches = sortFutureMatches.getRange(1, sortFutureMatches.length).toList();
                                    FutureMatch data = futureMatches[index];
                                    return ModelFutureMatch(match: data,);
                                  }),
                                )
                                :
                                Center(child: Text("Momentálně nejsou naplánovány žádné zápasy", style: getFont(14.sp, "#ABB2B9", FontWeight.w600)),)
                              ),
                            ),
                            CustomRefreshIndicator(
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
                              onRefresh:() async{
                                  await getMatches();
                                  await getFutureMatch();
                                },
                              child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 8.h),
                                //controller: scrollController,
                                itemCount: sortMatches.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: ((context, index) {
                                  Match data = sortMatches[index];
                                  List<Event> event = data.events;
                                  var home = false;
                                  var win = false;
                                  var type = 0; // 0 - Win, 1 - Lose, 2 - Draw
                                  if ([560, 8618, 10923].any((x) => data.home_team_id == x)/*data.home_team_id == 560 || data.home_team_id == 8618 || data.home_team_id == 10923*/) {
                                    home = true;
                                    if (data.home_team_goals > data.away_team_goals){
                                      type = 0;
                                    }
                                    else if (data.home_team_goals < data.away_team_goals) {
                                      type = 1;
                                    }
                                    else if (data.home_team_goals == data.away_team_goals) {
                                      type = 2;
                                    }
                                  }
                                  else {
                                    if (data.home_team_goals < data.away_team_goals){
                                      type = 0;
                                    }
                                    else if (data.home_team_goals > data.away_team_goals) {
                                      type = 1;
                                    }
                                    else if (data.home_team_goals == data.away_team_goals) {
                                      type = 2;
                                    }
                                  }
                                  return ModelFinishMatch(fixture_id: data.fixture_id, type: type, event: event, home: home, winner: win, league: data.league, place: data.place, home_team_id: data.home_team_id, home_team_name: data.home_team_name, home_team_goals: data.home_team_goals, home_team_logo: data.home_team_logo, away_team_id: data.away_team_id, away_team_name: data.away_team_name, away_team_goals: data.away_team_goals, away_team_logo: data.away_team_logo, year: data.year, month: data.month, day: data.day, hour: data.hour, minutes: data.minutes);
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          :
          FadeIn(
            duration: Duration(seconds: 2),
            child: Container(
              height: 100.h,
              width: 100.w,
              child: Column(
                children: [
                  Container(
                    height: 20.h,
                    width: 100.w,
                    //color: Colors.red,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 30.w,
                          //color: Colors.amber,
                          child: Column(
                            children: [
                              SizedBox(height: 3.h,),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle
                                    //borderRadius: BorderRadius.circular(100)
                                  ),
                                )
                              ),
                              SizedBox(height: 2.h,),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 2.h,
                                  width: 14.w,
                                )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40.w,
                          //color: Colors.blue,
                          child: Column(
                            children: [
                              SizedBox(height: 2.h,),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 2.h,
                                  width: 25.w,
                                )
                              ),
                              SizedBox(height: 3.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.grey[300],
                                      height: 4.h,
                                      width: 4.w,
                                    )
                                  ),
                                  SizedBox(width: 4.w,),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.grey[300],
                                      height: 1.h,
                                      width: 4.w,
                                    )
                                  ),
                                  SizedBox(width: 4.w,),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.grey[300],
                                      height: 4.h,
                                      width: 4.w,
                                    )
                                  ),
                                ],
                              )
                              /*Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 2.h,
                                  width: 25.w,
                                )
                              ),*/
                            ],
                          ),
                        ),
                        Container(
                          width: 30.w,
                          child: Column(
                            children: [
                              SizedBox(height: 3.h,),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle
                                    //borderRadius: BorderRadius.circular(100)
                                  ),
                                )
                              ),
                              SizedBox(height: 2.h,),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 2.h,
                                  width: 14.w,
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: SizedBox(
                            //padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
                            //color: Colors.red,
                            /*decoration: BoxDecoration(
                              border: Border.all(color: Colors.red)
                            ),*/
                            width: 50.w,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                //alignedDropdown: true,
                                child: DropdownButton2(
                                  isExpanded: true,
                                  isDense: true,
                                  hint: Text(
                                    'Vybrat tým',
                                    style: getFont(14.sp, "#ABB2B9", FontWeight.w600)
                                  ),
                                  items: items.map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: getFont(13.sp, "#ABB2B9", FontWeight.w600)
                                    ),
                                  )).toList(),
                                  value: selectedValue_sort,
                                  onChanged: (value) async {
                                    selectedValue_sort = value as String;
                                      if (selectedValue_sort == items[0]) {
                                        nowMatchType = 1;
                                        await sortMatch();
                                        await sortFutureMatch();
                                        //await sortForumPost(0);
                                      }
                                      if (selectedValue_sort == items[1]) {
                                        nowMatchType = 2;
                                        await sortMatch();
                                        await sortFutureMatch();
                                      }
                                      if (selectedValue_sort == items[2]) {
                                        nowMatchType = 3;
                                        await sortMatch();
                                        await sortFutureMatch();
                                        //await sortForumPost(0);
                                      }
                                    setState(() {});
                                  },
                                  iconStyleData: IconStyleData(
                                    icon: Icon(Ionicons.chevron_down_outline, size: 17.sp, color: HexColor("#ABB2B9"),)
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                    width: 5.w,
                                    height: 4.h,
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: HexColor("#ABB2B9"),
                                        ),
                                    )
                                    //height: 20,
                                    //width: 70,
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    height: 5.h,
                                    padding: null
                                    //padding: EdgeInsets.only(left: 2.w),
                                    
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 20.h,
                                    width: 28.w,
                                    padding: null,
                                    //padding: EdgeInsets.only(left: 2.w),
                                    //scrollPadding: EdgeInsets.only(left: 2.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      //color: Colors.redAccent,
                                    ),
                                    //elevation: 8,
                                    offset: Offset(1.w, -1.h),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness: MaterialStateProperty.all(6),
                                      thumbVisibility: MaterialStateProperty.all(true),
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0.h, vertical: 1.h),
                    width: 100.w,
                    height: 6.h,
                    child: Center(
                      child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        indicatorColor: Colors.green,
                        
                        //padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        tabs: [
                          Container(
                            width: 23.w,
                            padding: EdgeInsets.only(top: 1.h),
                            height: 5.h,
                            child: Center(child: Text("Nadcházející"/*"A-Tým"*/, /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 1.h),
                            width: 23.w,
                            height: 5.h,
                            child: Center(child: Text("Proběhlé"/*"B-Tým"*/, /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                          ),
                        ],
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: MaterialIndicator(
                          height: 0.5.h,
                          topLeftRadius: 0,
                          topRightRadius: 0,
                          bottomLeftRadius: 10,
                          bottomRightRadius: 10,
                          horizontalPadding: 3.w,
                          tabPosition: TabPosition.top,
                          color: HexColor("#e4041f")
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    //idth: 100.w,
                    //height: 64.h,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.h,
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
                            onRefresh:() async{
                              await getMatches();
                              await getFutureMatch(); 
                              setState(() {
                                
                              });
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 8.h),
                              itemCount: 100,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                return MatchShimmerModel();
                              }),
                            ),
                          ),
                        ),
                        CustomRefreshIndicator(
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
                          onRefresh:() async{
                              await getMatches();
                              setState(() {
                                
                              });
                            },
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 8.h),
                            itemCount: 100,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              return MatchShimmerModel();
                            }),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );

      }
  }