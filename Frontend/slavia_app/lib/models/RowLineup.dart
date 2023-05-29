// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:slavia_app/models/Hive/player_lineup.dart';
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

class RowLineup extends StatelessWidget {
  final List<PlayerLineup> rowLineup;
  final String home_color;
  final String away_color;
  final bool home;
  final int team_id;
  const RowLineup({super.key, required this.rowLineup, required this.home_color, required this.away_color, required this.home, required this.team_id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Container(
        alignment: Alignment.center,
        width: 90.w,
        height: 8.h,
        //color: Colors.blue,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemCount: rowLineup.length,
          itemBuilder:(context, index) {
          PlayerLineup player = rowLineup[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 1.w),
            child: SizedBox(
              height: 8.h,
              width: 20.w,
              //color: Colors.white,
              /*decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
              ),*/
              child: 
              home == false ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  team_id == 560 ?
                  Container(
                    height: 1.h,
                    width: 3.w,
                    decoration: BoxDecoration(
                      //color: HexColor(home ? home_color : away_color),//Colors.red,
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                          HexColor("#e4041f")
                        ],
                        stops: [
                          0.5, 0.5
                        ]
                      ),
                    ),
                  ):
                  Container(
                    height: 1.h,
                    width: 3.w,
                    decoration: BoxDecoration(
                      color: HexColor(home ? home_color : away_color),//Colors.red,
                      shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(height: 1.h,),
                  Container(
                    //height: 7.h,
                    //width: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.h),
                      child: Text(player.name, style: getFont(14.sp, "00000", FontWeight.w500),textAlign: TextAlign.center,),
                    )),
                ],
              )
              :
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    //height: 7.h,
                    //width: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.h),
                      child: Text(player.name, style: getFont(14.sp, "00000", FontWeight.w500),textAlign: TextAlign.center,),
                    )
                  ),
                  SizedBox(height: 1.h,),
                  team_id == 560 ?
                  Container(
                    height: 1.h,
                    width: 3.w,
                    decoration: BoxDecoration(
                      //color: HexColor(home ? home_color : away_color),//Colors.red,
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                          HexColor("#e4041f")
                        ],
                        stops: [
                          0.5, 0.5
                        ]
                      ),
                    ),
                  ):
                  Container(
                    height: 1.h,
                    width: 3.w,
                    decoration: BoxDecoration(
                      color: HexColor(home ? home_color : away_color),//Colors.red,
                      shape: BoxShape.circle
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}