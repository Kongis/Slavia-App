// ignore_for_file: unused_import, prefer_final_fields

import 'package:animate_do/animate_do.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slavia_app/models/Hive/post.dart';
import 'package:slavia_app/screens/MatchesPage.dart';
import 'package:slavia_app/screens/VideoScreen.dart';
import 'package:slavia_app/utils/api_services.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slavia_app/models/Hive/post.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'dart:convert';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:slavia_app/models/post-model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';


/*class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PostScreen();
  }

  @override
  bool get wantKeepAlive => true;
}*/






class PostScreen extends StatefulWidget {
  //final VoidCallback showNavigation;
  //final VoidCallback hideNavigation;
  const PostScreen({super.key, /*required this.showNavigation, required this.hideNavigation*/ });
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with /*AutomaticKeepAliveClientMixin,*/ TickerProviderStateMixin{
  //final HideNavbar hiding = HideNavbar();
  /*final ScrollController scrollController1 = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  final ScrollController scrollController3 = ScrollController();
  final ScrollController scrollController4 = ScrollController();
  final ScrollController scrollController5 = ScrollController();*/
  @override 
  
  /*void initState() {
    // TODO: implement initState
    super.initState();
    /*scrollController.addListener(() {
      if(scrollController.position.userScrollDirection == ScrollDirection.forward) {
        print("nahoru");
        widget.showNavigation();
      } else {
        print("dolu");
        widget.hideNavigation();
      }
    });*/
  }*/

  Future<void> refreshPage() async{
    await getPost();
    print("ahoj");
    setState(() {
      
    });
  }

  @override
  void initState() {
    
    super.initState();
    
  }

  int selectedIndex = 0;
  @override
  //bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    //super.build(context);


    TabController _tabController = TabController(length: 5, vsync: this);
    
    return FadeIn(
      duration: Duration(seconds: 1),
      child: Container(
        width: 100.w,
        height: 90.h,
        padding: EdgeInsets.only(top: 2.h),
        //HexColor("#f2f2f2"),//Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //alignment: WrapAlignment.center,
          children: [
            Container(height: 4.h, child: Text("Články", style: getFont(18.sp, "#00000", FontWeight.w600),)),
            SizedBox(height: 2.h,),
            Container(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 1.h),
              width: 100.w,
              height: 5.5.h,
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Colors.green,
                tabs: [
                  Container(
                    width: 20.w,
                    height: 5.h,
                    child: Center(child: Text("A-Tým", /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                  ),
                  Container(
                    width: 20.w,
                    height: 5.h,
                    child: Center(child: Text("B-Tým", /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                  ),
                  Container(
                    width: 20.w,
                    height: 5.h,
                    child: Center(child: Text("Mládež", /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                  ),
                  Container(
                    width: 20.w,
                    height: 5.h,
                    child: Center(child: Text("Ženy", /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                  ),
                  Container(
                    width: 20.w,
                    height: 5.h,
                    child: Center(child: Text("Klub", /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                  ),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: RectangularIndicator(
                  bottomLeftRadius: 100,
                  bottomRightRadius: 100,
                  topLeftRadius: 100,
                  topRightRadius: 100,
                  color: HexColor("#e4041f")
                ),
              ),
            ),            Expanded(
              //color: Colors.black,
              //width: 100.w,
              //height: 75.h,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    width: 100.w,
                    height: 75.h,
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
                        await refreshPage();
                      },
                      child: ListView.builder(
                        //controller: scrollController1,
                        //controller: widget.scroll,//scrollController,
                        padding: EdgeInsets.only(bottom: 8.h),
                        itemCount: tabList1.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          Post data = tabList1[index];
                          return ModelPost(title: data.title, text: data.text, image: data.image_url, tag: data.tag, date: data.date, url: data.url,);
                        }),
                      ),
                    ),
                  ),
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
                        await refreshPage();
                      },
                      child: ListView.builder(
                        //controller: scrollController2,
                        padding: EdgeInsets.only(bottom: 8.h),
                        //controller: scrollController,
                        itemCount: tabList2.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          Post data = tabList2[index];
                          return ModelPost(title: data.title, text: data.text, image: data.image_url, tag: data.tag, date: data.date, url: data.url,);
                        }),
                      ),
                    ),
                  ),
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
                        await refreshPage();
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 8.h),
                        //controller: scrollController3,
                        itemCount: tabList3.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          Post data = tabList3[index];
                          return ModelPost(title: data.title, text: data.text, image: data.image_url, tag: data.tag, date: data.date, url: data.url,);
                        }),
                      ),
                    ),
                  ),
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
                        await refreshPage();
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 8.h),
                        //controller: scrollController4,
                        itemCount: tabList4.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          Post data = tabList4[index];
                          return ModelPost(title: data.title, text: data.text, image: data.image_url, tag: data.tag, date: data.date, url: data.url,);
                        }),
                      ),
                    ),
                  ),
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
                        await refreshPage();
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 8.h),
                        //controller: scrollController5,
                        itemCount: tabList5.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          Post data = tabList5[index];
                          return ModelPost(title: data.title, text: data.text, image: data.image_url, tag: data.tag, date: data.date, url: data.url,);
                        }),
                      ),
                    ),
                  ),
                  /*Tab(
                    text: "A-Tým",
                  ),*/
                  /*Tab(
                    text: "B-Tým",
                  ),*/
                  /*Tab(
                    text: "Mládež",
                  ),
                  Tab(
                    text: "Ženy",
                  ),
                  Tab(
                    text: "Klub",
                  ),*/
                ],
              ),
            )
                ],
              )
            ),
    );
  }
}