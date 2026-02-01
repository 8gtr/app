import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';
import 'package:gtr_app/utilities/Debug.dart';

void main() {
  runApp(const Contributor());
}

class Contributor extends StatelessWidget {
  const Contributor({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HOST_API, //
      theme: Theme_Data.get_theme(),
      home: const Contributor_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Contributor_Page extends StatefulWidget {
  const Contributor_Page({super.key});

  @override
  State<Contributor_Page> createState() => _Contributor_PageState();
}

class _Contributor_PageState extends State<Contributor_Page> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  FlutterSecureStorage secure_storage = FlutterSecureStorage();
  String? access_token;

  List<Map<String, String>> samples = [
    {
      'index': '1', //
      'name': 'John Doe', //
      'title': 'Code, Documentation',
    },
    {
      'index': '2', //
      'name': 'Jane Smith', //
      'title': 'Design, Testing',
    },
    {
      'index': '3', //
      'name': 'Alice Johnson', //
      'title': 'Project Management',
    },
  ];

  @override
  void initState() {
    super.initState();
    debug('Contributor Page Loaded');
    init();
  }

  void init() async {
    access_token = await secure_storage.read(key: 'access_token');
    debug("Access Token: $access_token");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contributor Page")),
      body: Center(
        child: SizedBox(
          width: 600,
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = samples.removeAt(oldIndex);
              samples.insert(newIndex, item);
              setState(() {});
            },
            children: [
              for (int i = 0; i < samples.length; i++)
                ListTile(
                  key: ValueKey(samples[i]['index']),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReorderableDragStartListener(index: i, child: Icon(Icons.drag_indicator)),
                      SizedBox(width: 8),
                      Container(width: 50, height: 100, color: Colors.grey),
                    ],
                  ),
                  title: Text('${i + 1}. ${samples[i]['name']}'),
                  subtitle: Text(samples[i]['title']!),
                  trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  onTap: () {},
                ),

              //
              Row(
                key: ValueKey('add_contributor'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  OutlinedButton.icon(
                    onPressed: () {}, //
                    icon: Icon(Icons.add),
                    label: Text("Add Contributor"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
