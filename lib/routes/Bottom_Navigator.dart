import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/pages/home/Home_Page.dart';
import 'package:gtr_app/pages/profile/Profile_Page.dart';

import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Left_Navigator.dart';

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
      home: const Bottom_Navigator_Page(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class Bottom_Navigator_Page extends StatefulWidget {
  const Bottom_Navigator_Page({super.key});

  @override
  State<Bottom_Navigator_Page> createState() => _Bottom_Navigator_PageState();
}

class _Bottom_Navigator_PageState extends State<Bottom_Navigator_Page> {
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
          Left_Navigator.close_drawer(context);
          setState(() {});
        },
      ),
    );
  }
}
