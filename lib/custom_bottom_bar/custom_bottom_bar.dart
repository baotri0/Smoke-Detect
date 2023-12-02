import 'package:detect_smoke/screen/home/log_screeend.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screen/account_screen/account_screen.dart';
import '../screen/home/home_screen.dart';


class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({final Key? key,})
      : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  PersistentTabController _controller =PersistentTabController();
  bool _hideNavBar = false;

  List<Widget> _buildScreens() => [
    Home(),
    LogScreen(),
    AccountScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        inactiveIcon: Icon(Icons.home_outlined),
        title: "Home",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      inactiveIcon: Icon(Icons.warning_outlined),
      title: "Home",
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      inactiveIcon: Icon(Icons.person_outline),
      title: "Profile",
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,),
  ];

  @override
  Widget build(final BuildContext context) => Scaffold(
    body: PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      resizeToAvoidBottomInset: true,
      navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
          ? 0.0
          : kBottomNavigationBarHeight,
      bottomScreenMargin: 0,

      backgroundColor: Theme.of(context).primaryColor,
      hideNavigationBar: _hideNavBar,
      decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
      ),
      navBarStyle: NavBarStyle
          .style1, // Choose the nav bar style with this property
    ),
  );
}