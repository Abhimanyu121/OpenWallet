import 'package:flutter/material.dart';

class TabIconData {
  String imagePath;
  String selctedImagePath;
  bool isSelected;
  Icon selectedIcon;
  int index;
  Icon icon;
  AnimationController animationController;

  TabIconData({
    this.imagePath = '',
    this.icon,
    this.selectedIcon,
    this.index = 0,
    this.selctedImagePath = "",
    this.isSelected = false,
    this.animationController,
  });

  static List<TabIconData> tabIconsList = [
    TabIconData(
      imagePath: 'assets/fitness_app/tab_1.png',
      selctedImagePath: 'assets/fitness_app/tab_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_2.png',
      selctedImagePath: 'assets/fitness_app/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,

    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_3.png',
      selctedImagePath: 'assets/fitness_app/tab_3s.png',
      index: 2,
      isSelected: false,
      animationController: null,

    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_4.png',
      selctedImagePath: 'assets/fitness_app/tab_4s.png',
      index: 3,
      isSelected: false,
      animationController: null,

    ),
    TabIconData(
      icon: Icon(
        Icons.add
      ),
      selectedIcon: Icon(Icons.clear),
      selctedImagePath: 'assets/fitness_app/tab_4s.png',
      index:5,
      isSelected: false,
      animationController: null
    )
  ];
}
