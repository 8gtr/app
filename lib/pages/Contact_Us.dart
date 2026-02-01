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
      home: const Contact_Us_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Contact_Us_Page extends StatefulWidget {
  const Contact_Us_Page({super.key});

  @override
  State<Contact_Us_Page> createState() => _Contact_Us_PageState();
}

class _Contact_Us_PageState extends State<Contact_Us_Page> {
  @override
  void initState() {
    super.initState();
    print('Contact Us Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Us Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contact Us Page Content Here'), //
          ],
        ),
      ),
    );
  }
}
