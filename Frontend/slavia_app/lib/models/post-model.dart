// ignore_for_file: unused_import, file_names

import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:slavia_app/screens/PostView.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slavia_app/utils/app_router.dart';
class ModelPost extends ConsumerStatefulWidget {
  //const ModelPost({super.key});

  final String title;
  final String text;
  final String image;
  final String tag;
  final String date;
  final String url;
  
  ModelPost({required this.text, required this.title, required this.image, required this.tag, required this.date, required this.url,});

  @override
  ConsumerState<ModelPost> createState() => _ModelPostState();
}

class _ModelPostState extends ConsumerState<ModelPost> with  TickerProviderStateMixin{
  @override
  /*var hasInternet = true;
  void initState() async {
    var connectivityResult = await(Connectivity().checkConnectivity());
    print("${connectivityResult}                  ahoj");
    if (connectivityResult == ConnectivityResult.none) {
      hasInternet == false;
    }
  }*/
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
  @override
  /*void dispose() {
    //didChangeDependencies();
    _controller.dispose();
    super.dispose();
  }*/

  @override
  //bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Padding(
      padding: EdgeInsets.only(top: 4.h, left: 3.w, right:  3.w),
      child: Container(
        child: InkWell(
          onTap: (() {
            context.goNamed("posts_view", params: {'url': widget.url});
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostView(url: widget.url)));
          }),
          child: Container(
            //margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
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
            ),
            //height: 35.h,
            //width: 50.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: ExtendedImage.network(widget.image,
                  /*loadStateChanged: (ExtendedImageState state) {
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
                  },*/
                  fit: BoxFit.fitWidth, timeLimit: Duration(milliseconds: 100), retries: 1, handleLoadingProgress: true,)),
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
                  child: Text(widget.text, style: getFont(12.sp, "#00000", FontWeight.w400),/*maxLines: 5, maxFontSize: 8.sp, minFontSize: 5.sp, stepGranularity: 0.5.sp,*/),
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


/*var value = snapshot.data;
          if (value == true) {
            return Padding(
              padding: EdgeInsets.only(top: 4.h, left: 3.w, right:  3.w),
              child: Container(
                child: InkWell(
                  onTap: (() {
                    print(url);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostView(url: url)));
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
                        Container(
                          child:/* Image.network(
                  image, // this image doesn't exist
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.amber,
                      alignment: Alignment.center,
                      child: const Text(
                        'Whoops!',
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  },
                ),*/
                          
                          
                          ExtendedImage.network(image, fit: BoxFit.fitWidth, timeLimit: Duration(milliseconds: 100), retries: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                          child: Container( child: Text(date, style: getFont(7.sp, "#ABB2B9", FontWeight.w500),),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                          child: AutoSizeText(title, style: getFont(12.sp, "#00000", FontWeight.w600), maxLines: 4,),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                          child: AutoSizeText(text, style: getFont(8.sp, "#00000", FontWeight.w500),maxLines: 4, maxFontSize: 8.sp, minFontSize: 4.sp, stepGranularity: 1.sp,),
                        )
                      ],
                    ) 
                    /*Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Container(height: 100.h,width: 43.w, child: Image.network(image, fit: BoxFit.fitWidth,),),
                        ),
                        Container(
                          height: 100.h,
                          width: 45.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AutoSizeText(text, style: getFont(10, "#00000", FontWeight.w500), maxLines: 4,),
                              SizedBox(height: 5.h,),
                              //AutoSizeText("tags: $tag", style: getFont(10, "#00000", FontWeight.w500), maxLines: 2,)
                              Padding(
                                  padding: EdgeInsets.only(),
                                  child: ModelTag(tag: tag),
                                ),
                              /*Container(
                                child: Row(
                                  children: [
                                    ModelTag(tag: tags[0]),
                                    //ModelTag(tag: tags[1]),
                                    //ModelTag(tag: tags[2])
                                  ],
                                ),
                              )*/
                              /*Container(
                                height: 3.h,
                                width: 60.w,
                                child: ListView.builder(
                                  itemCount: tags.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    return ModelTag(tag: tags[index]);
                                  })
                                ),
                              )*/
                            ],
                          ),
                        ),
                      ],
                    ),*/
                  ),
                ),
              ),
            );
          }*/