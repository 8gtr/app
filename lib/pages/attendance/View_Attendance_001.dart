import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:gtr_app/Environment.dart';
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
      home: const View_Attendance_001(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class View_Attendance_001 extends StatefulWidget {
  const View_Attendance_001({super.key});

  @override
  State<View_Attendance_001> createState() => _View_Attendance_001State();
}

class _View_Attendance_001State extends State<View_Attendance_001> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> search_data = [];

  bool is_search = false;

  TextEditingController c_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    dio
        .post(
          '/attendance/view',
          data: FormData.fromMap({}), //
        )
        .then((r) {
          data = List<Map<String, dynamic>>.from(r.data);
          search_data = List<Map<String, dynamic>>.from(r.data);
          // debug(response);
          setState(() {});
        })
        .catchError((_) {
          // show_snackbar_message(context: context, message: "Error", color: Colors.red);
        });
  }

  Timer? _debounce;

  void search(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (data.isEmpty) {
        search_data = [];
        setState(() {});
        return;
      }
      final searchLower = value.toLowerCase();
      search_data = data.where((d) {
        for (var key in d.keys) {
          if (d[key]?.toString().toLowerCase().contains(searchLower) ?? false) {
            return true;
          }
        }
        return false;
      }).toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    c_search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: is_search
            ? TextField(
                controller: c_search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  border: InputBorder.none, //
                ),
                onChanged: (value) {
                  search(value);
                },
              )
            : Text("View Attendance"), //
        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          IconButton(
            onPressed: () {
              is_search = !is_search;
              if (!is_search) {
                c_search.clear();
                search('');
              }
              setState(() {});
            },
            icon: is_search ? Icon(Icons.close) : Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 0, bottom: 8),
        child: Center(
          child: SizedBox(
            width: 600,
            child: search_data.isEmpty
                ? SizedBox.shrink()
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft, //
                              child: Text(
                                "Student Name", //
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            width: 50, //
                            alignment: Alignment.center,
                            child: Text(
                              "Code", //
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 50, //
                            alignment: Alignment.center,
                            child: Text(
                              "Type", //
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 100, //
                            alignment: Alignment.center,
                            child: Text(
                              "Scanned At", //
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                      SizedBox(height: 8),

                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: search_data.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft, //
                                      child: Text(
                                        search_data[index][search_data[0].keys.elementAt(0)].toString(), //
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50, //
                                    alignment: Alignment.center,
                                    child: Text(search_data[index][search_data[0].keys.elementAt(1)].toString()),
                                  ),
                                  Container(
                                    width: 50, //
                                    alignment: Alignment.center,
                                    child: Text(search_data[index][search_data[0].keys.elementAt(2)].toString()),
                                  ),
                                  Container(
                                    width: 100, //
                                    alignment: Alignment.center,
                                    child: Text(search_data[index][search_data[0].keys.elementAt(3)].toString()),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
