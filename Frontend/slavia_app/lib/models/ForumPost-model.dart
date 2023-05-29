import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slavia_app/models/Hive/post.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:slavia_app/models/event-model.dart';
import 'package:slavia_app/models/post-model.dart';
import 'package:slavia_app/utils/font_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart' as tab;
import "package:hexcolor/hexcolor.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slavia_app/models/timeline.dart';
//import 'package:timeline_tile/timeline_tile.dart';
import 'package:timelines/timelines.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:ionicons/ionicons.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:slavia_app/utils/app_router.dart';
import 'package:go_router/go_router.dart';


class ForumPostModel extends ConsumerStatefulWidget {
  final ForumPost post_data;
  const ForumPostModel({super.key, required this.post_data});

  @override
  ConsumerState<ForumPostModel> createState() => _ForumPostModelState();
}

class _ForumPostModelState extends ConsumerState<ForumPostModel> {
  @override
  Widget build(BuildContext context) {
    var lorem = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam dictum tincidunt diam. Etiam sapien elit, consequat eget, tristique non, venenatis quis, ante. Pellentesque sapien. Curabitur ligula sapien, pulvinar a vestibulum quis, facilisis vel sapien. Pellentesque ipsum. Etiam dictum tincidunt diam. Vestibulum erat nulla, ullamcorper nec, rutrum non, nonummy ac, erat. Praesent dapibus. Phasellus faucibus molestie nisl. Nullam lectus justo, vulputate eget mollis sed, tempor sed magna. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Maecenas fermentum, sem in pharetra pellentesque, velit turpis volutpat ante, in pharetra metus odio a lectus. Etiam dui sem, fermentum vitae, sagittis id, malesuada in, quam. Praesent in mauris eu tortor porttitor accumsan. In rutrum. Maecenas ipsum velit, consectetuer eu lobortis ut, dictum at dui. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Integer imperdiet lectus quis justo. Maecenas libero.";
    return Padding(
      padding: EdgeInsets.only(top: 4.h, left: 3.w, right:  3.w),
      child: Container(
        child: InkWell(
          onTap: (() {
            context.goNamed("forum_post", extra: widget.post_data);
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostView(url: widget.url)));
          }),
          child: Container(
            //width: 94.w,
            //height: 20.h,
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    //width: 94.w,
                    //height: 2.h,
                    child: Text("přidal uživatel:  ${widget.post_data.username}", style: getFont(10.sp, "#ABB2B9", FontWeight.w700),),
                  ),
                  SizedBox(height: 1.h,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                          //height: 1.h,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: widget.post_data.title, style: getFont(15.sp, "#00000", FontWeight.w800)),
                                WidgetSpan(child: SizedBox(width: 2.w)),
                                widget.post_data.tag != "" ?
                                WidgetSpan(child: Container(
                                  //height: 2.h,
                                  //width: 1.w,
                                  padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 1.w),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Text(widget.post_data.tag, style: getFont(12.sp, "#FFFFFF", FontWeight.w600),),
                                ))
                                :
                                WidgetSpan(child: Container())
                              ]
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                    child: Container(
                      //height: 1.h,
                      child: Text(widget.post_data.text, style: getFont(12 .sp, "#00000", FontWeight.w400),),
                    ),
                  ),
                  Container(
                    width: 94.w,
                    height: 3.h,
                    padding: EdgeInsets.only(left: 4.w),
                    //color: Colors.deepPurple,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 30.w,
                          height: 3.h,
                          //color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Icon(Ionicons.chatbox_outline, size: 17.sp,color: HexColor("#ABB2B9"),),
                              ),
                              SizedBox(width: 2.w,),
                              Container(
                                padding: EdgeInsets.only(bottom: 0.2.h),
                                child: Text("${widget.post_data.child_count} Komentářů", style: getFont(12 .sp, "#ABB2B9", FontWeight.w600),),
                              ),
                            ],
                          ),
                          /*child: IconButton(
                            onPressed:() {
                            
                            }, 
                            icon: Icon(FontAwesomeIcons.comment, size: 18.sp,)
                          ),*/
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            //height: 35.h,
            //width: 50.w,
          )  
        )      
      )
    );
  }
}