import 'package:flutter/material.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HOST_API, //
      theme: Theme_Data.get_theme(),
      home: const Schedule_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Schedule_Page extends StatefulWidget {
  const Schedule_Page({super.key});

  @override
  State<Schedule_Page> createState() => _Schedule_PageState();
}

class _Schedule_PageState extends State<Schedule_Page> {
  @override
  void initState() {
    super.initState();
    print('Schedule Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Schedule Page Content Here'), //
          ],
        ),
      ),
    );
  }
}
