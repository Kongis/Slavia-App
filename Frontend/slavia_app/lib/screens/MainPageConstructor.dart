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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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







class MainPage extends ConsumerStatefulWidget {
  final Widget child;
  const MainPage({required this.child, Key? key}) : super(key:key);

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}


class _MainPageState extends ConsumerState<MainPage> {

  @override
  Widget build(BuildContext context) {
    /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      final router = ref.watch(goRouteProvider);
    var user_setting = Hive.box("user_setting");
    var onboarding = user_setting.get("onboarding");
    print("${onboarding}   000000000000000000");
    if (onboarding == null || onboarding == false) {
      //Future.delayed(Duration.zero, () => OnBoardingScreen());
      user_setting.put("notification-allow", true);
      print("tady");
      context.goNamed("onboard");

      //return OnBoardingScreen();
    }
    var isAllow = user_setting.get("notification-allow");
    /*if (isAllow == null || isAllow == false) {
      Future.delayed(Duration.zero, () => showAlert(context));
      user_setting.put("notification-allow", true);
    }*/
    //Future.delayed(Duration.zero, () => showAlert(context));
    });*/
    final router = ref.watch(goRouteProvider);
    var user_setting = Hive.box("user_setting");
    var isAllow = user_setting.get("notification-allow");
    if (isAllow == null || isAllow == false) {
      Future.delayed(Duration.zero, () => showAlert(context));
      //user_setting.put("notification-allow", true);
    }
    //Future.delayed(Duration.zero, () => showAlert(context));
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(preferredSize: Size.fromHeight(10.h), child: AppBar(systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: HexColor("#e4041f"), statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light, ), elevation: 0, backgroundColor: Colors.white, toolbarHeight: 10.h, centerTitle: true, title: Image.asset('assets/images/logo1.png', width: 100,height: 9.h,))),
      body: widget.child,
      extendBody: true,
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
  void showAlert(BuildContext context) {
    showDialog(
      context: context, 
      builder:(context) {
        return AskNotificationDialog();
      },
    );
    /*AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: Center(child: Text(
              'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
      title: 'This is Ignored',
      desc:   'This is also Ignored',
      btnOkOnPress: () {},
      ).show();*/

      /*showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("hi"),
              ));*/
    }
}




class AskNotificationDialog extends StatelessWidget {
  const AskNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var user_setting = Hive.box("user_setting");
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
          width: 70.w,
          height: 40.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(height: 30.h,width: 80.w, child: Center(child: Lottie.asset('assets/other/notification1.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max))),
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Container(child: Text("Chcete dostávat oznámení", style: getFont(14.sp, "#00000", FontWeight.w600),),),
            ),
            //SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                width: 24.w,
                height: 7.w,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#e4041f"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                  ),
                  child: Text("Ne", style: getFont(12.sp, "#FFFFFF", FontWeight.w600),),
                ),
              ),
              Container(
                width: 24.w,
                height: 7.w,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
                      if (!isAllowed) {
                        // This is just a basic example. For real apps, you must show some
                        // friendly dialog box before call the request method.
                        // This is very important to not harm the user experience
                        AwesomeNotifications().requestPermissionToSendNotifications();
                      }
                    });
                    user_setting.put("notification-allow", true);
                    final service = FlutterBackgroundService();
                    service.invoke("stop");
                    sleep(Duration(seconds: 2));
                    await FlutterBackgroundService().startService();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#e4041f"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                  ),
                  child: Text("Ano", style: getFont(12.sp, "#FFFFFF", FontWeight.w600),),
                ),
              ),
              ],
            )
            ],   
          ),
        ),
      );
  }
}




class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  late PageController _pageController;
  var current_index = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
    
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.w,
              height: 80.h,
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboarding_items.length,
                itemBuilder:(context, index) {
                  current_index = index;
                  print("Onboarding screen index: " + current_index.toString());
                  OnboardingItem current = onboarding_items[index];
                  return OnboardContent(title: current.title, description: current.description, background: current.background);
                }
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: SizedBox(
                  //width: 10.w,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (current_index == onboarding_items.length - 1) {
                        context.goNamed("posts");
                      }
                      else {
                      _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#e4041f"),
                      shape: CircleBorder() 
                      /*RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      )*/
                    ),
                    child: Icon(Icons.keyboard_arrow_right_sharp, size: 17.sp,),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100.w,
              height: 4.h,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: onboarding_items.length,
                  axisDirection: Axis.horizontal,
                  effect: WormEffect(spacing: 4.w,dotWidth: 1.5.h,dotHeight: 1.5.h, dotColor: HexColor("#ABB2B9"), activeDotColor: HexColor("#e4041f")),
              
                ),
              ),
            )
          ],
        ),
      ),
    );
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*ConcentricPageView(
      colors: <Color>[Colors.white, Colors.green, Colors.red],
      itemCount: 3, // null = infinity
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (index) {
          return Center(
              child: Container(
                  child: Text('Page $index'),
              ),
          );
      },
      child: *//*IntroductionScreen(
        key: _introKey,
        pages: [
          PageViewModel(
            titleWidget: Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Lottie.asset('assets/other/slide1.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),
            ),//"Title of custom body page",
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Click on "),
                Icon(Icons.edit),
                Text(" to edit a post"),
                ElevatedButton(
                      onPressed: () {
    
                        // 3. Use the `currentState` member to access functions defined in `IntroductionScreenState`
                        Future.delayed(const Duration(seconds: 3),
                            () => _introKey.currentState?.next());
                      },
                      child: const Text('Start'))
              ],
            ),
            /*image: Center(child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Lottie.asset('assets/other/slide1.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),
            )),*/
          ),
          PageViewModel(
            titleWidget: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Lottie.asset('assets/other/slide2.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),
            ),//"Title of custom body page",
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.h,),
                Text("Click on "),
                Icon(Icons.edit),
                Text(" to edit a post"),
              ],
            ),
            /*image: Center(child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Lottie.asset('assets/other/slide1.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),
            )),*/
          ),
          PageViewModel(
            titleWidget: Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Lottie.asset('assets/other/slide3.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),
            ),//"Title of custom body page",
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Click on "),
                Icon(Icons.edit),
                Text(" to edit a post"),
    
              ],
            ),
            /*image: Center(child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Lottie.asset('assets/other/slide1.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),
            )),*/
          ),
        ],
        done: Text("Hotovo"),
        dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: HexColor("#e4041f"),
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
          ),
        ),
        onDone: () {
          
        },
        next: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Icon(Icons.arrow_forward, color: HexColor("#e4041f"),),
        ),
        showNextButton: true,
        baseBtnStyle: ButtonStyle(
        ),
      );*/
  }
}





final onboarding_pages = [
  Container(child: Lottie.asset('assets/other/slide1.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),),
  Container(child: Lottie.asset('assets/other/slide2.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),),
  Container(child: Lottie.asset('assets/other/slide3.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),),
  //Container(child: Lottie.asset('assets/other/slide2.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max),)
];


/*class HideNavbar {
  final ScrollController controller = ScrollController();
  final ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  HideNavbar() {
    visible.value = true;
    controller.addListener(
      () {
        if (controller.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (visible.value) {
            visible.value = false;
            print("adasd");
          }
        }

        if (controller.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!visible.value) {
            visible.value = true;
          }
        }
      },
    );
  }

  void dispose() {
    controller.dispose();
    visible.dispose();
  }
}SmoothIndicator






class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;

  const ScrollToHideWidget({super.key, required this.child, required this.controller, this.duration = const Duration(milliseconds: 200)});

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else  if (direction == ScrollDirection.reverse){
      hide();
    }
  }

  void show() {
    if(!isVisible) setState((() => isVisible = true));
  }

  void hide() {
    if(!isVisible) setState((() => isVisible = false));
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    height: isVisible ? 7.h : 0.h,
    duration: widget.duration, 
    child: Wrap(children: [widget.child]),
  );
}*/

class OnboardContent extends StatefulWidget {
  final String title;
  final String description;
  final String background; 
  const OnboardContent({super.key, required this.title,required this.description, required this.background});

  @override
  State<OnboardContent> createState() => _OnboardContentState();
}

class _OnboardContentState extends State<OnboardContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 90.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SizedBox(height: 6.h,),
          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
            child: SizedBox(height: 40.h, child: Lottie.asset(widget.background, fit: BoxFit.fitHeight, frameRate: FrameRate.max),),
          ),
          Container(width: 90.w, child: AutoSizeText(widget.title, style: getFont(17.sp, "#00000", FontWeight.w800), maxLines: 4,textAlign: TextAlign.center,),),
          SizedBox(height: 2.h,),
          Container(width: 70.w,alignment: Alignment.center, child: AutoSizeText(widget.description, style: getFont(9.sp, "#ABB2B9", FontWeight.w800), maxLines: 4,textAlign: TextAlign.center,),),
        ],
      ),
    );
  }
}