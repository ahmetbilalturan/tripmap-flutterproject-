import 'package:flutter/material.dart';

class AddBottomNavBar {
  BottomNavigationBar bottomNavigationBar(
      PageController pageController,
      int currentIndex,
      Function(int index) function,
      List<BottomNavigationBarItem> bottomnavbaritems) {
    return BottomNavigationBar(
      fixedColor: const Color(0xff6C43BC),
      iconSize: 26,
      selectedIconTheme: const IconThemeData(
        color: Color(0xff6C43BC),
      ),
      unselectedIconTheme: const IconThemeData(
        color: Color(0xff6C43BC),
      ),
      type: BottomNavigationBarType.shifting,
      currentIndex: currentIndex,
      onTap: (index) => function(index),
      items: bottomnavbaritems,
    );
  }
}
