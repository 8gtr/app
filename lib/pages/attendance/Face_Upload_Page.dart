import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtr_app/Environment.dart';
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
      theme: Theme_Data.get_theme(), //
      home: const FaceScanUploadPage(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class FaceScanUploadPage extends StatefulWidget {
  const FaceScanUploadPage({super.key});

  @override
  State<FaceScanUploadPage> createState() => FaceScanUploadPageState();
}

class FaceScanUploadPageState extends State<FaceScanUploadPage> {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 5), //
    ),
  );

  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  String? access_token;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    access_token = await secure_storage.read(key: "access_token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Scan Upload Page")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: TextField(), //
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: TextField(), //
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Item $index"), //

                      trailing: Icon(Icons.face), //
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.upload), //
      ),
    );
  }
}

void pprint(dynamic data) {
  const encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(data));
}

void show_snackbar_message({
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
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
