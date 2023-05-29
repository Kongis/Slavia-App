// ignore_for_file: unused_import, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:slavia_app/models/setting-model.dart';
import 'package:slavia_app/utils/api_services.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slavia_app/models/Hive/post.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:slavia_app/screens/MainPageConstructor.dart';
import 'package:slavia_app/main.dart';
import 'dart:io';
//import 'package:workmanager/workmanager.dart';
import 'package:go_router/go_router.dart';



class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  //ButtonState stateOnlyText = ButtonState.idle;
  var user_setting = Hive.box("user_setting");
  @override
  void initState() {

    super.initState();
  }
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController1 = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 = RoundedLoadingButtonController();
  final _ratingController = TextEditingController();

  var notification_allow = false;
  Future<void> refreshServerConnection()  async {
    final service = FlutterBackgroundService();
    service.invoke("stop");
    sleep(Duration(seconds: 2));
    await FlutterBackgroundService().startService();  
    _btnController.success();
    /*Timer (Duration(seconds: 2), () {
      _btnController.success();
    });*/
  }
  Future<void> refreshData() async {
    var box = Hive.box("updatedData");
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      print("Nemam net");
      await sortData();
      _btnController1.success();
    } 
    else {
        var check_list = ["post","futurematch","match"];
        for (var x in check_list) {
            box.put(x, "2022-01-01");
        }
        await getPost();
        await getFutureMatch();
        await getMatches();
        await getVideos();
        await sortData();
        _btnController1.success();
    }
    /*Timer (Duration(seconds: 2), () {
      _btnController1.success();
    });*/
  }
  Future<void> createNotification() async {
    var random = Random();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: random.nextInt(10000), 
          channelKey: "post_channel",//unique_id,
          title: "Poslední ligový zápas s atraktivním programem pro fanoušky",
          body: "Přijďte se v sobotu rozloučit s hráči na poslední ligový zápas letošní sezony proti Slovácku! Těšit se můžete na autogramiádu mistrů z ročníku 2007/08, rozlučku s Peterem Olayinkou a Vladimíra Šmicera, kterému poblahopřejeme k 50. narozeninám.",
          payload: {'path': "/post_view", 'param': "https://www.slavia.cz/article/20541-Posledni-ligovy-zapas-s-atraktivnim-programem-pro-fanousky"/*, 'full_path': jsonbody['full_path']*/},
          actionType: ActionType.Default,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: "https://slavia.esports.cz//foto/fanousci-bohemians-top.jpg"//jsonbody["notification_layout"]

      )
    );
    _btnController2.success();
  }

  List<bool> switchData=[false, false]; 
  var ratingText = "";
  @override
  Widget build(BuildContext context) {
  var username = user_setting.get("username");
  notification_allow = user_setting.get("notification-allow");
  return Container(
    color: Colors.white,
    width: 100.w,
    height: 100.h,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 5.h,),
          //Container(color: Colors.white, height: 4.h, child: Text("Nastavení", style: getFont(18.sp, "#00000", FontWeight.w600),)),
          //SizedBox(height: 5.h,),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Container(
                  width: 20.w,
                  height: 10.h,
                  //color: Colors.red,
                  child: Icon(Ionicons.person_circle_outline, size: 35.sp,),
                ),
              ),
              SizedBox(width: 10.w,),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  //color: Colors.green,
                  height: 10.h,
                  width: 60.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(username == null ? "Uživatelské jméno není zvoleno" : username, style: getFont(username == null ? 12.sp : 16.sp, "#00000", FontWeight.w500),),
                      SizedBox(height: 2.h,),
                      InkWell(
                        child: Container(
                          width: 25.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //border: Border.all(color: HexColor("#e4041f"), width: 0.5.w),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(child: Text("Upravit profil", style: getFont(12.sp, "#00000", FontWeight.w700),)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            width: 100.w,
            //height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: Text("Obecné", style: getFont(12.sp, "#ABB2B9", FontWeight.w600),),
                ),
                SizedBox(height: 2.h,),
                Container(
                width: 100.w,
                //height: 30.h,
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                //color: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //border: Border.all(color: HexColor("#e4041f"), width: 0.5.w),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        //color: Colors.black,
                        width: 100.w,
                        height: 4.h,
                        child: Row(
                          children: [
                            SizedBox(width: 18.w, child: Icon(Ionicons.notifications_outline, size: 18.sp,)),
                            Container(width: 50.w,alignment: Alignment.centerLeft, child: Text("Notifikace", style: getFont(13.sp, "#ABB2B9", FontWeight.w600))),
                            Container(width: 18.w,height: 3.h, child: FlutterSwitch(width: 15.w,activeColor: HexColor("#2ecc71"), value: notification_allow, onToggle:(value) async {
                              AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
                              if (!isAllowed) {
                                // This is just a basic example. For real apps, you must show some
                                // friendly dialog box before call the request method.
                                // This is very important to not harm the user experience
                                AwesomeNotifications().requestPermissionToSendNotifications();
                              }
                              });
                              user_setting.put("notification-allow", value);
                              final service = FlutterBackgroundService();
                              service.invoke("stop");
                              setState(() {user_setting.put("notification-allow", value);});
                              sleep(Duration(seconds: 2));
                              await FlutterBackgroundService().startService();     
                              },))
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Container(
                        //color: Colors.black,
                        width: 100.w,
                        height: 4.h,
                        child: Row(
                          children: [
                            SizedBox(width: 18.w, child: Icon(Ionicons.cloud_outline, size: 18.sp,)),
                            Container(width: 50.w,alignment: Alignment.centerLeft, child: Text("Obnovení dat", style: getFont(13.sp, "#ABB2B9", FontWeight.w600))),
                            Container(width: 18.w,height: 3.h, child: 
                            RoundedLoadingButton(
                                  width: 15.w,
                                  loaderSize: 16.sp,
                                  color: HexColor("#e4041f"),
                                  child: Icon(Ionicons.cloud_upload_outline),
                                  controller: _btnController1,
                                  onPressed: refreshData,
                                  resetAfterDuration: true,
                                  successColor: HexColor("#2ecc71"),
                                  //duration: Duration(seconds: 1),
                                  resetDuration: Duration(seconds: 2),
                              )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Container(
                        //color: Colors.black,
                        width: 100.w,
                        height: 4.h,
                        child: Row(
                          children: [
                            SizedBox(width: 18.w, child: Icon(Ionicons.server_outline, size: 18.sp,)),
                            Container(width: 50.w,alignment: Alignment.centerLeft, child: Text("Obnovit spojení se serverem", style: getFont(13.sp, "#ABB2B9", FontWeight.w600))),
                            Container(
                              width: 18.w,
                              height: 3.h, 
                              child: RoundedLoadingButton(
                                  width: 15.w,
                                  loaderSize: 16.sp,
                                  color: HexColor("#e4041f"),
                                  child: Icon(Ionicons.wifi_outline),
                                  controller: _btnController,
                                  onPressed: refreshServerConnection,
                                  resetAfterDuration: true,
                                  successColor: HexColor("#2ecc71"),
                                  //duration: Duration(seconds: 1),
                                  successIcon: Ionicons.cloud_done_outline,
                                  resetDuration: Duration(seconds: 2),
                                  //completionDuration: Duration(milliseconds: 300),
                              )
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
          SizedBox(height: 2.h,),
          Container(
            width: 100.w,
            //height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: Text("Zpětná vazba", style: getFont(12.sp, "#ABB2B9", FontWeight.w600),),
                ),
                SizedBox(height: 2.h,),
                Container(
                width: 100.w,
                //height: 30.h,
                //color: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //border: Border.all(color: HexColor("#e4041f"), width: 0.5.w),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Column(
                      children: [
                        Container(width: 40.h, alignment: Alignment.centerLeft, child: Text("Něco se vám nelíbí nebo by jste chtěli něco přidat? Napište zde", style: getFont(12.sp, "#ABB2B9", FontWeight.w600),softWrap: true,),),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Container(
                            width: 70.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              //border: Border.all(color: HexColor("#e4041f"), width: 0.5.w),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                              ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                              child: TextField(
                                controller: _ratingController,
                                onEditingComplete: () async{
                                  ratingText = _ratingController.text;
                                  //print(userText + "                                " + "send");
                                  //widget.callback;
                                },
                                style: getFont(14.sp, "#00000", FontWeight.w500),
                                maxLines: null,
                                cursorColor: Colors.black,
                                textAlignVertical: TextAlignVertical.bottom,
                                textInputAction: TextInputAction.send,
                                showCursor: true,
                                decoration: InputDecoration.collapsed(
                                  //border: null,
                                  
                                  hintText: "Napiště komentář",
                                  hintStyle: getFont(14.sp, "#00000", FontWeight.w400)
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h,),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: SizedBox(
                              height: 4.h,
                              width: 30.w,
                              child: ElevatedButton(
                                onPressed:() async {
                                }, 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#e4041f"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)
                                    )
                                ),
                                child: Text("Odeslat", style: getFont(14.sp, "#FFFFFF", FontWeight.w600)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h,),
          Container(
            width: 100.w,
            //height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: Text("Možnosti pro vývojáře", style: getFont(12.sp, "#ABB2B9", FontWeight.w600),),
                ),
                SizedBox(height: 2.h,),
                Container(
                width: 100.w,
                //height: 30.h,
                //color: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //border: Border.all(color: HexColor("#e4041f"), width: 0.5.w),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Column(
                      children: [
                        Container(
                        //color: Colors.black,
                        width: 100.w,
                        height: 4.h,
                        child: Row(
                          children: [
                            SizedBox(width: 18.w, child: Icon(Ionicons.server_outline, size: 18.sp,)),
                            Container(width: 50.w,alignment: Alignment.centerLeft, child: Text("Vytvořit notifikaci", style: getFont(13.sp, "#ABB2B9", FontWeight.w600))),
                            Container(
                              width: 18.w,
                              height: 3.h, 
                              child: RoundedLoadingButton(
                                  width: 15.w,
                                  loaderSize: 16.sp,
                                  color: HexColor("#e4041f"),
                                  child: Icon(Ionicons.wifi_outline),
                                  controller: _btnController2,
                                  onPressed: createNotification,
                                  resetAfterDuration: true,
                                  successColor: HexColor("#2ecc71"),
                                  //duration: Duration(seconds: 1),
                                  successIcon: Ionicons.cloud_done_outline,
                                  resetDuration: Duration(seconds: 2),
                                  //completionDuration: Duration(milliseconds: 300),
                              )
                            )
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h,)
        ]
      ),
    )
  );
}
}


/*
Future<void> memoryClean() async { 

    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      
      AnimatedSnackBar(
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        builder: ((context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Container(
              width: 100.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Container(
                      child: Icon(FontAwesomeIcons.circleExclamation,color: Colors.white,),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("Chyba Nemáte internetové připojení", style: getFont(8.sp, "#FFFFFF", FontWeight.w600),),
                  ),
                ],
              ),
            ),
          );
        })
      ).show(context);


    } else {
      await Hive.deleteBoxFromDisk('post');
      await Hive.deleteBoxFromDisk('futurematch');
      await Hive.deleteBoxFromDisk('match');
      await Hive.deleteBoxFromDisk('updatedData');
      await Hive.deleteBoxFromDisk('user');
      await Hive.openBox("post");
      await Hive.openBox("match");
      await Hive.openBox("futurematch");
      await Hive.openBox("updatedData");
      await getPost();
      await getFutureMatch();
      await getMatches();
    }
  }
*/