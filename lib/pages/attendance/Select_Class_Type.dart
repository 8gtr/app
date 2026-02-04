import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/utilities/Debug.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HOST_API, //
      theme: Theme_Data.get_theme(),
      routes: Routes.routes,
      home: Select_Class_Type(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Select_Class_Type extends StatefulWidget {
  const Select_Class_Type({
    super.key, //
  });

  @override
  State<Select_Class_Type> createState() => _Select_Class_TypeState();
}

class _Select_Class_TypeState extends State<Select_Class_Type> {
  //
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  Timer? _debounce;
  TextEditingController c_search = TextEditingController();
  dynamic all_data;
  dynamic search_data;

  @override
  void initState() {
    super.initState();
    debug("Select_Class_Type initState");
    init();
  }

  void init() async {
    await dio
        .post(
          "/attendance/class_types", //
          data: FormData.fromMap({}),
        ) //
        .then((r) {
          all_data = r.data;
          search_data = r.data;
          // debug("Class Types: $search_data");
          setState(() {});
        })
        .catchError((_) {
          show_snackbar(context: context, message: "Error", color: Colors.red);
        });
  }

  void search(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (all_data == null || all_data.isEmpty) {
        search_data = [];
        setState(() {});
        return;
      }
      if (value.isEmpty) {
        search_data = all_data;
        setState(() {});
        return;
      }
      final searchLower = value.toLowerCase();
      search_data = all_data.where((item) {
        final className = item["class_type"]?.toString().toLowerCase() ?? '';
        return className.contains(searchLower);
      }).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: c_search,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search ...',
            border: InputBorder.none, //
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                c_search.clear();
                search('');
              },
            ),
          ),
          onChanged: (value) {
            search(value);
          },
        ), //
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
        // child: true
        child: search_data == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: search_data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 8, right: 8),
                    title: Text(search_data[index]["class_type"], overflow: TextOverflow.ellipsis),
                    // trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // debug(search_data[index]["class_type"]);
                      Navigator.of(context).pop(search_data[index]["class_type"]);
                    },
                  );
                },
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      //   child: Icon(Icons.arrow_back),
      // ),
    );
  }
}

void show_snackbar({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
