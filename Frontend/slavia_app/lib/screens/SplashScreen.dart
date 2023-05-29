// ignore_for_file: unused_import, file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, sized_box_for_whitespace, unused_field, prefer_const_declarations, unused_local_variable, unnecessary_import, avoid_print, non_constant_identifier_names, avoid_types_as_parameter_names, prefer_conditional_assignment

//import 'dart:ffi';
 
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slavia_app/bottom_navigation_widget.dart';
import 'package:slavia_app/screens/MatchesPage.dart';
import 'package:slavia_app/screens/PostScreen.dart';
import 'package:slavia_app/screens/VideoScreen.dart';
import 'package:slavia_app/utils/api_services.dart';
import 'package:slavia_app/utils/app_router.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slavia_app/models/Hive/post.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'dart:convert';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:slavia_app/models/post-model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slavia_app/main.dart';
import 'package:introduction_screen/introduction_screen.dart';
final isLoading = false;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
    
  
Future<void> getAllMatchData() async {
    var box_userSetting = Hive.box("user_setting");
    var askAllowNotification = box_userSetting.get("askAllowNotification");
    if (askAllowNotification == null)  {
      box_userSetting.put("askAllowNotification", false);
      notificationAllow = true;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      print("Nemam net");
      await sortData();
      final router = ref.watch(goRouteProvider);
      ref.read(goRouterNotifierProvider).isLoading = false;
    } 
    else {
        await getPost();
        await getFutureMatch();
        await getMatches();
        await getVideos();
        await sortData();
        ref.read(goRouterNotifierProvider).isLoading = false;
    }
      
  }

  @override
  void initState() {
    getAllMatchData();

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouteProvider);
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: HexColor("#f2f2f2"),
          body: Container(
            width: 100.w,
            height: 100.h,
            color: HexColor("#f2f2f2"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Container(width: 60.w, child: Image(image: AssetImage("assets/images/logo1.png"), fit: BoxFit.fitWidth,)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30.h, 0, 0.h),
                    child: LoadingAnimationWidget.inkDrop(
                      color: HexColor("#e4041f"),
                      size: 10.w,),
                  )
                ],
              ),
            ),
          );
      }
    );
  }
}