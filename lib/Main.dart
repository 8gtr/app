import 'package:flutter/material.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/routes/Bottom_Navigator.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/themes/Theme_Data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: const Bottom_Navigator_Page(), //
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
