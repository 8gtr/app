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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  ListTile(leading: Icon(Icons.phone), title: Text('(+855)12 407910')),
                  ListTile(leading: Icon(Icons.email), title: Text('infogtr@itc.edu.kh')),
                  ListTile(leading: Icon(Icons.location_on), title: Text('Room J-504, Building J, ITC')),
                  ListTile(leading: Icon(Icons.facebook), title: Text('facebook.com/itcgtr')),

                  SizedBox(height: 20),

                  // todo: put google map here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
