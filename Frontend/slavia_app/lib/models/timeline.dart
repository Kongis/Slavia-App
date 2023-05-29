import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:slavia_app/screens/PostView.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:slavia_app/screens/MatchScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:slavia_app/models/event-model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MatchTimeline extends StatelessWidget {
  //final bool home;
  final int index;
  final int last_index;
  final int type;
  final bool direction;
  final Event data;
  const MatchTimeline({super.key, required this.index, required this.last_index, required this.type, required this.direction, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (type == 1) {
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.center,
            isFirst: index == 0,
            isLast: index == last_index,
            lineXY: 0.3,
            indicatorStyle: IndicatorStyle(
              width: 40.w,
              height: 5.h,
              indicator: EventModel(direction: direction, type: type, player: data.player, assist: data.assist, time: data.time,),
              drawGap: true,
              iconStyle: IconStyle(
                color: Colors.black,
                iconData: FontAwesomeIcons.futbol,
              )
            ),
            beforeLineStyle: LineStyle(
              color: Colors.grey.withOpacity(0.2),
            ),
            afterLineStyle: LineStyle(
              color: Colors.blue.withOpacity(0.2),
            ),
          );
        }
        if (type == 2) {
          return Container();  
        }
        if (type == 3) {
          return Container();  
        }
        if (type == 4) {
          return Container();  
        }
        if (type == 5) {
          return Container();  
        }
        else {return Container();}
      }
    ); 
  }
}



