import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';


final mainControllerProvider = StateNotifierProvider<MainController,int>((ref) {
  return MainController(0);
},);


class MainController extends StateNotifier<int> {
  MainController(super.state);

  void setPosition(int value) {
    state = value;
  }
}