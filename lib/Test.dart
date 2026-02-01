import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/utilities/Asset.dart';
import 'package:gtr_app/utilities/Debug.dart';

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
      home: const Test(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<List<String>> data = [];

  @override
  void initState() {
    super.initState();

    load_csv('contributors/data.csv') //
        .then((d) {
          data = d;
          debug("CSV Data loaded: $data");
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Text(data[0][0]), //
                      // Text(data[0][1]), //
                      // Text(data[0][2]), //
                      // Text(data[0][3]), //
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      drawer: const Navigator_Left(),
    );
  }
}
