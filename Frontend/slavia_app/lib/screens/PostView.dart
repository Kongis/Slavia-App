import 'package:flutter/material.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:slavia_app/utils/app_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PostView extends ConsumerStatefulWidget {
  final String? url;
  const PostView({super.key, required this.url});

  @override
  ConsumerState<PostView> createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  bool isLoading = true;
  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouteProvider);
    return WillPopScope(
      onWillPop: () {
        router.goNamed("posts");
        return Future(() => false,);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(child: Icon(Icons.arrow_back_ios, color: Colors.black,), onTap: () {
            router.goNamed("posts");
          },),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,//HexColor("#e4041f"),
          title: Text("Článek", style: getFont(17.sp, "#00000", FontWeight.w600),),
          centerTitle: true,
        ),
      body: 
      Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading ? Center( child: CircularProgressIndicator(color: HexColor("#e4041f"),),)
                      : Stack(),
          ],
        ),
      
      
      
      /*WebView(
        initialUrl: widget.url, 
        javascriptMode: JavascriptMode.unrestricted,
        ),*/
      /*/ebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
      )*/
      ),
    );
  }
}