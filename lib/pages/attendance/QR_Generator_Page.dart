import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/pages/attendance/Select_Class_Name.dart';
import 'package:gtr_app/pages/attendance/Select_Class_Type.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/utilities/Debug.dart';
import 'package:gtr_app/utilities/Token.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      home: QR_Generator_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class QR_Generator_Page extends StatefulWidget {
  const QR_Generator_Page({super.key});

  @override
  State<QR_Generator_Page> createState() => QR_Generator_PageState();
}

class QR_Generator_PageState extends State<QR_Generator_Page> {
  bool is_enable_scan = false;

  String class_name = "Select Class";
  String class_type = "Select Type";

  String qr = "";

  String? access_token;
  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  @override
  void initState() {
    super.initState();
    debug("QR_Generator_Page initState");
    init();
    update_qr_10s();
  }

  void init() async {
    access_token = await secure_storage.read(key: "access_token");
    dio.options.headers['Authorization'] = 'Bearer $access_token';
  }

  void update_qr_10s() {
    Future.delayed(Duration(seconds: 10), () async {
      if (is_enable_scan) {
        String token = generate_token();
        await dio
            .post(
              '/attendance/enable_qr_scan',
              data: FormData.fromMap({
                "code": token, //
                "class_name": class_name, //
                "class_type": class_type, //
              }),
            )
            .then((r) {
              qr = token;
              debug("Updated QR: $qr");
              setState(() {});
            })
            .catchError((e) {
              show_snackbar(context: context, message: "Error", color: Colors.red);
            });
      }
      update_qr_10s();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate QR Page")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // select class name
                  OutlinedButton(
                    child: Text(class_name),
                    onPressed: () {
                      if (is_enable_scan) {
                        show_snackbar(context: context, message: "Please disable QR scan first", color: Colors.red);
                        return;
                      }
                      Navigator //
                          .of(context)
                          .push(MaterialPageRoute(builder: (context) => Select_Class_Name()))
                          .then((o) {
                            if (o != null) {
                              class_name = o;
                              setState(() {});
                            }
                          });
                    },
                  ),

                  SizedBox(width: 8),

                  // select class type
                  OutlinedButton(
                    child: Text(class_type),
                    onPressed: () {
                      if (is_enable_scan) {
                        show_snackbar(context: context, message: "Please disable QR scan first", color: Colors.red);
                        return;
                      }
                      Navigator //
                          .of(context)
                          .push(MaterialPageRoute(builder: (context) => Select_Class_Type()))
                          .then((o) {
                            if (o != null) {
                              class_type = o;
                              setState(() {});
                            }
                          });
                    },
                  ),

                  SizedBox(width: 8),

                  // enable scan
                  if (!is_enable_scan)
                    OutlinedButton.icon(
                      icon: Icon(Icons.play_arrow, color: Colors.green),
                      label: Text("Enable", style: TextStyle(color: Colors.green)), //
                      onPressed: () async {
                        if (class_name == "Select Class") {
                          show_snackbar(context: context, message: "Please select Class Name", color: Colors.red);
                          return;
                        }

                        if (class_type == "Select Type") {
                          show_snackbar(context: context, message: "Please select Class Type", color: Colors.red);
                          return;
                        }

                        String token = generate_token();
                        await dio
                            .post(
                              '/attendance/enable_qr_scan',
                              data: FormData.fromMap({
                                "code": token, //
                                "class_name": class_name, //
                                "class_type": class_type, //
                              }),
                            )
                            .then((response) {
                              is_enable_scan = true;
                              qr = token;
                              debug("Enabled QR: $qr");
                              setState(() {});
                              show_snackbar(context: context, message: "QR enabled", color: Colors.green);
                            })
                            .catchError((error) {
                              show_snackbar(context: context, message: "Error", color: Colors.red);
                            });
                      },
                    ),

                  // disable scan
                  if (is_enable_scan)
                    OutlinedButton.icon(
                      icon: Icon(Icons.stop, color: Colors.red),
                      label: Text("Disable", style: TextStyle(color: Colors.red)), //
                      onPressed: () async {
                        await dio
                            .post(
                              '/attendance/disable_qr_scan', //
                              data: FormData.fromMap({}),
                            )
                            .then((response) {
                              is_enable_scan = false;
                              qr = "";
                              setState(() {});
                              show_snackbar(context: context, message: "QR disabled", color: Colors.green);
                            })
                            .catchError((error) {
                              show_snackbar(context: context, message: "Error", color: Colors.red);
                            });
                      },
                    ),
                ],
              ),
              if (is_enable_scan)
                Expanded(
                  child: QrImageView(
                    data: qr, //
                  ),
                ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
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
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
