import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:slavia_app/models/ForumPost-model.dart';
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
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> with TickerProviderStateMixin{
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  final _tagController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> items = [
  'Nejnovější',
  'Nejlepší',
  ];
  var createNewTag = false;
  var loading = false;
  var load = false;
  var current_sort = "";
  var dialog_load = false;
  @override
  void initState() {
    checkPosts();
    print(forumPosts.length);
    //super.initState();
    /*if (forumPosts.length == 0) {
      getForumPost(forumPosts.length, forumPosts.length + 20);
      setState(() {
        
      });
    }*/
    //_scrollController.position.maxScrollExtent+300;
    _scrollController.addListener((_scrollListener));
    
  }
  Future<void> _scrollListener() async{
    print(_scrollController.position.maxScrollExtent);
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent/* + 20.h*/) {
        loading = true;
          setState(() {
          });
        getMorePosts();
        //if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          /*print("ted");
          loading = true;
          setState(() {
            
          });
          print("ted" + loading.toString());
          await Future.delayed(Duration(seconds: 1));
          loading = false;
          setState(() {
            
          });*/
          /*setState(() {
            
          });*/
          //getMorePosts();
        //}
      }
  }

  Future<void> getMorePosts() async {
    await getForumPost(forumPosts.length, forumPosts.length + 20);
    //await Future.delayed(Duration(seconds: 5));
    print(forumTags);
    loading = false;
    setState(() {});
  }

  Future<void> checkPosts() async {
    if (forumPosts.length == 0) {
      await getForumPost(forumPosts.length, forumPosts.length + 20);
      if (forumPost_enable == false) {
        AnimatedSnackBar.material(
          'Nemáte připojení k internetu. Sekce diskuze nebude fungovat',
          type: AnimatedSnackBarType.error,
      ).show(context);
      }
      print(forumPosts.length);
      setState(() {});
    }
  }

  Future<void> refreshScreen() async {
    await getMorePosts();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    forumPosts.clear();
    super.dispose();
  }

  String? selectedValue_sort;
  String? selectedValue_filter;
  @override
  Widget build(BuildContext context) {
    var user_setting = Hive.box("user_setting");
    var id = user_setting.get("user_id");
    TabController _tabController = TabController(length: 2, vsync: this);
    if (dialog_load == false) {
    var user_setting = Hive.box("user_setting");
    var isAllow = user_setting.get("username");
    if (isAllow == null || isAllow == false) {
      Future.delayed(Duration.zero, () => showAlert(context));
      dialog_load = true;
    }
      //user_setting.put("notification-allow", true);
    }
    /*return FutureBuilder(
      future: checkPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          */return Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 4 .h, child: Text("Komunita", style: getFont(18.sp, "#00000", FontWeight.w600),)),
                      /*Padding(
                        padding: EdgeInsets.only(top: 4.h, left: 3.w, right:  3.w),
                        child: Container(
                          height: 10.h,
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
                        ),
                      ),*/
                      SizedBox(height: 2.h,),
                      Container(
                        alignment: Alignment.center,
                        //color: Colors.deepOrange,
                        //padding: EdgeInsets.symmetric(horizontal: 20.w),
                        width: 100.w,
                        height: 5.h,
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicatorColor: Colors.green,
                          tabs: [
                            Container(
                              width: 30.w,
                              height: 5.h,
                              child: Center(child: Text("Příspěvky",textAlign: TextAlign.center /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                            ),
                            Container(
                              width: 30.w,
                              height: 5.h,
                              child: Center(child: Text("Vaše Příspěvky",textAlign: TextAlign.center, /*style: getFont(10.sp, "#000000", FontWeight.w500),*/)),
                            ),
                          ],
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          indicator: RectangularIndicator(
                            bottomLeftRadius: 100,
                            bottomRightRadius: 100,
                            topLeftRadius: 100,
                            topRightRadius: 100,
                            color: HexColor("#e4041f"),
                            horizontalPadding: 4.w
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Container(
                        width: 100.w,
                        height: 4.h,
                        //color: Colors.amber,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 2.w),
                              //color: Colors.red,
                              width: 30.w,
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    isDense: true,
                                    hint: Text(
                                      'Seřadit',
                                      style: getFont(14.sp, "#ABB2B9", FontWeight.w500)
                                    ),
                                    items: items.map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: getFont(13.sp, "#ABB2B9", FontWeight.w500)
                                      ),
                                    )).toList(),
                                    value: selectedValue_sort,
                                    onChanged: (value) async {
                                      selectedValue_sort = value as String;
                                        if (selectedValue_sort == "Nejnovější") {
                                          await sortForumPost(0);
                                        }
                                      setState(() {});
                                    },
                                    iconStyleData: IconStyleData(
                                      icon: Icon(Ionicons.chevron_down_outline, size: 17.sp, color: HexColor("#ABB2B9"),)
                                    ),
                                    buttonStyleData: ButtonStyleData(
                                      width: 5.w,
                                      height: 3.h
                                      //height: 20,
                                      //width: 70,
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      height: 5.h,
                                      padding: null
                                      //padding: EdgeInsets.only(left: 2.w),
                                      
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 20.h,
                                      width: 28.w,
                                      padding: null,
                                      //padding: EdgeInsets.only(left: 2.w),
                                      //scrollPadding: EdgeInsets.only(left: 2.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        //color: Colors.redAccent,
                                      ),
                                      //elevation: 8,
                                      offset: Offset(1.w, -1.h),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness: MaterialStateProperty.all(6),
                                        thumbVisibility: MaterialStateProperty.all(true),
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 28 .w),
                            Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: Container(
                                width: 40.w,
                                //color: Colors.blue,
                                //padding: EdgeInsets.only(left: 0.w, right: 2.w),
                                //alignment: Alignment.centerRight,
                                child: MultiSelectDropDown(
                                  selectedOptionIcon: const Icon(Icons.check_circle),
                                  selectedItemBuilder: (p0, p1) {
                                    return Container(
                                      //height: 2.h,
                                      //width: 1.w,
                                      padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 1.w),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Text(p1.label, style: getFont(12.sp, "#FFFFFF", FontWeight.w600),),
                                    );
                                  },
                                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                                  onOptionSelected: (selectedOptions) async {
                                    print(selectedOptions);
                                    await filterForumPost(selectedOptions.map((e) => e.label).toList());
                                    setState(() {
                                      
                                    });
                                  }, 
                                  options: forumTags.map((e) => ValueItem(label: e)).toList(),
                                  borderWidth: 0.w,
                                  borderColor: Colors.transparent,
                                  hint: "Filtrovat",
                                  hintStyle: getFont(14.sp, "#ABB2B9", FontWeight.w500),
                                  suffixIcon: Ionicons.chevron_down_outline,
                                  suffixIconColor: HexColor("#ABB2B9"),
                                  suffixIconSize: 17.sp,
                                  showClearIcon: false,
                                  //inputDecoration: BoxDecoration(color: Colors.green),
                                  //suffixIcon: Ionicons.chevron_down_outline
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Expanded(
                        //width: 100.w,
                        //height: 71.h,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                              width: 100.w,
                              height: 100.h,
                              child: ListView.builder(
                                  //itemExtent: 80,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  itemCount: loading ? forumPosts.length + 1 :forumPosts.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    if (index == forumPosts.length) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 3.h,bottom: 5.h),
                                        child: Center(child: SizedBox(width: 20.w, child: LoadingAnimationWidget.staggeredDotsWave(color: HexColor("#ABB2B9"), size: 20.sp)))//CupertinoActivityIndicator(),
                                      );
                                      /*loading == true ? Padding(
                                        padding: EdgeInsets.only(top: 3.h),
                                        child: CupertinoActivityIndicator(),
                                      ) : Container();*/
                                    }
                                    return ForumPostModel(post_data: forumPosts[index],);

                                    //Post data = tabList1[index];
                                    //return ForumPostModel();
                                    //return ModelPost(title: data.title, text: data.text, image: data.image_url, tag: data.tag, date: data.date, url: data.url,);
                                  }),
                                ),
                            ),
                            Container(
                              width: 100.w,
                              height: 100.h,
                              child: ListView.builder(
                                  //itemExtent: 80,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  itemCount: loading ? forumPosts.where((element) => element.user_id == id).toList().length + 1 :forumPosts.where((element) => element.user_id == id).toList().length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    var user_setting = Hive.box("user_setting");
                                    var id = user_setting.get("user_id");
                                    var post = forumPosts.where((element) => element.user_id == id).toList()[index];
                                    if (index == forumPosts.length) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 3.h,bottom: 5.h),
                                        child: Center(child: SizedBox(width: 20.w, child: LoadingAnimationWidget.staggeredDotsWave(color: HexColor("#ABB2B9"), size: 20.sp)))//CupertinoActivityIndicator(),
                                      );
                                      /*loading == true ? Padding(
                                        padding: EdgeInsets.only(top: 3.h),
                                        child: CupertinoActivityIndicator(),
                                      ) : Container();*/
                                    }
                                    return ForumPostModel(post_data: post,);

                                    //Post data = tabList1[index];
                                    //return ForumPostModel();
                                    //return ModelPost(title: data.title, text: data.text, image: data.image_url, tag: data.tag, date: data.date, url: data.url,);
                                  }),
                                ),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.h, right: 5.w),
                    child: InkWell(
                      onTap: () {
                        showCreatePost(context);
                      },
                      child: Container(
                        width: 14.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(child: Icon(Ionicons.add_outline,size: 22.sp,)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
  void showAlert(BuildContext context) {
    showDialog(
      context: context, 
      builder:(context) {
        return AskNotificationDialog();
      },
    );
  }
  void showCreatePost(BuildContext context) {
    showDialog(
      context: context, 
      builder:(context) {
        return Dialog(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: Alignment.bottomCenter,
          child: Container(
            height: 40.h,
              width: 100.w,
              //color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                      child: Text("Vytvořit příspěvek", style: getFont(15.sp, "#00000", FontWeight.w600)),
                    ),
                    SizedBox(height: 2.h,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                      width: 90.w,
                      child: TextField(
                        //autofocus: true,
                        controller: _titleController,
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
                          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.5.w),
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
                          hintText: "Titulek",
                          hintStyle: getFont(15.sp, "#00000", FontWeight.w500)
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                      width: 90.w,
                      //height: 20.h,
                      child: TextField(
                        //autofocus: true,
                        controller: _textController,
                        onEditingComplete: () async{
                          //var userText = _textController.text;
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
                          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.5.w),
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
                          hintText: "Obsah",
                          hintStyle: getFont(15.sp, "#00000", FontWeight.w500)
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                      child: Container(
                        width: 90.w,
                        //height: 4.h,
                        /*decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),*/
                        child: TypeAheadField( 
                          direction: AxisDirection.up,  
                          noItemsFoundBuilder: (context) =>  SizedBox(
                            height: 4.h,
                            child: Center(
                              child: Text('Vytvořit nový tag'),
                            ),
                          ),
                          suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                              color: Colors.white,
                              elevation: 4.0,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          debounceDuration: const Duration(milliseconds: 400),
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _tagController,
                            onEditingComplete: () async{
                              //var userText = _textController.text;
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
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.5.w),
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
                              hintText: "Tag",
                              hintStyle: getFont(15.sp, "#00000", FontWeight.w500)
                            ),
                          ),
                          suggestionsCallback: (value) async {
                            return await getSuggestions(value);
                          },
                          itemBuilder: (context, String suggestion) {
                            print(suggestion);
                             return Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.refresh,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      suggestion,
                                      maxLines: 1,
                                      // style: TextStyle(color: Colors.red),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            );/*ListTile(
                              leading: Icon(Icons.shopping_cart),
                              title: Text(suggestion)
                            );*/
                          },
                          onSuggestionSelected: (String suggestion) {
                            setState(() {
                              _tagController.text = suggestion;
                              createNewTag = true;
                            });
                          },
                        )),
                                //height: 20.h,
                                
                      ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: SizedBox(
                          height: 4.h,
                          width: 42.w,
                          child: ElevatedButton(
                            onPressed:() async {
                              await createForumPost(_titleController.text, _textController.text, _tagController.text);
                              await refreshScreen();
                              Navigator.of(context).pop();
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#e4041f"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                                )
                            ),
                            child: Text("Vytvořit příspěvek", style: getFont(14.sp, "#FFFFFF", FontWeight.w600)),
                          ),
                        ),
                      ),
                    )
                    //SizedBox(width: 2.w,),
                    /*SizedBox(
                      width: 5.w,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1.h, right: 2.w),
                          child: InkWell(
                            onTap:() {
                              var userText = _textController.text;
                              print(userText);
                            }, 
                            child: Icon(Ionicons.send_outline, size: 16.sp,)),
                        ),
                      )
                    )*/
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(forumTags);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class CreatePostDialog extends StatelessWidget {
  const CreatePostDialog({super.key});
  
  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    var user_setting = Hive.box("user_setting");
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
          width: 70.w,
          height: 30.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            //Container(height: 30.h,width: 80.w, child: Center(child: Lottie.asset('assets/other/notification1.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
              child: Container(child: Text("Aby jste mohli používat sekci Diskuze, musíte si nejprve zvolit jméno pod kterým budete vystupovat", style: getFont(14.sp, "#00000", FontWeight.w600), softWrap: true,textAlign: TextAlign.center,)),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
              width: 90.w,
              //height: 20.h,
              child: TextField(
                maxLength: 50,
                //autofocus: true,
                textAlign: TextAlign.center,
                controller: _usernameController,
                onEditingComplete: () async{
                  //var userText = _usernameController.text;
                  //print(userText);
                  //await createForumComment(widget.parent_id, widget.post_id, userText);
                  //print(userText + "                                " + "send");
                  //widget.callback;
                },
                style: getFont(14.sp, "#00000", FontWeight.w500),
                maxLines: null,
                //cursorColor: Colors.black,
                textAlignVertical: TextAlignVertical.bottom,
                textInputAction: TextInputAction.done,
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
                  hintText: "Jméno",
                  hintStyle: getFont(14.sp, "#00000", FontWeight.w500)
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: SizedBox(
                  height: 4.h,
                  width: 30.w,
                  child: ElevatedButton(
                    onPressed:() async {
                      var user_setting = Hive.box("user_setting");
                      user_setting.put("username", _usernameController.text);
                      //var isAllow = user_setting.get("username");
                      Navigator.of(context).pop();
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#e4041f"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    child: Text("Uložit", style: getFont(14.sp, "#FFFFFF", FontWeight.w600)),
                  ),
                ),
              ),
            )
            ],   
          ),
        ),
      );
  }
}
























class AskNotificationDialog extends StatelessWidget {
  const AskNotificationDialog({super.key});
  
  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    var user_setting = Hive.box("user_setting");
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
          width: 70.w,
          height: 30.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            //Container(height: 30.h,width: 80.w, child: Center(child: Lottie.asset('assets/other/notification1.json', fit: BoxFit.fitHeight, frameRate: FrameRate.max))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
              child: Container(child: Text("Aby jste mohli používat sekci Diskuze, musíte si nejprve zvolit jméno pod kterým budete vystupovat", style: getFont(14.sp, "#00000", FontWeight.w600), softWrap: true,textAlign: TextAlign.center,)),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
              width: 90.w,
              //height: 20.h,
              child: TextField(
                maxLength: 50,
                //autofocus: true,
                textAlign: TextAlign.center,
                controller: _usernameController,
                onEditingComplete: () async{
                  //var userText = _usernameController.text;
                  //print(userText);
                  //await createForumComment(widget.parent_id, widget.post_id, userText);
                  //print(userText + "                                " + "send");
                  //widget.callback;
                },
                style: getFont(14.sp, "#00000", FontWeight.w500),
                maxLines: null,
                //cursorColor: Colors.black,
                textAlignVertical: TextAlignVertical.bottom,
                textInputAction: TextInputAction.done,
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
                  hintText: "Jméno",
                  hintStyle: getFont(14.sp, "#00000", FontWeight.w500)
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: SizedBox(
                  height: 4.h,
                  width: 30.w,
                  child: ElevatedButton(
                    onPressed:() async {
                      var user_setting = await Hive.box("user_setting");
                      user_setting.put("username", _usernameController.text);
                      //var isAllow = user_setting.get("username");
                      Navigator.of(context).pop();
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#e4041f"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    child: Text("Uložit", style: getFont(14.sp, "#FFFFFF", FontWeight.w600)),
                  ),
                ),
              ),
            )
            //SizedBox(height: 5.h),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                width: 24.w,
                height: 7.w,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#e4041f"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                  ),
                  child: Text("Ne"),
                ),
              ),
              Container(
                width: 24.w,
                height: 7.w,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    user_setting.put("notification-allow", true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#e4041f"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    )
                  ),
                  child: Text("Ano"),
                ),
              ),
              ],
            )*/
            ],   
          ),
        ),
      );
  }
}