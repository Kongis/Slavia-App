// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';
import 'utils/app_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/MainPage_controller.dart';
class BottomNavigationWidget extends ConsumerStatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  ConsumerState<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends ConsumerState<BottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(mainControllerProvider);

    return SizedBox(
      height: 7.h,
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: CustomNavigationBar(
          isFloating: true,
          elevation: 0,
          blurEffect: false,
          scaleCurve: Curves.easeInSine,
          bubbleCurve: Curves.easeInSine,
          borderRadius: Radius.circular(10),
          iconSize: 15.sp,
          selectedColor: HexColor("#e4041f"),//Color(0xff040307),
          strokeColor: Colors.transparent,//Colors.red,//Color(0x30040307),
          unSelectedColor: HexColor("#abb2b9"),//Colors.redAccent,//Color(0xffacacac),
          backgroundColor: HexColor("#f2f2f2"),//Colors.white,//HexColor("#f2f2f2"),// Colors.white,
          items: [
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.newspaper),
              //title: Text("Home", style: getFont(10.sp, "#000000", FontWeight.w500)),
            ),
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.tv),
              //title: Text("Cart", style: getFont(10.sp, "#000000", FontWeight.w500)),
            ),
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.futbol),
              //title: Text("Matches", style: getFont(10.sp, "#000000", FontWeight.w500),),
            ),
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.comments),
              //title: Text("Search", style: getFont(10.sp, "#000000", FontWeight.w500)),
            ),
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gear),
              //title: Text("Me", style: getFont(10.sp, "#000000", FontWeight.w500)),
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (index) {
            onButtonPressed(index);
            //setState(() {
              //selectedIndex = index;
            //});
          },
        ),
      ),
    );
  }
  void onButtonPressed(int index) {
    ref.read(mainControllerProvider.notifier).setPosition(index);


    switch (index) {
      case 0:
        context.goNamed("posts");
        break;
      case 1:
        context.goNamed("video");
        break;
      case 2:
        context.goNamed("match");
        break;
      case 3:
        context.goNamed("forum");
        break;
      case 4:
        context.goNamed("setting");
        break;
      default:
    }

  }
}
