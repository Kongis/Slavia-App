// ignore_for_file: unused_import, file_names

import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:slavia_app/screens/PostView.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:slavia_app/screens/VideoView.dart';
import 'package:page_transition/page_transition.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slavia_app/utils/app_router.dart';
import 'package:go_router/go_router.dart';
class ModelVideo extends ConsumerStatefulWidget {

  final String title;
  final String text;
  final String image;
  final String date;
  final String url;
  
  ModelVideo({required this.text, required this.title, required this.image, required this.date, required this.url,});

  @override
  ConsumerState<ModelVideo> createState() => _ModelVideoState();
}

class _ModelVideoState extends ConsumerState<ModelVideo> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{
  @override
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    else {
      return true;
    }
  }
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(widget.image);
    final router = ref.watch(goRouteProvider);
    return Padding(
      padding: EdgeInsets.only(top: 4.h, left: 3.w, right:  3.w),
      child: Container(
        child: InkWell(
          onTap: (() {
            context.goNamed("video_view", params: {'videoID': widget.url});
            //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: VideoView(videoID: widget.url,)));
          }),
          child: Container(
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
            //height: 35.h,
            //width: 50.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: ExtendedImage.network(
                    widget.image,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          _controller.reset();
                          return SizedBox(height: 6.h, child: Center(child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 20.sp),));
                          break;
                        ///if you don't want override completed widget
                        ///please return null or state.completedWidget
                        //return null;
                        //return state.completedWidget;
                        case LoadState.completed:
                          _controller.forward();
                          return FadeIn(duration: Duration(seconds: 1), child: state.completedWidget);
                        case LoadState.failed:
                          _controller.reset();
                          return GestureDetector(
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                CircularProgressIndicator(color: Colors.green,),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Text(
                                    "load image failed, click to reload",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              state.reLoadImage();
                            },
                          );
                          break;
                      }
                    },
                    fit: BoxFit.fitWidth, timeLimit: Duration(milliseconds: 100), retries: 1, handleLoadingProgress: true,
                  )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  child: Container( child: Text(widget.date, style: getFont(11.sp, "#ABB2B9", FontWeight.w500),),),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                  child: AutoSizeText(widget.title, style: getFont(15.sp, "#00000", FontWeight.w600), maxLines: 4,),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Text(widget.text, style: getFont(12.sp, "#00000", FontWeight.w500),/*maxLines: 5, maxFontSize: 8.sp, minFontSize: 5.sp, stepGranularity: 0.5.sp,*/),
                )
              ],
            ) 
          ),
        ),
      ),
            );
          } 
      }

class ModelTag extends StatelessWidget {
  //const ModelTag({super.key});
  final String tag;
  ModelTag({required this.tag});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, right: 2.w),
      child: Container(
        width: 15.w,
        height: 2.h,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
            /*boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],*/
          ),
        child: Center(child: Text(tag, style: getFont(10, "#00000", FontWeight.w400),),),
      ),
    );
  }
}
