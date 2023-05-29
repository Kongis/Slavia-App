import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slavia_app/screens/ForumPage.dart';
import 'package:slavia_app/screens/ForumPostPage.dart';
import 'package:slavia_app/screens/SplashScreen.dart';
import 'package:slavia_app/screens/MainPageConstructor.dart';
import 'package:slavia_app/screens/MatchScreen.dart';
import 'package:slavia_app/screens/MatchesPage.dart';
import 'package:slavia_app/screens/PostScreen.dart';
import 'package:slavia_app/screens/SettingsScreen.dart';
import 'package:slavia_app/screens/VideoScreen.dart';
import 'package:slavia_app/screens/PostView.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slavia_app/screens/VideoView.dart';
import 'package:slavia_app/utils/api_services.dart';
import 'MainPage_controller.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
final GlobalKey<NavigatorState> _rootNavigator = GlobalKey();
final GlobalKey<NavigatorState> _shellNavigator = GlobalKey();

final goRouterNotifierProvider = Provider<GoRouterNotifier>((ref) {
  return GoRouterNotifier();
});

class GoRouterNotifier extends ChangeNotifier {
  bool _isLoading = true;
  String _pathData = "";
  String get pathData => _pathData;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  set pathData(String value) {
    _pathData = value;
    notifyListeners();
  }

}












 
final  goRouteProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigator,
    //initialLocation: "/",
    refreshListenable: notifier,
    redirectLimit: 1,
    redirect: (context, state) async {
      final isLoggedIn = notifier.isLoading;
      final pathData = notifier.pathData;
      print(isLoggedIn);
      print(pathData);
      //print("${isLoggedIn}   ${state.location}    ${clickedNotification}");
      if (!isLoggedIn) {
        /*if (pathData != "") {
          return pathData;
        }*/
        /*if (clickedNotification == true) {
          return clickedNotificationData;
        }*/
        if (state.location == "/") {
          if (clickedNotification == true) {
            clickedNotification = false;
            return clickedNotificationPath;
          }
          else if (showOnboardScreen) {
            return "/onboard";
          }
          else {
          return "/posts";
          } 
        }
        else if (state.location == "/match") {
          await sortFutureMatch();
          await sortMatch();
          return state.location;
        }
        else {
          return state.location;
        }
      }
      if (isLoggedIn)  {
        return '/';
      }
      return null;
      
    },
    routes: [
      
    GoRoute(
      path: "/",
      builder: (context, state) {
        return const ProviderScope(child: SplashScreen());
      },
    ),
    GoRoute(
      path: "/onboard",
      name:  "onboard",
      builder: (context, state) {
        return OnBoardingScreen();
      },
    ),
    ShellRoute(
      
      navigatorKey: _shellNavigator,
      builder: (context, state, child) {
        return MainPage(child: child, key: state.pageKey,);
      },
      routes: [
        GoRoute(
          path: "/posts",
          name: "posts",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: PostScreen(), key: state.pageKey);
          },
          /*routes: [
            GoRoute(
              path: "view/:url",
              name:  "posts_view",
              builder: (context, state) {
                return PostView(url: state.params['url']);
              },

            )
          ]*/
        ),
        GoRoute(
          path: "/video",
          name: "video",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: VideoScreen(), key: state.pageKey);
          },
        ),
        GoRoute(
          path: "/match",
          name: "match",
          pageBuilder: (context, state) {
            matches_tabbar_index = 0;
            return NoTransitionPage(child: MatchesScreen(), key: state.pageKey);
          },
          routes: [
            GoRoute(
              path: "match_view/:id",
              name: "match_view",
              pageBuilder: (context, state) {
                matches_tabbar_index = 1;
                return NoTransitionPage(child: MatchScreen(fixture_id: int.parse(state.params['id']!)));
              },
            )
          ]
        ),
        GoRoute(
          path: "/forum",
          name: "forum",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: ForumPage(), key: state.pageKey);
          },
          routes: [
            GoRoute(
              path: "post",
              name: "forum_post",
              pageBuilder: (context, state) {
                ForumPost data = state.extra as ForumPost;
                return NoTransitionPage(child: ForumPostScreen(post_data: data));
              },
            )
          ]
        ),
        GoRoute(
          path: "/setting",
          name: "setting",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: SettingsScreen(), key: state.pageKey);
          },
        ),
      ]
    ),
    GoRoute(
      path: "/posts_view/:url",
      name:  "posts_view",
      pageBuilder: (context, state) {
        print(state.path);
        return CustomTransitionPage(
          key: state.pageKey,
          child: PostView(url: state.params['url']),
          //transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
              CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
            );
          },

        );
      },

    ),
    GoRoute(
      path: "/video_view/:videoID",
      name:  "video_view",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: VideoView(videoID: state.params['videoID']),
          //transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
              CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
            );
          },

        );
      },

    )
  ]

  );
},); 




//PostView(url: state.params['url']);

/*GoRoute(
          path: 'home',
          name: 'home',
          builder: (context, state) {  
            return const HomePage();
          },
          routes: [
            GoRoute(
              path: 'post',
              name: 'post',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            ),
            GoRoute(
              path: 'video',
              name: 'video',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            ),
            GoRoute(
              path: 'match',
              name: 'match',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            ),GoRoute(
              path: 'forum',
              name: 'forum',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            ),GoRoute(
              path: 'setting',
              name: 'setting',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            )
          ]
        ),*/










/*GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashScreen();
      },
      routes:  [
        GoRoute(
          path: 'home',
          name: 'home',
          builder: (context, state) {  
            return const HomePage();
          },
          routes: [
            GoRoute(
              path: 'post',
              name: 'post',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            ),
            GoRoute(
              path: 'video',
              name: 'video',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            ),
            GoRoute(
              path: 'match',
              name: 'match',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            ),GoRoute(
              path: 'forum',
              name: 'forum',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            ),GoRoute(
              path: 'setting',
              name: 'setting',
              builder: (context, state) {
                return const PostView(url: "https://www.slavia.cz//article/20184-Pracovat-s-nejlepsimi-hraci-je-obrovska-cest");
              },
            )
          ]
        ),
      ]
    ),
  ]
);*/