// ignore_for_file: unused_import, prefer_const_constructors, unused_local_variable, unused_element, unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:ffi';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:extended_image/extended_image.dart' as extend;
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:slavia_app/models/Hive/comment.dart';
import 'package:slavia_app/models/Hive/player_lineup.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:slavia_app/utils/api_services.dart';
import 'package:slavia_app/utils/app_router.dart';
import 'package:uuid/uuid.dart';
import 'screens/MainPageConstructor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slavia_app/models/Hive/post.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/models/Hive/futurematch.dart';
import 'package:slavia_app/models/Hive/match.dart';
import 'utils/MainPage_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sse_channel/sse_channel.dart';
import 'package:lottie/lottie.dart';
import 'package:device_preview/device_preview.dart';
import 'dart:math';

//import 'package:http/http.dart' as http;
//import 'dart:typed_data';
class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}





Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    '7857', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      //initialNotificationContent: "",
      //initialNotificationTitle: "",

      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: '7857',
      initialNotificationTitle: 'SK Slavia',
      initialNotificationContent: 'Aplikace běží na pozadí',
      foregroundServiceNotificationId: 888,
      
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
    )
  );
  
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);
  await Hive.openBox("user_setting");
  var user_setting = Hive.box("user_setting");
  var user_choose = user_setting.get("notification-allow");

  Future<void> test() async {
    //try {
      var know =true;
    //var channel = await SseChannel.connect(Uri.parse('http://slavia.techbrick.cz/stream/notification'));
    print("SSE start");
    Map _source = {ConnectivityResult.none: false};
    final MyConnectivity _connectivity = MyConnectivity.instance;
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      _source = source;
      print(_source);
      String string;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string = 'Mobile: Online';
          break;
        case ConnectivityResult.wifi:
          string = 'WiFi: Online';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      if (string == 'Offline' && know == false) {
        service.invoke("restart");
        //Future.delayed(Duration(seconds: 10), () async {test(); return Future.value(null);});
      }
    });
    //channel.stream.listen((event) async { 
      /*try {
      http.Client client = http.Client();
      http.Request request = http.Request("GET", Uri.parse('http://slavia.techbrick.cz/stream/notification'));
      Future<http.StreamedResponse> response = client.send(request);
      print("Subscribed!");
      response.then((streamedResponse) => streamedResponse.stream.listen((value) {
        final parsedData = utf8.decode(value);
        print(parsedData);
        RegExp regExp = new RegExp(parsedData);
        print(regExp.stringMatch("data"));

      })).timeout(Duration(seconds: 5)).catchError((e) {return test();});
      } catch (e) {
        test();
      }*/
      try {
      var s = SSEClient.subscribeToSSE(url: 'http://slavia.techbrick.cz/stream/notification', header: {/*"X-Accel-Buffering": "no"*//*"Connection": "Keep-Alive",*/})/*.timeout(Duration(seconds: 60))*/.doOnError((p0, p1) {Future.delayed(Duration(seconds: 10), () async {service.invoke("restart");/*test();  return Future.value(false);*/});}).listen((event) async { 
      know = false;
      if (event.data != "") {
      var jsonbody = json.decode(event.data!);
      print(jsonbody);
          var random = Random();
          if (user_choose == true) {
          if (jsonbody["type"] == "notification") {
            if (jsonbody["channel"] == "post_channel") {
              var unique_id = DateTime.now().millisecondsSinceEpoch;
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  backgroundColor: Colors.transparent,
                    id: random.nextInt(10000), 
                    channelKey: "post_channel",//unique_id,
                    title: jsonbody["title"],
                    body: jsonbody["text"],
                    payload: {'path': jsonbody["path"], 'param': jsonbody['param']/*, 'full_path': jsonbody['full_path']*/},
                    actionType: ActionType.Default,
                    bigPicture: jsonbody["image"],
                    notificationLayout: NotificationLayout.BigPicture/*jsonbody["notification_layout"] as NotificationLayout*/
                )
              );
            }
            else if (jsonbody["channel"] == "match_channel") {
              var unique_id = DateTime.now().millisecondsSinceEpoch;
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: random.nextInt(10000), 
                    channelKey: "match_channel",//unique_id,
                    title: jsonbody["title"],
                    body: jsonbody["text"],
                    payload: {'path': jsonbody["path"], 'param': jsonbody['param']/*, 'full_path': jsonbody['full_path']*/},
                    actionType: ActionType.Default,
                    notificationLayout: NotificationLayout.BigText//jsonbody["notification_layout"]

                )
              );
            }
            else if (jsonbody["channel"] == "live_match_channel") {
              var unique_id = DateTime.now().millisecondsSinceEpoch;
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: random.nextInt(10000), 
                    channelKey: "live_match_channel",//unique_id,
                    title: jsonbody["title"],
                    body: jsonbody["text"],
                    payload: {'path': jsonbody["path"], 'param': jsonbody['param']/*, 'full_path': jsonbody['full_path']*/},
                    actionType: ActionType.Default,
                    notificationLayout: NotificationLayout.BigText//jsonbody["notification_layout"]

                )
              );
            }            
          }
          else if (jsonbody["type"] == "update") {
            service.invoke("update");
          }
          }
      }
    //}).onError((p0, p1) test);
      });//.onError((p0, p1) {Future.delayed(Duration(seconds: 10), () {test();});});
    } catch (e) {
      print("ERROR");
      Future.delayed(Duration(seconds: 10), () {test(); return false;});
      //return test();
    }
  }
  test();
  service.on("stop").listen((event) {service.stopSelf();});
}
@pragma('vm:entry-point')
Future<void> listenBackground() async {
  final service = FlutterBackgroundService();
  service.on('update').listen((event) async {
    await getMatches();
  });
  service.on('restart').listen((event) async {
    Map _source = {ConnectivityResult.none: false};
    final MyConnectivity _connectivity = MyConnectivity.instance;
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      _source = source;
      print(_source);
      String string;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string = 'Mobile: Online';
          break;
        case ConnectivityResult.wifi:
          string = 'WiFi: Online';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      if (string == 'WiFi: Online' || string == 'Mobile: Online' ) {
        final service = FlutterBackgroundService();
        service.invoke("stop");
        sleep(Duration(seconds: 2));
        FlutterBackgroundService().startService();  
        //Future.delayed(Duration(seconds: 10), () async {test(); return Future.value(null);});
      }
    });
    /*final service = FlutterBackgroundService();
    service.invoke("stop");
    sleep(Duration(seconds: 2));
    await FlutterBackgroundService().startService(); */ 
  });
}



void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
    
  HttpClient http = HttpClient();
    http.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true;
    };
    extend.HttpClientHelper().set(IOClient(http));

  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);
  
  /*await Hive.deleteBoxFromDisk('post');
  await Hive.deleteBoxFromDisk('futurematch');
  await Hive.deleteBoxFromDisk('match');
  await Hive.deleteBoxFromDisk('updatedData');
  await Hive.deleteBoxFromDisk('user');*/
  //await Hive.deleteBoxFromDisk("user_setting");
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(FutureMatchAdapter());
  Hive.registerAdapter(MatchAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(CommentAdapter());
  Hive.registerAdapter(PlayerLineupAdapter());
  await Hive.openBox("post");
  await Hive.openBox<Match>("match");
  await Hive.openBox("futurematch");
  await Hive.openBox("updatedData");
  await Hive.openBox("user_setting");
  await initializeService();
  final service = FlutterBackgroundService();
  var run = await service.isRunning();
  print(run.toString() + "      YESSSSSSSSSSSSSSSSSSSSSSSSSss");
  var box = Hive.box("updatedData");
  var check_list = ["post","futurematch","match"];
  for (var x in check_list) {
    var check_result = box.get(x);
    if (check_result == null) {
      box.put(x, "2022-01-01");
    }
  }
  var uuid = Uuid();
  var user_setting = Hive.box("user_setting");
  var has_id = user_setting.get("user_id");
  if (has_id == null || has_id == false) {
    var user_id = uuid.v1();
    await user_setting.put("user_id", user_id);
  }
  var user_choose = user_setting.get("notification-allow");
  if (run == false) {
    FlutterBackgroundService().startService();
    /*if (user_choose == true) {
      FlutterBackgroundService().startService();
    }
    else {
    await user_setting.put("notification-allow", false);
    }*/
  }
  var onboarding = user_setting.get("onboarding");
  if (onboarding == null || onboarding == false) {
    user_setting.put("onboarding", true);
    showOnboardScreen = true;
  }
  listenBackground();
  await AwesomeNotifications().initialize(
  // set the icon to null if you want to use the default app icon
  //'resource://drawable/ic_stat_ic_launcher_foreground',
  'resource://drawable/ic_notification_normal',
  //null,
  [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'post_channel',
        channelName: 'Články',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.red,
        playSound: true,
        defaultPrivacy: NotificationPrivacy.Public),
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'match_channel',
        channelName: 'Upozornění na zápasy',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.red,
        playSound: true,
        defaultPrivacy: NotificationPrivacy.Public),
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'live_match_channel',
        channelName: 'Živé zápasy',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.red,
        playSound: true,
        defaultPrivacy: NotificationPrivacy.Public),
  ],
  // Channel groups are only visual and are not required
  channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group')
  ],
  debug: false
  );
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  /*SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,overlays: [SystemUiOverlay.top]).then((_) => 
  runApp(
    ProviderScope(
      child: MyApp()
    )
    /*
    DevicePreview(
    enabled: true,
    builder: (context) => ProviderScope(child: MyApp()),
    
    )*/
  )
  );*/
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ProviderScope(
      child: MyApp()
    )
    /*
    DevicePreview(
    enabled: true,
    builder: (context) => ProviderScope(child: MyApp()),
    
    )*/
  );
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
    @override
    ConsumerState<MyApp> createState() => _MyAppState();
  }


  class _MyAppState extends ConsumerState<MyApp> {
    
    @override
  void initState() {
    listenNotification();
    super.initState();
  } 

  void listenNotification() {
    NotificationController.onNotification.stream.listen(onClickedNotification);
    /*NotificationController.onNotification.stream.listen((payload) { 
      onClickedNotification(payload);
    });*/
  }
  
  void onClickedNotification(dynamic data) {
    var primary_path = data["path"];
    var parameters = data["param"];
    final router = ref.watch(goRouteProvider);
    clickedNotification = true;
    if (primary_path ==  "/posts_view") {
      clickedNotificationPath = primary_path + "/" + Uri.encodeComponent(parameters);
    }
    else {
      clickedNotificationPath = primary_path + "/" + parameters;
    }
    router.go(clickedNotificationPath);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor("#e4041f")
    ));
    final router = ref.watch(goRouteProvider);
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "SK Slavia",
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          routerDelegate: router.routerDelegate,
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: HexColor("#e4041f"),
              cursorColor: HexColor("#e4041f"),
              selectionHandleColor: HexColor("#e4041f")
            ),
            primaryColor: HexColor("#e4041f"),
            hoverColor: HexColor("#e4041f"),
            highlightColor: HexColor("#FFFFFF"),
            colorScheme: ColorScheme(brightness: Brightness.light, primary: HexColor("#FFFFFF"), onPrimary: HexColor("#FFFFFF"), secondary: HexColor("#e4041f"), onSecondary: HexColor("#e4041f"), error: HexColor("#e4041f"), onError: HexColor("#e4041f"), background: HexColor("#e4041f"), onBackground: HexColor("#e4041f"), surface: HexColor("#e4041f"), onSurface: HexColor("#e4041f")),
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(HexColor("#e4041f"))
            ),
          ),
        );
      },
    );
  }
}


class NotificationController {
  static final onNotification = BehaviorSubject<dynamic>();
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    //print("onActionReceivedMethod                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxx");
    dynamic test = receivedAction.payload;
    //var payload = json.decode(json.encode(receivedAction.payload));
    //var payloadString = json.encode(receivedAction.payload);
    onNotification.add(test); 
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

