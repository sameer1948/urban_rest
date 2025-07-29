// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_rest/database/service/transitionService.dart';
import 'package:urban_rest/model/transition.dart';
import 'package:urban_rest/pages/bed_page.dart';
import 'package:urban_rest/pages/customer_page.dart';
import 'package:urban_rest/pages/settings_page.dart';
import 'package:urban_rest/pages/bill_page.dart';
import 'package:urban_rest/pages/status_page.dart';
import 'package:urban_rest/providers/transition_provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  final List<Widget> pages = [
    BedPage(),
    CustomerPage(),
    StatusPage(),
    BillPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transitionProvider = Provider.of<TransitionProvider>(context);
    final transitionStyle = transitionProvider.activeStyle;
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return getTransition(child, animation, transitionStyle);
        },
        child: KeyedSubtree(
          // Required to properly trigger animations between pages
          key: ValueKey<int>(currentIndex),
          child: pages[currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == currentIndex) return;
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Beds'),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_3),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget getTransition(
    Widget child,
    Animation<double> animation,
    String style,
  ) {
    switch (style) {
      case 'fade':
        return FadeTransition(opacity: animation, child: child);

      case 'slide':
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case 'slide_left':
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case 'slide_up':
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case 'slide_down':
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case 'scale':
        return ScaleTransition(scale: animation, child: child);

      case 'rotation':
        return RotationTransition(turns: animation, child: child);

      case 'slide_fade':
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.5, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case 'scale_fade':
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );

      case 'rotation_scale':
        return RotationTransition(
          turns: animation,
          child: ScaleTransition(scale: animation, child: child),
        );

      case 'flip_horizontal':
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final angle = animation.value * 3.14; // π radians = 180 degrees
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(angle),
              child: child,
            );
          },
        );

      case 'flip_vertical':
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final angle = animation.value * 3.14;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateX(angle),
              child: child,
            );
          },
        );

      default:
        return FadeTransition(opacity: animation, child: child);
    }
  }
}
