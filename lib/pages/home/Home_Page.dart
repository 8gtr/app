import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/routes/Left_Navigator.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
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
      theme: Theme_Data.get_theme(), //
      home: const Home_Page(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  String VERSION = '0.0.0+0';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final info = await PackageInfo.fromPlatform();
    VERSION = '${info.version}+${info.buildNumber}';
    debug(VERSION);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Home Page'),
            Text(
              VERSION,
              style: const TextStyle(
                fontSize: 12, //
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            const Text('More Information', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            const Text('(+855)12 407910'),
            const Text('infogtr@itc.edu.kh'),
            const Text('Address: Room J-504, Building J, ITC'),
            const Text('Facebook Page: facebook.com/itcgtr'),
          ],
        ),
      ),
      drawer: Left_Navigator(),
    );
  }
}
