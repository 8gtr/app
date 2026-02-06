import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gtr_app/routes/Navigator_Bottom.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';
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
      theme: Theme_Data.get_theme(),
      home: const Navigator_Bottom_Page(), //
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
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
    //
    List<Widget> images = [
      Image.network('$MINIO_PUBLIC/banner/image_1.jpeg'), //
      Image.network('$MINIO_PUBLIC/banner/image_2.jpeg'), //
      Image.network('$MINIO_PUBLIC/banner/image_3.png'), //
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to GTR App'), //
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  Text('Welcome to GTR App Home Page'), //
                  // Container(
                  //   child: CarouselSlider(
                  //     options: CarouselOptions(
                  //       aspectRatio: 2.0, //
                  //       enlargeCenterPage: true,
                  //       enableInfiniteScroll: false,
                  //       initialPage: 2,
                  //       autoPlay: true,
                  //     ),
                  //     items: images,
                  //   ),
                  // ),
                  CarouselSlider(
                    options: CarouselOptions(enlargeCenterPage: true, autoPlay: true),
                    items: images.map((item) => Center(child: item)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Navigator_Left(),
    );
  }
}
