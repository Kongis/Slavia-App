import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';
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

class MatchShimmerModel extends StatelessWidget {
  const MatchShimmerModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,//grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(top: 2.h, left: 2.w, right:  2.w, bottom: 2.h),
        child: Container(
          width: 100.w,
          height: 15.h,
          decoration: BoxDecoration(
            color: Colors.white,//Colors.grey[300],
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
          /*child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
            )
          ),*/
        ),
      ),
    );
  }
}