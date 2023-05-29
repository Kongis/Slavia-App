// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:slavia_app/screens/PostView.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/screens/MatchScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
class EventModel extends StatelessWidget {
  final bool direction; //True - Left, False - Right
  final int type; //Goal - 1, Yellow Card - 2, Red Card - 3, Switch - 4, Penalty - 5
  final String player;
  final String assist;
  final int time;
  const EventModel({super.key, required this.direction, required this.type, required this.player, required this.assist, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
      child: Align(
        alignment: direction ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          width: 40.w, 
          height: 5.h, 
          decoration: BoxDecoration(
            color: Colors.cyan,
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
          ),
      ),
    ); 
    /*LayoutBuilder(
      builder: (context, constraints) {
        if (type == 1) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
            child: Align(
              
              alignment: direction ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 40.w,
                height: 5.h,
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
                /*child: direction ? Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: /*Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w,),
                        child: */Container(height: 4.h,width: 5.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                          child: Text("${time}'", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                      //),
                    ),
                    /*Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w,),
                      child: Container(height: 4.h,width: 30.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),*/
                    Align(
                      alignment: Alignment.centerRight, 
                      child: Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: Container(
                          child: Icon(FontAwesomeIcons.futbol, color: Colors.black, size: 15.sp,)),
                      )),
                    /*Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: Container(child: Icon(FontAwesomeIcons.futbol, color: Colors.black, size: 15.sp,)),
                      ),
                    ),*/
                  ],
                ) : 
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Container(child: Icon(FontAwesomeIcons.futbol, color: Colors.black, size: 15.sp,)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w,),
                      child: Container(height: 4.h,width: 3.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${player} ${direction}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w,),
                      child: Container(height: 4.h,width: 5.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                  ],
                )*/
              ),
            ),
          );
        } 
        if (type == 2) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
            child: UnconstrainedBox(
              alignment: direction ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 58.w,
                height: 4.h,
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
                child: direction ? Row(
                  mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(child: Icon(Icons.crop_portrait, color: Colors.yellow, size: 15.sp,)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w,),
                      child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                  ],
                ) : 
                Row(
                  mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w,),
                      child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(child: Icon(Icons.crop_portrait, color: Colors.yellow, size: 15.sp,)),
                    ),
                  ],
                )
              ),
            ),
          );
        }
        if (type == 3) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
            child: UnconstrainedBox(
              alignment: direction ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 58.w,
                height: 4.h,
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
                child: direction ? Row(
                  mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(child: Icon(Icons.crop_portrait, color: Colors.red, size: 15.sp,)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w,),
                      child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                  ],
                ) : 
                Row(
                  mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w,),
                      child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(child: Icon(Icons.crop_portrait, color: Colors.red, size: 15.sp,)),
                    ),
                  ],
                )
              ),
            ),
          ); 
        }
        if (type == 4) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
            child: UnconstrainedBox(
              alignment: direction ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 58.w,
                height: 4.h,
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
                child: direction ? Row(
                  mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(child: Icon(FontAwesomeIcons.rightLeft, color: Colors.black, size: 13.sp,)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w,),
                      child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                  ],
                ) : 
                Row(
                  mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w,),
                      child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(child: Icon(FontAwesomeIcons.rightLeft, color: Colors.black, size: 13.sp,)),
                    ),
                  ],
                )
              ),
            ),
          );  
        }
        if (type == 5) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
            child: UnconstrainedBox(
              alignment: direction ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 58.w,
                height: 4.h,
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
                child: direction ? Row(
                  mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(child: Icon(FontAwesomeIcons.futbol, color: Colors.black, size: 15.sp,)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w,),
                      child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                  ],
                ) : 
                Row(
                  mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w,),
                      child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                        child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Container(child: Icon(FontAwesomeIcons.futbol, color: Colors.black, size: 15.sp,)),
                    ),
                  ],
                )
              ),
            ),
          );  
        }
        else {return Container();}
        

      }
    );*/
    if (type == 1) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
      child: UnconstrainedBox(
        alignment: direction ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 58.w,
          height: 4.h,
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
          child: direction ? Row(
            mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Container(child: Icon(FontAwesomeIcons.repeat, color: Colors.black, size: 15.sp,)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w,),
                child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                  child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
              ),
            ],
          ) : 
          Row(
            mainAxisAlignment: direction ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w,),
                child: Container(height: 4.h,width: 35.w,color: Colors.transparent,alignment: Alignment.centerLeft,
                  child: Text("${time}'   ${player}", style: getFont(8.sp, "#00000", FontWeight.w600),),),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Container(child: Icon(FontAwesomeIcons.repeat, color: Colors.black, size: 15.sp,)),
              ),
            ],
          )
        ),
      ),
    );
    }
    if (type == 2) {
      return Container();  
    }
    if (type == 3) {
      return Container();  
    }
    if (type == 4) {
      return Container();  
    }
    if (type == 5) {
      return Container();  
    }
    else {return Container();}
  }
}