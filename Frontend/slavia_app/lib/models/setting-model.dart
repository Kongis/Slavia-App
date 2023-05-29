// ignore_for_file: unused_import, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class SettingItemModel extends StatefulWidget {
  final String icon;
  final String title;
  const SettingItemModel({super.key, required this.icon, required this.title});

  @override
  State<SettingItemModel> createState() => _SettingItemModelState();
}

class _SettingItemModelState extends State<SettingItemModel> {
  void test() {}
  var ahoj = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Container(
          width: 100.w,
          height: 5.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 12.w,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Icon(FontAwesomeIcons.bell, size: 13.sp,),
                ),
              ),
              SizedBox(
                width: 46.w,
                child: Container(
                  //color: Colors.amberAccent,
                  alignment: Alignment.center,
                  child: Text("Notifikace", style: getFont(13.sp, "#00000", FontWeight.w400),),
                ),
              ),
              SizedBox(
                width: 12.w,
                height: 5.h,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: FlutterSwitch(
                    value: ahoj, 
                    width: 12.w,
                    height: 3.h,
                    inactiveColor: Colors.redAccent,
                    activeColor: Colors.greenAccent,
                    onToggle:(value) {
                      setState(() {
                        ahoj = value;
                      });
                    },
                  )//Icon(FontAwesomeIcons.angleRight, size: 13.sp,),
                ),
              ),
            ],
          ),
          /*decoration: BoxDecoration(
            color: Colors.white,
            //border: Border.all(color: HexColor("#e4041f"), width: 0.5.w),
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
          ),*/
        ),
      ),
    );
  }
}