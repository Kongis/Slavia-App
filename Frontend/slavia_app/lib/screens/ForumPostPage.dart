import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slavia_app/models/ForumComment-model.dart';
import 'package:slavia_app/models/Hive/event.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slavia_app/models/Hive/post.dart';
import 'package:slavia_app/models/Local/LocalStorage.dart';
import 'package:slavia_app/models/event-model.dart';
import 'package:slavia_app/models/post-model.dart';
import 'package:slavia_app/utils/api_services.dart';
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
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ForumPostScreen extends StatefulWidget {
  final ForumPost post_data;
  const ForumPostScreen({super.key, required this.post_data});

  @override
  State<ForumPostScreen> createState() => _ForumPostScreenState();
}

class _ForumPostScreenState extends State<ForumPostScreen> with AutomaticKeepAliveClientMixin{
  final _textController = TextEditingController();
  final _replyController = TextEditingController();
  List<ForumComment> listComments = [];
  var load = false;
  //var showMore = false;
  var showMore = [];
  @override
  void initState() {
    comments();
    super.initState();
  }

  Future<void> comments() async {
    listComments =  await getForumComment(widget.post_data.id);
    load = true;
    showMore = [for (var i = 1; i <= listComments.length; i++) false];
    setState(() {});
  }

   Future<void> roocomments() async {
    listComments =  await getForumComment(widget.post_data.id);
    load = true;
    showMore = [for (var i = 1; i <= listComments.length; i++) false];
    setState(() {});
  }

  @override
  Future<void> refreshScreen() async {
    await comments();
    print("set State");
    setState(() {});
  }
  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    
    super.build(context);

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future(() => false,);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Container( 
          width: 100.w,
          height: 100.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                //width: 94.w,
                //height: 2.h,
                padding: EdgeInsets.only(left: 2.w),
                child: Text("přidal uživatel:  ${widget.post_data.username}", style: getFont(12.sp, "#ABB2B9", FontWeight.w700),),
              ),
              SizedBox(height: 1.h,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                //height: 1.h,
                child: Text(widget.post_data.title, style: getFont(17.sp, "#00000", FontWeight.w800),),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                child: Container(
                  //height: 1.h,
                  child: Text(widget.post_data.text, style: getFont(13 .sp, "#00000", FontWeight.w500),),
                ),
              ),
              Container(
                width: 100.w,
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
                    ),
                  ],
                ),
              ),
              Container(color: Colors.transparent, height: 5.h,),
              Container(
                        width: 100.w,
                        //height: 6.h,
                        //color: Colors.green,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: Container(
                                child: Icon(Ionicons.person_circle_outline, size: 22.sp,),
                              ),
                            ),
                            /*CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey[200],
                                  //backgroundImage: AssetImage("assets/images/slavia-logo-bgremove.png",),
                                  child: Image.asset("assets/images/slavia-logo-bgremove.png", fit: BoxFit.cover,width: 15.w, height: 15.h,),
                                ),*/
                            Container(
                              padding: EdgeInsets.only(bottom: 1.h, left: 2.w),
                              width: 70.w,
                              child: TextField(
                                //autofocus: true,
                                controller: _textController,
                                onEditingComplete: () async{
                                  //var userText = _titleController.text;
                                  //print(userText);
                                  //await createForumComment(widget.parent_id, widget.post_id, userText);
                                  //print(userText + "                                " + "send");
                                  //widget.callback;
                                },
                                style: getFont(14.sp, "#00000", FontWeight.w400),
                                maxLines: null,
                                //cursorColor: Colors.black,
                                textAlignVertical: TextAlignVertical.bottom,
                                textInputAction: TextInputAction.send,
                                showCursor: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                                  isDense: true,
                                  //border: null,
                                  //fillColor: Colors.grey[200],
                                  //filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 0,
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 0.3.w, 
                                        //style: BorderStyle.none,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 0.3.w, 
                                        //style: BorderStyle.none,
                                    ),
                                ),
                                  hintText: "Tvůj komentář",
                                  hintStyle: getFont(14.sp, "#00000", FontWeight.w500)
                                ),
                              ),
                            ),
                            //SizedBox(width: 2.w,),
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.h, left: 4.w),
                              child: Container(
                                //height: 5.h,
                                //color: Colors.amber,
                                //width: 5.w,
                                child: InkWell(
                                  onTap:() async{
                                    var userText = _textController.text;
                                    print(userText);
                                    await createForumComment(widget.post_data.id, widget.post_data.id, userText);
                                    refreshScreen();
                                  }, 
                                  child: Icon(Ionicons.send_outline, size: 18.sp,))
                              ),
                            )
                          ],
                        ),
                      ),
              Expanded(
                child: load == true ? CustomRefreshIndicator(
                  leadingScrollIndicatorVisible: false,
                  trailingScrollIndicatorVisible: false,
                  builder: MaterialIndicatorDelegate(
                    builder: (context, controller) {
                      return Icon(
                        FontAwesomeIcons.futbol,
                        color: HexColor("#e4041f"),
                        size: 20,
                      );
                    },
                    scrollableBuilder: (context, child, controller) {
                      return Opacity(
                        opacity: 1.0 - controller.value.clamp(0.0, 1.0),
                        child: child,
                      );
                    },
                  ),
                  onRefresh:() async{
                    refreshScreen();
                  },
                  child: Column(
                    children: [ // var userText = _textController.text; await createForumComment(widget.post_data.id, widget.post_data.id, userText);
                      
                      SizedBox(height: 2.h,),
                      Expanded(
                        child: ListView.builder(
                          itemCount: listComments.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: false,
                          itemBuilder: (context, index) {
                            ForumComment comment = listComments[index];
                            return CommentTreeWidget<ForumComment, int>(
                              comment, 
                              [
                                for (var i = 1; i <= (showMore[index] ? comment.child_count : 0); i++) i
                                /*ForumComment(id: "id", user_id: "user_id", parent_id: "parent_id", username: "username", title: "title", text: "text", child_count: 2, upvote: 0, downvote: 0)*/],
                              treeThemeData:
                                  (listComments.length - 1) == index && showMore[index] == false  /*comment.child_count == 0*/ ?
                                  TreeThemeData(lineColor: Colors.transparent, lineWidth: 0.5.w)
                                  :
                                  TreeThemeData(lineColor: HexColor("#ABB2B9"), lineWidth: 0.5.w),
                              avatarRoot: (context, data) => PreferredSize(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Container(
                                    child: Icon(Ionicons.person_circle_outline, size: 24.sp,),
                                  ),
                                ),
                                /*CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey[400],
                                
                                ),*/
                                preferredSize: Size.fromRadius(18),
                              ),
                              avatarChild: (context, data) => PreferredSize(
                                child: CircleAvatar(
                                  radius: 0,
                                  backgroundColor: Colors.grey,
                                  
                                ),
                                preferredSize: Size.fromRadius(10),
                              ),
                              contentChild: (context, value) {
                                return ForumCommentModel(parent_id: comment.id,index: value,post_id: widget.post_data.id, callback: refreshScreen,);
                              },
                              
                              contentRoot: (context, data) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 80.w,
                                        minWidth: 40.w
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(12)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.username,
                                              style: Theme.of(context).textTheme.caption!.copyWith(
                                                  fontWeight: FontWeight.w600, color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              '${data.text}',
                                              style: Theme.of(context).textTheme.caption!.copyWith(
                                                  fontWeight: FontWeight.w300, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.5.h, bottom: 2.h),
                                      child: showMore[index] ? 
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 12.w,
                                              child: InkWell(
                                                onTap: () {
                                                  showMore[index] = false;
                                                  setState(() {});
                                                },
                                                child: Text("Skrýt odpovědi", style: getFont(11 .sp, "#00000", FontWeight.w600),)),
                                            ),
                                            Expanded(
                                              //width: 12.w,
                                              child: InkWell(
                                                onTap: () async {
                                                  await showReplyBox(context, data.id, widget.post_data.id);
                                                  showMore[index] = true;
                                                  //setState(() {});
                                                },
                                                child: Text("Odpovědět", style: getFont(11 .sp, "#00000", FontWeight.w600),overflow: TextOverflow.ellipsis,)),
                                            ),
                                          ],
                                        )
                                        :
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 15.w,
                                              child: InkWell(
                                                onTap: () {
                                                  showMore[index] = true;
                                                  setState(() {});
                                                },
                                                child: Text("Zobrazit odpovědi (${data.child_count})" , style: getFont(11 .sp, "#00000", FontWeight.w600),)),
                                            ),
                                            SizedBox(width: 2.w,),
                                            Expanded(
                                              //width: 12.w,
                                              child: InkWell(
                                                onTap: () async {
                                                  await showReplyBox(context, data.id, widget.post_data.id);
                                                  setState(() {showMore[index] = true;});
                                                },
                                                child: Text("Odpovědět", style: getFont(11 .sp, "#00000", FontWeight.w600),overflow: TextOverflow.ellipsis,)),
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
                :
                CupertinoActivityIndicator(),
              )
            ],
          ),
        ),
      )    
    );
  }
  Future<void> showReplyBox(BuildContext context, String parent_id, String post_id,) async {
    await showDialog(
      context: context, 
      builder:(context) {
        return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
          //width: 70.w,
          //height: 20.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 70.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                      child: TextField(
                        controller: _replyController,
                        onEditingComplete: () async{
                          var userText = _replyController.text;
                          await createForumComment(parent_id, post_id, userText);
                          //print(userText + "                                " + "send");
                          await refreshScreen();
                          Navigator.of(context).pop();
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
                  //SizedBox(width: 2.w,),
                  SizedBox(
                    width: 5.w,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0.h, right: 2.w),
                        child: InkWell(
                          onTap:() async {
                            var userText = _replyController.text;
                          await createForumComment(parent_id, post_id, userText);
                          
                          //print(userText + "                                " + "send");
                          await refreshScreen();
                          Navigator.of(context).pop();
                          }, 
                          child: Icon(Ionicons.send_outline, size: 16.sp,)),
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}


class CreateReplyDialog extends StatelessWidget {
  final String parent_id;
  final String post_id;
  final VoidCallback callback;
  const CreateReplyDialog({super.key, required this.parent_id, required this.post_id, required this.callback});
  
  @override
  Widget build(BuildContext context) {
    final _replyController = TextEditingController();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
          width: 70.w,
          //height: 20.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                    width: 70.w,
                    child: TextField(
                      controller: _replyController,
                      onEditingComplete: () async{
                        var userText = _replyController.text;
                        await createForumComment(parent_id, post_id, userText);
                        //print(userText + "                                " + "send");
                        await callback;
                        Navigator.of(context).pop();
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
                  //SizedBox(width: 2.w,),
                  SizedBox(
                    width: 5.w,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h, right: 2.w),
                        child: InkWell(
                          onTap:() async {
                            var userText = _replyController.text;
                          await createForumComment(parent_id, post_id, userText);
                          
                          //print(userText + "                                " + "send");
                          //await refreshScre
                          Navigator.of(context).pop();
                          }, 
                          child: Icon(Ionicons.send_outline, size: 16.sp,)),
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      );
  }
}