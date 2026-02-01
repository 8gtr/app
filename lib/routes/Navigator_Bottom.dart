import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/pages/home/Home_Page.dart';
import 'package:gtr_app/pages/profile/Profile_Page.dart';

import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(), //
      home: const Navigator_Bottom_Page(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class Navigator_Bottom_Page extends StatefulWidget {
  const Navigator_Bottom_Page({super.key});

  @override
  State<Navigator_Bottom_Page> createState() => _Navigator_Bottom_PageState();
}

class _Navigator_Bottom_PageState extends State<Navigator_Bottom_Page> {
  //
  int _nav_index = 0;

  final List<Widget> _nav_pages = [
    Home_Page(), //
    Profile_Page(), //
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: IndexedStack(index: _nav_index, children: _nav_pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _nav_index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) {
            _nav_index = 0;
          } else if (index == 1) {
            _nav_index = 1;
          }
          Navigator_Left.close_drawer(context);
          setState(() {});
        },
      ),
    );
  }
}
