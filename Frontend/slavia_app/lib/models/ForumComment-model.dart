import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:slavia_app/utils/app_router.dart';
import 'package:go_router/go_router.dart';


class ForumCommentModel extends ConsumerStatefulWidget {
  //final ForumComment parent_id;
  final String parent_id;
  final int index;
  final String post_id;
  final VoidCallback callback;
  const ForumCommentModel({super.key,required this.index,required this.callback, required this.post_id, required this.parent_id});

  @override
  ConsumerState<ForumCommentModel> createState() => _ForumCommentModelState();
}

class _ForumCommentModelState extends ConsumerState<ForumCommentModel> with AutomaticKeepAliveClientMixin{

  final _textController = TextEditingController();
  final _replyController = TextEditingController();
  var listComments = [];
  late ForumComment commentData = ForumComment(id: "id", user_id: "user_id", parent_id: "", username: "", text: "", child_count: 0, upvote: 0, downvote: 0);
  var load = false;
  var showMore = [];
  var newScreen = false;
  @override
  void initState() {
    comments();
    super.initState();
    
  }


  Future<void> comments() async {
    listComments =  await getForumComment(widget.parent_id);
    commentData = listComments[widget.index > 0 ? widget.index - 1: widget.index];
    showMore = [for (var i = 1; i <= listComments.length; i++) false];
    load = true;
    setState(() {});
  }

  Future<void> refreshScreen() async{
    await comments();
    setState(() {});
  }

  @override
  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    super.build(context);
    var lorem = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam dictum tincidunt diam. Etiam sapien elit, consequat eget, tristique non, venenatis quis, ante. Pellentesque sapien. Curabitur ligula sapien, pulvinar a vestibulum quis, facilisis vel sapien. Pellentesque ipsum. Etiam dictum tincidunt diam. Vestibulum erat nulla, ullamcorper nec, rutrum non, nonummy ac, erat. Praesent dapibus. Phasellus faucibus molestie nisl. Nullam lectus justo, vulputate eget mollis sed, tempor sed magna. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Maecenas fermentum, sem in pharetra pellentesque, velit turpis volutpat ante, in pharetra metus odio a lectus. Etiam dui sem, fermentum vitae, sagittis id, malesuada in, quam. Praesent in mauris eu tortor porttitor accumsan. In rutrum. Maecenas ipsum velit, consectetuer eu lobortis ut, dictum at dui. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Integer imperdiet lectus quis justo. Maecenas libero.";
    return load == true ? LayoutBuilder(
      builder: (context, size) {
        print(size);
        var newThread = false;
        print(size.maxWidth - 40.w);
        if ((size.  maxWidth - 40.w) < 0) {
          newThread = true;
        }
        return ListView.builder(
          itemCount: 1,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {

            ForumComment comment = listComments[index];
            return CommentTreeWidget<ForumComment, int>(
              commentData, 
              [
                for (var i = 1; i <= (showMore[index] ? comment.child_count : 0); i++) i
                /*ForumComment(id: "id", user_id: "user_id", parent_id: "parent_id", username: "username", title: "title", text: "text", child_count: 2, upvote: 0, downvote: 0)*/],
              treeThemeData:
                  /*(listComments.length == 0 - 1) == index && */showMore[index] == false  || commentData.child_count == 0 ?
                  TreeThemeData(lineColor: Colors.transparent, lineWidth: 0.5.w)
                  :
                  TreeThemeData(lineColor: HexColor("#ABB2B9"), lineWidth: 0.5.w),
              avatarRoot: (context, data) => PreferredSize(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Container(
                    child: Icon(Ionicons.person_circle_outline, size: 24.sp,),
                  ),
                ),/*CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey[400],
                
                ),*/
                preferredSize: Size.fromRadius(12),
              ),
              avatarChild: (context, data) => PreferredSize(
                child: CircleAvatar(
                  radius: 0,
                  backgroundColor: Colors.grey,
                  
                ),
                preferredSize: Size.fromRadius(10),
              ),
              contentChild: (context, value) {
                print(value);
                return ForumCommentModel(parent_id: comment.id,index: value, post_id: widget.post_id, callback: refreshScreen,);
              },
              
              contentRoot: (context, data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 80.w,
                        minWidth: 40.w,
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
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        //maxWidth: 20.w,
                        //minWidth: 10.w,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 4),
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.w),
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
                                  onTap: () async{
                                    await showReplyBox(context, data.id, widget.post_id);
                                    setState(() {showMore[index] = true;});
                                  },
                                  child: Text("Odpovědět", style: getFont(11 .sp, "#00000", FontWeight.w600),overflow: TextOverflow.ellipsis,)),
                              ),
                            ],
                          )
                          : newThread ?
                          InkWell(
                            onTap: () {
                              if (newThread) {
                                print(commentData.id + "          ++++++++++++           " + widget.parent_id);
                                AwesomeDialog(
                                useRootNavigator: true,
                                //width: 80.w,
                                context: context,
                                animType: AnimType.scale,
                                dialogType: DialogType.noHeader,
                                body: SizedBox(
                                  width: 90.w,
                                  height: 70.h,
                                  child: ForumCommentModel(parent_id: widget.parent_id,index: index,post_id: widget.post_id, callback: refreshScreen,))
                              ).show();
                              }
                              else {
                              setState(() {showMore[index] = true;});
                              }
                            },
                            child: Text(newThread ? "Pokračovat v tomto vlánku" : "Zobrazit odpovědi (${commentData.child_count})", style: getFont(11 .sp, newThread ? "#3498DB" : "#00000", FontWeight.w600),softWrap: true, maxLines: 2, ))
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
                                  child: Text("Zobrazit odpovědi (${commentData.child_count})" , style: getFont(11 .sp, "#00000", FontWeight.w600),)),
                              ),
                              SizedBox(width: 2.w,),
                              Expanded(
                                //width: 12.w,
                                child: InkWell(
                                  onTap: () async {
                                    await showReplyBox(context, data.id, widget.post_id);
                                    setState(() {showMore[index] = true;});
                                  },
                                  child: Text("Odpovědět", style: getFont(11 .sp, "#00000", FontWeight.w600),overflow: TextOverflow.ellipsis,)),
                              ),
                            ],
                          )
                          ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        );
      }
    )
    :
    CupertinoActivityIndicator();
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*load == true ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                listComments[0].title,
                style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '${listComments[0].text}',
                style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.w300, color: Colors.black),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: InkWell(
                  onTap: () {
                    
                  },
                  child: Text("Zobrazit odpovědi", style: getFont(11 .sp, "#00000", FontWeight.w600),)),
                )

            ],
          ),
        )
      ],
    )
    : Container();*/
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
                  //SizedBox(width: 2.w,),
                  SizedBox(
                    width: 5.w,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0.h, right: 2.w), /// bottom: 0.5.h
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